import os
import re
import shlex
import subprocess

class LogEntryParser:
    IP_INDEX = 0
    REQUESTED_URL_INDEX = 5 # Index of requested URL
    STATUS_CODE_INDEX = 6

    def parse_log_line(self, log_line):
        try:
            cleaned_line = re.sub(r"[\[\]]", "", log_line)
            log_data = shlex.split(cleaned_line)
            return {
                "client_ip": log_data[self.IP_INDEX],
                "requested_url": log_data[self.REQUESTED_URL_INDEX],  # Add requested URL
                "http_status_code": log_data[self.STATUS_CODE_INDEX],
            }
        except (IndexError, ValueError) as parse_error:
            print(f"Error parsing log line: {parse_error}")
            return None

def read_log_file(filepath):
    try:
        with open(filepath, "r") as log_file:
            for line in log_file:
                yield line.strip()
    except FileNotFoundError:
        print(f"Error: Log file '{filepath}' not found.")
        exit(1)

def ip_to_cidr_range(ip_address):
    octets = ip_address.split('.')
    octets[-1] = '0'
    return f"{'.'.join(octets)}/24"

def block_ip_address(ip_address):
    try:
        subprocess.run(f"nft add element ip blacklists blackhole {{ {ip_address} timeout 8h }} >/dev/null", shell=True, check=True)
        return True
    except subprocess.CalledProcessError as block_error:
        print(f"Error blocking IP {ip_address}: {block_error}")
        return False

def is_static_file(url):  # New function to check for static files
    static_extensions = (".png", ".jpg", ".jpeg", ".woff", ".gif", ".css", ".js", ".ico", ".svg") # Add more as needed
    for ext in static_extensions:
        if url.endswith(ext):
            return True
    return False

def process_access_logs(log_file_path):
    if not os.path.exists(log_file_path):
        print(f'Error: Could not find log file: {log_file_path}')
        return

    log_parser = LogEntryParser()
    blocked_ip_ranges = set()

    for log_line in read_log_file(log_file_path):
        parsed_entry = log_parser.parse_log_line(log_line)
        if parsed_entry is None:
            continue

        client_ip = parsed_entry.get("client_ip")
        status_code = parsed_entry.get("http_status_code")
        requested_url = parsed_entry.get("requested_url")  # Get requested URL

        if client_ip == '103.106.105.75':
            continue

        if status_code == '404' and not is_static_file(requested_url): #Check for 404 and non-static file
            cidr_range = ip_to_cidr_range(client_ip)
            if cidr_range not in blocked_ip_ranges:
                if block_ip_address(client_ip):
                    blocked_ip_ranges.add(cidr_range)

if __name__ == '__main__':
    log_file_path = "/usr/local/lsws/test8.wptangtoc-ols.one/logs/access.log"
    process_access_logs(log_file_path)

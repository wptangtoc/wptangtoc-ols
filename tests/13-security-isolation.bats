#!/usr/bin/env bats

# =================================================================
# WPTangToc OLS — Dynamic Security & Cross-Site Isolation Tests
# =================================================================

export VICTIM_DOMAIN="sec-victim.com"
export ATTACKER_DOMAIN="sec-attacker.com"
export EXTERNAL_HACKER="wptt_hacker"

# -----------------------------------------------------------------
# Helpers
# -----------------------------------------------------------------
log_error() {
    echo "" >&3
    echo "============================================================" >&3
    echo "[WPTT SECURITY TEST FAILURE]" >&3
    echo "Test : ${BATS_TEST_NAME:-unknown}" >&3
    echo "============================================================" >&3
    echo "$*" >&3
    echo "============================================================" >&3
}

assert_status_zero() {
    if [ "$status" -ne 0 ]; then
        log_error "Kỳ vọng lệnh được phép (Mã 0), nhưng thực tế bị chặn ($status)"
        echo "Output:" >&3
        echo "$output" >&3
        return 1
    fi
}

assert_status_nonzero() {
    if [ "$status" -eq 0 ]; then
        log_error "CẢNH BÁO ĐỎ: Lệnh nguy hiểm thực thi THÀNH CÔNG (Đáng lẽ phải bị chặn!)."
        echo "Output:" >&3
        echo "$output" >&3
        return 1
    fi
}

# =================================================================
# SETUP & TEARDOWN (Khởi tạo & Hủy diệt môi trường)
# =================================================================

setup_file() {
    # 1. Tạo user hacker ngoại đạo
    if ! id "$EXTERNAL_HACKER" >/dev/null 2>&1; then
        useradd -M -s /bin/bash "$EXTERNAL_HACKER" || true
    fi

    # 2. TỰ ĐỘNG KHỞI TẠO 2 WEBSITE
    if [[ -x "/etc/wptt/domain/wptt-themwebsite" ]]; then
        bash /etc/wptt/domain/wptt-themwebsite "$VICTIM_DOMAIN" >/dev/null 2>&1 || true
        bash /etc/wptt/domain/wptt-themwebsite "$ATTACKER_DOMAIN" >/dev/null 2>&1 || true
    fi

    # Mồi wp-config.php với user được trích xuất trực tiếp từ OS
    if [[ -d "/usr/local/lsws/$VICTIM_DOMAIN/html" ]]; then
        touch "/usr/local/lsws/$VICTIM_DOMAIN/html/wp-config.php"
        
        # TRÍCH XUẤT FOOLPROOF: Lấy chủ sở hữu thực sự của thư mục HTML
        THUC_TE_USER=$(stat -c '%U' "/usr/local/lsws/$VICTIM_DOMAIN/html")
        
        if [[ -n "$THUC_TE_USER" && "$THUC_TE_USER" != "UNKNOWN" ]]; then
            chown "$THUC_TE_USER:$THUC_TE_USER" "/usr/local/lsws/$VICTIM_DOMAIN/html/wp-config.php"
            chmod 600 "/usr/local/lsws/$VICTIM_DOMAIN/html/wp-config.php"
        fi
    fi
}

teardown_file() {
    userdel "$EXTERNAL_HACKER" >/dev/null 2>&1 || true

    if [[ -x "/etc/wptt/domain/wptt-xoawebsite" ]]; then
        bash /etc/wptt/domain/wptt-xoawebsite "$VICTIM_DOMAIN" >/dev/null 2>&1 || true
        bash /etc/wptt/domain/wptt-xoawebsite "$ATTACKER_DOMAIN" >/dev/null 2>&1 || true
    fi

    # Dọn bạo lực
    rm -rf "/usr/local/lsws/$VICTIM_DOMAIN" "/usr/local/lsws/$ATTACKER_DOMAIN" 2>/dev/null
    rm -rf "/usr/local/lsws/conf/vhosts/$VICTIM_DOMAIN" "/usr/local/lsws/conf/vhosts/$ATTACKER_DOMAIN" 2>/dev/null
    rm -f "/etc/wptt/vhost/.$VICTIM_DOMAIN.conf" "/etc/wptt/vhost/.$ATTACKER_DOMAIN.conf" 2>/dev/null
}

setup() {
    if [ "$(id -u)" -ne 0 ]; then skip "Security tests yêu cầu chạy bằng quyền root."; fi

    export VICTIM_ROOT="/usr/local/lsws/$VICTIM_DOMAIN/html"
    export ATTACKER_ROOT="/usr/local/lsws/$ATTACKER_DOMAIN/html"

    if [[ ! -d "$VICTIM_ROOT" || ! -d "$ATTACKER_ROOT" ]]; then
        skip "Lỗi khởi tạo: Thư mục HTML của 2 domain không tồn tại."
    fi

    # TRÍCH XUẤT TRỰC TIẾP TỪ HỆ THỐNG FILE (Không dùng file conf nữa)
    export VICTIM_USER=$(stat -c '%U' "$VICTIM_ROOT")
    export INTERNAL_ATTACKER_USER=$(stat -c '%U' "$ATTACKER_ROOT")

    if [[ -z "$VICTIM_USER" || "$VICTIM_USER" == "UNKNOWN" || -z "$INTERNAL_ATTACKER_USER" || "$INTERNAL_ATTACKER_USER" == "UNKNOWN" ]]; then
        skip "Lỗi khởi tạo: Không nhận diện được User sở hữu thư mục HTML."
    fi
}

# =================================================================
# PHẦN 1: TẤN CÔNG LÂY NHIỄM CHÉO (CROSS-SITE) BÊN TRONG HOSTING
# =================================================================

@test "Security Isolation: Cross-Site [Read]: User Web B KHÔNG THỂ đọc trộm wp-config.php của Web A" {
    run su -s /bin/bash "$INTERNAL_ATTACKER_USER" -c "cat -- '$VICTIM_ROOT/wp-config.php' 2>/dev/null"
    assert_status_nonzero
}

@test "Security Isolation: Cross-Site [Write]: User Web B KHÔNG THỂ ghi (tạo file) vào thư mục của Web A" {
    probe="$VICTIM_ROOT/.wptt-cross-site-probe"
    rm -f -- "$probe"

    run su -s /bin/bash "$INTERNAL_ATTACKER_USER" -c "printf '%s' 'HACKED_BY_WEB_B' > '$probe' 2>/dev/null"
    assert_status_nonzero

    if [ -e "$probe" ]; then
        rm -f -- "$probe"
        log_error "LỖ HỔNG NGHIÊM TRỌNG: User Web B ($INTERNAL_ATTACKER_USER) đã ghi đè thành công vào Web A ($VICTIM_DOMAIN)!"
        return 1
    fi
}

@test "Security Isolation: Cross-Site [Symlink]: User Web B KHÔNG THỂ đánh cắp dữ liệu của Web A thông qua Symlink" {
    symlink_target="$ATTACKER_ROOT/stolen_config.txt"
    rm -f -- "$symlink_target"

    run su -s /bin/bash "$INTERNAL_ATTACKER_USER" -c "ln -s '$VICTIM_ROOT/wp-config.php' '$symlink_target' 2>/dev/null"
    run su -s /bin/bash "$INTERNAL_ATTACKER_USER" -c "cat '$symlink_target' 2>/dev/null"
    
    rm -f -- "$symlink_target"
    assert_status_nonzero
}

# =================================================================
# PHẦN 2: TẤN CÔNG TỪ KẺ NGOẠI ĐẠO (EXTERNAL) VÀ KIỂM TRA HỆ THỐNG
# =================================================================

@test "Security Isolation: Hacker ngoại đạo (External) KHÔNG THỂ đọc được wp-config.php" {
    run su -s /bin/bash "$EXTERNAL_HACKER" -c "cat -- '$VICTIM_ROOT/wp-config.php' 2>/dev/null"
    assert_status_nonzero
}

@test "Security Isolation: Hacker ngoại đạo (External) KHÔNG THỂ ghi đè file vào Web" {
    probe="$VICTIM_ROOT/.wptt-security-write-probe"
    rm -f -- "$probe"
    run su -s /bin/bash "$EXTERNAL_HACKER" -c "printf '%s' 'HACKED' > '$probe' 2>/dev/null"
    assert_status_nonzero
    [ ! -e "$probe" ]
}

@test "Security Isolation: Web root thuộc đúng sở hữu của Vhost User" {
    owner="$(stat -c '%U' "$VICTIM_ROOT")"
    if [ "$owner" != "$VICTIM_USER" ]; then
        log_error "Sở hữu HTML root sai. Kỳ vọng=$VICTIM_USER Thực tế=$owner"
        return 1
    fi
}

@test "Security Isolation: Không có bất kỳ file/thư mục nào bị hớ hênh quyền World-Writable (777)" {
    run find "$VICTIM_ROOT" -xdev \( -type f -o -type d \) -perm /o+w -print
    assert_status_zero
    [[ -z "$output" ]]
}

@test "Security Isolation: OLS VHost cấu hình đúng extUser (PHP chạy độc lập cho từng user)" {
    OLS_VHOST_CONFIG="/usr/local/lsws/conf/vhosts/$VICTIM_DOMAIN/$VICTIM_DOMAIN.conf"
    run grep -E "^[[:space:]]*extUser[[:space:]]+$VICTIM_USER([[:space:]]|$)" "$OLS_VHOST_CONFIG"
    assert_status_zero
}

#!/usr/bin/env bats

# =================================================================
# WPTangToc OLS — Isolation Tests
# Cơ chế: Tự động tạo 2 website ảo -> Tấn công -> Dọn dẹp sạch sẽ
# =================================================================

export VICTIM_DOMAIN="sec-victim.com"
export ATTACKER_DOMAIN="sec-attacker.com"
export EXTERNAL_HACKER="wptt_hacker"

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
    # 1. Tạo user hacker ngoại đạo (Từ internet)
    if ! id "$EXTERNAL_HACKER" >/dev/null 2>&1; then
        useradd -M -s /bin/bash "$EXTERNAL_HACKER" || true
    fi

    # 2. TỰ ĐỘNG KHỞI TẠO 2 WEBSITE ĐỂ TEST CROSS-SITE
    if [[ -x "/etc/wptt/domain/wptt-themwebsite" ]]; then
        bash /etc/wptt/domain/wptt-themwebsite "$VICTIM_DOMAIN" >/dev/null 2>&1 || true
        bash /etc/wptt/domain/wptt-themwebsite "$ATTACKER_DOMAIN" >/dev/null 2>&1 || true
    fi

    # Mồi thêm wp-config.php cho Nạn nhân với QUYỀN BẢO MẬT CHUẨN (600)
    if [[ -d "/usr/local/lsws/$VICTIM_DOMAIN/html" ]]; then
        touch "/usr/local/lsws/$VICTIM_DOMAIN/html/wp-config.php"
        set +u
        source "/etc/wptt/vhost/.$VICTIM_DOMAIN.conf" 2>/dev/null
        if [[ -n "$User_name_vhost" ]]; then
            chown "$User_name_vhost:$User_name_vhost" "/usr/local/lsws/$VICTIM_DOMAIN/html/wp-config.php"
            chmod 600 "/usr/local/lsws/$VICTIM_DOMAIN/html/wp-config.php"
        fi
        set -u
    fi
}

teardown_file() {
    # 1. Xóa hacker ngoại đạo
    userdel "$EXTERNAL_HACKER" >/dev/null 2>&1 || true

    # 2. XÓA SẠCH 2 WEBSITE TEST ĐỂ KHÔNG LÀM RÁC SERVER
    if [[ -x "/etc/wptt/domain/wptt-xoawebsite" ]]; then
        bash /etc/wptt/domain/wptt-xoawebsite "$VICTIM_DOMAIN" >/dev/null 2>&1 || true
        bash /etc/wptt/domain/wptt-xoawebsite "$ATTACKER_DOMAIN" >/dev/null 2>&1 || true
    fi

    # Dọn dẹp bạo lực (Đề phòng)
    rm -rf "/usr/local/lsws/$VICTIM_DOMAIN" "/usr/local/lsws/$ATTACKER_DOMAIN" 2>/dev/null
    rm -rf "/usr/local/lsws/conf/vhosts/$VICTIM_DOMAIN" "/usr/local/lsws/conf/vhosts/$ATTACKER_DOMAIN" 2>/dev/null
    rm -f "/etc/wptt/vhost/.$VICTIM_DOMAIN.conf" "/etc/wptt/vhost/.$ATTACKER_DOMAIN.conf" 2>/dev/null
    
    set +u
    source "/etc/wptt/vhost/.$VICTIM_DOMAIN.conf" 2>/dev/null && userdel "$User_name_vhost" >/dev/null 2>&1
    source "/etc/wptt/vhost/.$ATTACKER_DOMAIN.conf" 2>/dev/null && userdel "$User_name_vhost" >/dev/null 2>&1
    set -u
}

setup() {
    if [ "$(id -u)" -ne 0 ]; then skip "Security tests yêu cầu chạy bằng quyền root."; fi

    export VICTIM_ROOT="/usr/local/lsws/$VICTIM_DOMAIN/html"
    export VICTIM_CONF="/etc/wptt/vhost/.$VICTIM_DOMAIN.conf"
    export ATTACKER_ROOT="/usr/local/lsws/$ATTACKER_DOMAIN/html"
    export ATTACKER_CONF="/etc/wptt/vhost/.$ATTACKER_DOMAIN.conf"

    if [[ ! -f "$VICTIM_CONF" || ! -f "$ATTACKER_CONF" ]]; then
        skip "Lỗi khởi tạo: wptt-themwebsite đã không tạo được 2 domain test."
    fi

    set +u
    source "$VICTIM_CONF"
    export VICTIM_USER="$User_name_vhost"
    source "$ATTACKER_CONF"
    export INTERNAL_ATTACKER_USER="$User_name_vhost"
    set -u

    if [[ -z "$VICTIM_USER" || -z "$INTERNAL_ATTACKER_USER" ]]; then
        skip "Lỗi khởi tạo: Không lấy được User Linux của 2 domain."
    fi
}

# =================================================================
# PHẦN 1: TẤN CÔNG LÂY NHIỄM CHÉO (CROSS-SITE) BÊN TRONG HOSTING
# =================================================================

@test "Cross-Site [Read]: User Web B KHÔNG THỂ đọc trộm wp-config.php của Web A" {
    run su -s /bin/bash "$INTERNAL_ATTACKER_USER" -c "cat -- '$VICTIM_ROOT/wp-config.php' 2>/dev/null"
    assert_status_nonzero
}

@test "Cross-Site [Write]: User Web B KHÔNG THỂ ghi (tạo file) vào thư mục của Web A" {
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

@test "Cross-Site [Symlink]: User Web B KHÔNG THỂ đánh cắp dữ liệu của Web A thông qua Symlink" {
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

@test "Security: Hacker ngoại đạo (External) KHÔNG THỂ đọc được wp-config.php" {
    run su -s /bin/bash "$EXTERNAL_HACKER" -c "cat -- '$VICTIM_ROOT/wp-config.php' 2>/dev/null"
    assert_status_nonzero
}

@test "Security: Hacker ngoại đạo (External) KHÔNG THỂ ghi đè file vào Web" {
    probe="$VICTIM_ROOT/.wptt-security-write-probe"
    rm -f -- "$probe"
    run su -s /bin/bash "$EXTERNAL_HACKER" -c "printf '%s' 'HACKED' > '$probe' 2>/dev/null"
    assert_status_nonzero
    [ ! -e "$probe" ]
}

@test "Security: Web root thuộc đúng sở hữu của Vhost User" {
    owner="$(stat -c '%U' "$VICTIM_ROOT")"
    if [ "$owner" != "$VICTIM_USER" ]; then
        log_error "Sở hữu HTML root sai. Kỳ vọng=$VICTIM_USER Thực tế=$owner"
        return 1
    fi
}

@test "Security: Không có bất kỳ file/thư mục nào bị hớ hênh quyền World-Writable (777)" {
    run find "$VICTIM_ROOT" -xdev \( -type f -o -type d \) -perm /o+w -print
    assert_status_zero
    [[ -z "$output" ]]
}

@test "Security: OLS VHost cấu hình đúng extUser (PHP chạy độc lập cho từng user)" {
    OLS_VHOST_CONFIG="/usr/local/lsws/conf/vhosts/$VICTIM_DOMAIN/$VICTIM_DOMAIN.conf"
    run grep -E "^[[:space:]]*extUser[[:space:]]+$VICTIM_USER([[:space:]]|$)" "$OLS_VHOST_CONFIG"
    assert_status_zero
}

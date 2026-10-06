#!/usr/bin/env bats

set -u

# -----------------------------------------------------------------
# TEST DOMAINS
# -----------------------------------------------------------------

export VICTIM_DOMAIN="${WPTT_TEST_VICTIM_DOMAIN:-sec-victim.wptt-test}"
export ATTACKER_DOMAIN="${WPTT_TEST_ATTACKER_DOMAIN:-sec-attacker.wptt-test}"

export VICTIM_USER="wptt_sec_victim"
export ATTACKER_USER="wptt_sec_attacker"
export EXTERNAL_HACKER="wptt_sec_external"

export VICTIM_ROOT="/usr/local/lsws/$VICTIM_DOMAIN/html"
export ATTACKER_ROOT="/usr/local/lsws/$ATTACKER_DOMAIN/html"

export VICTIM_VHOST_DIR="/usr/local/lsws/conf/vhosts/$VICTIM_DOMAIN"
export ATTACKER_VHOST_DIR="/usr/local/lsws/conf/vhosts/$ATTACKER_DOMAIN"

export VICTIM_WPTT_CONF="/etc/wptt/vhost/.$VICTIM_DOMAIN.conf"
export ATTACKER_WPTT_CONF="/etc/wptt/vhost/.$ATTACKER_DOMAIN.conf"

export VICTIM_OLS_CONF="$VICTIM_VHOST_DIR/$VICTIM_DOMAIN.conf"
export ATTACKER_OLS_CONF="$ATTACKER_VHOST_DIR/$ATTACKER_DOMAIN.conf"

# -----------------------------------------------------------------
# HELPERS
# -----------------------------------------------------------------

log_error() {
    echo "" >&3
    echo "============================================================" >&3
    echo "[WPTT SECURITY TEST FAILURE]" >&3
    echo "Test: ${BATS_TEST_NAME:-unknown}" >&3
    echo "============================================================" >&3
    echo "$*" >&3
    echo "============================================================" >&3
}

fail_setup() {
    echo "" >&3
    echo "============================================================" >&3
    echo "[WPTT SECURITY TEST SETUP FAILURE]" >&3
    echo "$*" >&3
    echo "============================================================" >&3
    return 1
}

assert_status_zero() {
    if [ "$status" -ne 0 ]; then
        log_error "Expected exit code 0, actual=$status"
        echo "Output:" >&3
        echo "$output" >&3
        return 1
    fi
}

assert_status_nonzero() {
    if [ "$status" -eq 0 ]; then
        log_error "SECURITY FAILURE: thao tác đáng lẽ phải bị chặn nhưng đã thành công."
        echo "Output:" >&3
        echo "$output" >&3
        return 1
    fi
}

require_root() {
    if [ "$(id -u)" -ne 0 ]; then
        fail_setup "Security isolation tests phải chạy bằng root."
        return 1
    fi
}

require_command() {
    command -v "$1" >/dev/null 2>&1 || {
        fail_setup "Thiếu command bắt buộc: $1"
        return 1
    }
}

# =================================================================
# SETUP FILE
# =================================================================

setup_file() {

    require_root || return 1

    require_command useradd || return 1
    require_command userdel || return 1
    require_command su || return 1
    require_command stat || return 1
    require_command find || return 1
    require_command grep || return 1

    # -------------------------------------------------------------
    # 1. Dọn fixture cũ
    # -------------------------------------------------------------

    rm -rf \
        "$VICTIM_ROOT" \
        "$ATTACKER_ROOT" \
        "$VICTIM_VHOST_DIR" \
        "$ATTACKER_VHOST_DIR"

    rm -f \
        "$VICTIM_WPTT_CONF" \
        "$ATTACKER_WPTT_CONF"

    # -------------------------------------------------------------
    # 2. Tạo user riêng biệt
    # -------------------------------------------------------------

    if id "$VICTIM_USER" >/dev/null 2>&1; then
        userdel "$VICTIM_USER" >/dev/null 2>&1 || true
    fi

    if id "$ATTACKER_USER" >/dev/null 2>&1; then
        userdel "$ATTACKER_USER" >/dev/null 2>&1 || true
    fi

    if id "$EXTERNAL_HACKER" >/dev/null 2>&1; then
        userdel "$EXTERNAL_HACKER" >/dev/null 2>&1 || true
    fi

    useradd \
        --system \
        --no-create-home \
        --shell /usr/sbin/nologin \
        "$VICTIM_USER" || {
            fail_setup "Không tạo được $VICTIM_USER"
            return 1
        }

    useradd \
        --system \
        --no-create-home \
        --shell /usr/sbin/nologin \
        "$ATTACKER_USER" || {
            fail_setup "Không tạo được $ATTACKER_USER"
            return 1
        }

    useradd \
        --system \
        --no-create-home \
        --shell /usr/sbin/nologin \
        "$EXTERNAL_HACKER" || {
            fail_setup "Không tạo được $EXTERNAL_HACKER"
            return 1
        }

    # -------------------------------------------------------------
    # 3. Tạo filesystem
    # -------------------------------------------------------------

    mkdir -p \
        "$VICTIM_ROOT" \
        "$ATTACKER_ROOT" \
        "$VICTIM_VHOST_DIR" \
        "$ATTACKER_VHOST_DIR" \
        "/etc/wptt/vhost"

    # -------------------------------------------------------------
    # 4. Ownership
    # -------------------------------------------------------------

    chown "$VICTIM_USER:$VICTIM_USER" "$VICTIM_ROOT"
    chown "$ATTACKER_USER:$ATTACKER_USER" "$ATTACKER_ROOT"

    chmod 755 "$VICTIM_ROOT"
    chmod 755 "$ATTACKER_ROOT"

    # -------------------------------------------------------------
    # 5. Tạo dữ liệu bí mật của Victim
    # -------------------------------------------------------------

    cat > "$VICTIM_ROOT/wp-config.php" <<'EOF'
<?php
define('DB_NAME', 'wptt_security_test');
define('DB_USER', 'victim_secret_user');
define('DB_PASSWORD', 'WPTT_TEST_SECRET_DO_NOT_USE');
EOF

    chown "$VICTIM_USER:$VICTIM_USER" \
        "$VICTIM_ROOT/wp-config.php"

    chmod 600 \
        "$VICTIM_ROOT/wp-config.php"

    # -------------------------------------------------------------
    # 6. Tạo file bình thường
    # -------------------------------------------------------------

    cat > "$VICTIM_ROOT/index.php" <<'EOF'
<?php
echo "WPTangToc Security Isolation Test";
EOF

    chown "$VICTIM_USER:$VICTIM_USER" \
        "$VICTIM_ROOT/index.php"

    chmod 644 \
        "$VICTIM_ROOT/index.php"

    # -------------------------------------------------------------
    # 7. Tạo WPTangToc metadata
    # -------------------------------------------------------------

    cat > "$VICTIM_WPTT_CONF" <<EOF
User_name_vhost="$VICTIM_USER"
EOF

    cat > "$ATTACKER_WPTT_CONF" <<EOF
User_name_vhost="$ATTACKER_USER"
EOF

    chmod 600 "$VICTIM_WPTT_CONF"
    chmod 600 "$ATTACKER_WPTT_CONF"

    # -------------------------------------------------------------
    # 8. Tạo OLS VHost configuration
    # -------------------------------------------------------------

    cat > "$VICTIM_OLS_CONF" <<EOF
extUser $VICTIM_USER
EOF

    cat > "$ATTACKER_OLS_CONF" <<EOF
extUser $ATTACKER_USER
EOF

    chmod 644 "$VICTIM_OLS_CONF"
    chmod 644 "$ATTACKER_OLS_CONF"

    # -------------------------------------------------------------
    # 9. Xác minh fixture trước khi cho test chạy
    # -------------------------------------------------------------

    [ -d "$VICTIM_ROOT" ] || {
        fail_setup "Victim root không tồn tại."
        return 1
    }

    [ -d "$ATTACKER_ROOT" ] || {
        fail_setup "Attacker root không tồn tại."
        return 1
    }

    [ -f "$VICTIM_ROOT/wp-config.php" ] || {
        fail_setup "Không tạo được wp-config.php."
        return 1
    }

    id "$VICTIM_USER" >/dev/null 2>&1 || {
        fail_setup "Victim user không tồn tại."
        return 1
    }

    id "$ATTACKER_USER" >/dev/null 2>&1 || {
        fail_setup "Attacker user không tồn tại."
        return 1
    }

}

# =================================================================
# TEARDOWN FILE
# =================================================================

teardown_file() {

    # Xóa fixture trước.
    rm -rf \
        "$VICTIM_ROOT" \
        "$ATTACKER_ROOT" \
        "$VICTIM_VHOST_DIR" \
        "$ATTACKER_VHOST_DIR"

    rm -f \
        "$VICTIM_WPTT_CONF" \
        "$ATTACKER_WPTT_CONF"

    # Xóa users test.
    userdel "$VICTIM_USER" >/dev/null 2>&1 || true
    userdel "$ATTACKER_USER" >/dev/null 2>&1 || true
    userdel "$EXTERNAL_HACKER" >/dev/null 2>&1 || true
}

# =================================================================
# SETUP PER TEST
# =================================================================

setup() {

    require_root || return 1

    # Fixture bắt buộc phải tồn tại.
    [ -d "$VICTIM_ROOT" ] || {
        fail_setup "VICTIM_ROOT không tồn tại: $VICTIM_ROOT"
        return 1
    }

    [ -d "$ATTACKER_ROOT" ] || {
        fail_setup "ATTACKER_ROOT không tồn tại: $ATTACKER_ROOT"
        return 1
    }

    [ -f "$VICTIM_ROOT/wp-config.php" ] || {
        fail_setup "Victim wp-config.php không tồn tại."
        return 1
    }

    # Hai website bắt buộc phải có user khác nhau.
    if [ "$VICTIM_USER" = "$ATTACKER_USER" ]; then
        fail_setup "Victim và attacker dùng chung user."
        return 1
    fi

    # Tuyệt đối không cho website test chạy bằng root.
    if [ "$(id -u "$VICTIM_USER")" -eq 0 ]; then
        fail_setup "Victim user có UID 0."
        return 1
    fi

    if [ "$(id -u "$ATTACKER_USER")" -eq 0 ]; then
        fail_setup "Attacker user có UID 0."
        return 1
    fi
}

# =================================================================
# CROSS-SITE READ
# =================================================================

@test "Security Isolation: Cross-Site [Read]: User Web B KHÔNG THỂ đọc wp-config.php Web A" {

    run su -s /bin/bash "$ATTACKER_USER" -c \
        "cat -- '$VICTIM_ROOT/wp-config.php'"

    assert_status_nonzero
}

# =================================================================
# CROSS-SITE WRITE
# =================================================================

@test "Security Isolation: Cross-Site [Write]: User Web B KHÔNG THỂ tạo file trong Web A" {

    probe="$VICTIM_ROOT/.wptt-cross-site-write-probe"

    rm -f "$probe"

    run su -s /bin/bash "$ATTACKER_USER" -c \
        "printf '%s' 'HACKED_BY_WEB_B' > '$probe'"

    assert_status_nonzero

    if [ -e "$probe" ]; then
        rm -f "$probe"
        log_error "Attacker đã tạo được file trong Victim web root."
        return 1
    fi
}

# =================================================================
# CROSS-SITE SYMLINK
# =================================================================

@test "Security Isolation: Cross-Site [Symlink]: User Web B KHÔNG THỂ đọc Web A qua Symlink" {

    symlink="$ATTACKER_ROOT/.wptt-victim-link"

    rm -f "$symlink"

    run su -s /bin/bash "$ATTACKER_USER" -c \
        "ln -s '$VICTIM_ROOT/wp-config.php' '$symlink'"

    # Việc tạo symlink bản thân nó có thể được phép.
    # Điều quan trọng là attacker không được đọc target.
    if [ "$status" -ne 0 ]; then
        return 0
    fi

    run su -s /bin/bash "$ATTACKER_USER" -c \
        "cat -- '$symlink'"

    rm -f "$symlink"

    assert_status_nonzero
}

# =================================================================
# EXTERNAL READ
# =================================================================

@test "Security Isolation: External Hacker KHÔNG THỂ đọc wp-config.php" {

    run su -s /bin/bash "$EXTERNAL_HACKER" -c \
        "cat -- '$VICTIM_ROOT/wp-config.php'"

    assert_status_nonzero
}

# =================================================================
# EXTERNAL WRITE
# =================================================================

@test "Security Isolation: External Hacker KHÔNG THỂ ghi file vào Web" {

    probe="$VICTIM_ROOT/.wptt-external-write-probe"

    rm -f "$probe"

    run su -s /bin/bash "$EXTERNAL_HACKER" -c \
        "printf '%s' 'EXTERNAL_HACKED' > '$probe'"

    assert_status_nonzero

    [ ! -e "$probe" ]
}

# =================================================================
# OWNERSHIP
# =================================================================

@test "Security Isolation: Web root thuộc đúng Vhost User" {

    owner="$(stat -c '%U' "$VICTIM_ROOT")"

    if [ "$owner" != "$VICTIM_USER" ]; then
        log_error \
            "Ownership sai. Expected=$VICTIM_USER Actual=$owner"
        return 1
    fi
}

# =================================================================
# FILE OWNERSHIP
# =================================================================

@test "Security Isolation: wp-config.php thuộc Vhost User" {

    owner="$(stat -c '%U' "$VICTIM_ROOT/wp-config.php")"

    if [ "$owner" != "$VICTIM_USER" ]; then
        log_error \
            "wp-config ownership sai. Expected=$VICTIM_USER Actual=$owner"
        return 1
    fi
}

# =================================================================
# WORLD WRITABLE
# =================================================================

@test "Security Isolation: Không có file world-writable trong Web root" {

    run find "$VICTIM_ROOT" \
        -xdev \
        -type f \
        -perm /o+w \
        -print

    assert_status_zero

    [ -z "$output" ]
}

@test "Security Isolation: Không có directory world-writable trong Web root" {

    run find "$VICTIM_ROOT" \
        -xdev \
        -type d \
        -perm /o+w \
        -print

    assert_status_zero

    [ -z "$output" ]
}

# =================================================================
# OLS EXTUSER
# =================================================================

@test "Security Isolation: OLS VHost cấu hình đúng extUser" {

    [ -f "$VICTIM_OLS_CONF" ] || {
        log_error "Không tồn tại OLS config: $VICTIM_OLS_CONF"
        return 1
    }

    run grep -E \
        "^[[:space:]]*extUser[[:space:]]+$VICTIM_USER([[:space:]]|$)" \
        "$VICTIM_OLS_CONF"

    assert_status_zero
}

# =================================================================
# ATTACKER EXTUSER
# =================================================================

@test "Security Isolation: Web B có extUser riêng biệt với Web A" {

    [ -f "$ATTACKER_OLS_CONF" ] || {
        log_error "Không tồn tại attacker OLS config."
        return 1
    }

    run grep -E \
        "^[[:space:]]*extUser[[:space:]]+$ATTACKER_USER([[:space:]]|$)" \
        "$ATTACKER_OLS_CONF"

    assert_status_zero

    if grep -Eq \
        "^[[:space:]]*extUser[[:space:]]+$VICTIM_USER([[:space:]]|$)" \
        "$ATTACKER_OLS_CONF"; then

        log_error "Web B đang dùng chung extUser với Web A."
        return 1
    fi
}

# =================================================================
# SECRET CONFIRMATION
# =================================================================

@test "Security Isolation: wp-config.php thực sự chứa secret fixture" {

    run grep -F \
        "WPTT_TEST_SECRET_DO_NOT_USE" \
        "$VICTIM_ROOT/wp-config.php"

    assert_status_zero
}


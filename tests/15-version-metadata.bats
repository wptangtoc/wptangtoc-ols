#!/usr/bin/env bats

# Exercise the real configuration writers without provisioning a server.
setup() {
  REPO_ROOT=$(cd "$BATS_TEST_DIRNAME/.." && pwd)
  export TEST_CONFIG="$BATS_TEST_TMPDIR/wptt.conf"
  export PROBE_FILE="$BATS_TEST_TMPDIR/executed"
  export port_ssh=22 password_database_root_ma_hoa_luu_tru=fixture
  export php_version=8.3 NAME=example.com thoi_gian_cai_dat_phan_mem=01-01-2026
}

check_writer() {
  local file="$1" writer payload
  if [[ "$file" == wptangtoc-ols-* ]]; then
    writer=$(sed -n '/^cat > \/etc\/wptt\/\.wptt.conf <<EOF$/,/^EOF$/p' "$REPO_ROOT/$file")
  else
    writer=$(awk '/version_wptangtoc_ols/ && /\.wptt.conf/ && /^[[:space:]]*(sed|echo|printf) /' "$REPO_ROOT/$file")
  fi
  [ -n "$writer" ]
  # Redirect only the destination; execute the production serialization verbatim.
  printf '%s\n' "$writer" | sed 's@/etc/wptt/\.wptt.conf@"$TEST_CONFIG"@g' > "$BATS_TEST_TMPDIR/write-config"

  local payloads=(
    '4.0.0'
    '8.2.1.2'
    '8.2.1$(touch "$PROBE_FILE")'
    '8.2.1`touch "$PROBE_FILE"`'
    '8.2.1; touch "$PROBE_FILE"'
    $'8.2.1\ntouch "$PROBE_FILE"\nWPTT_TRASH_ENABLE=0'
    "8.2.1'; touch \"\$PROBE_FILE\"; #"
    '8.2.1"; touch "$PROBE_FILE"; #'
    $'8.2.1\\\ntouch "$PROBE_FILE"'
    '8.2.1${UNSET_VARIABLE}'
    $' 8.2.1\t\r\n'
    ''
  )
  for payload in "${payloads[@]}"; do
    printf 'WPTT_TRASH_ENABLE=1\nversion_wptangtoc_ols=0.0.1\n' > "$TEST_CONFIG"
    export wptangtocols_version="$payload" version_wptangtoc_ols_rollback="$payload"
    run bash -eu "$BATS_TEST_TMPDIR/write-config"
    [ "$status" -eq 0 ]
    [ ! -e "$PROBE_FILE" ]

    run bash -eu -c '
      . "$TEST_CONFIG"
      [[ "$version_wptangtoc_ols" == "$1" ]]
      [[ "$WPTT_TRASH_ENABLE" == 1 ]]
    ' bash "$payload"
    [ ! -e "$PROBE_FILE" ]
    [ "$status" -eq 0 ]
  done
}

@test "Version metadata: Ubuntu config preserves values without executing them" {
  check_writer wptangtoc-ols-ubuntu
}

@test "Version metadata: AlmaLinux 8 config preserves values without executing them" {
  check_writer wptangtoc-ols-almalinux
}

@test "Version metadata: AlmaLinux 9 config preserves values without executing them" {
  check_writer wptangtoc-ols-almalinux-9
}

@test "Version metadata: AlmaLinux 10 config preserves values without executing them" {
  check_writer wptangtoc-ols-almalinux-10
}

@test "Version metadata: interactive update preserves values without executing them" {
  check_writer tool-wptangtoc-ols/wptt-update
}

@test "Version metadata: branch switching preserves values without executing them" {
  check_writer tool-wptangtoc-ols/wptt-update2
}

@test "Version metadata: automatic update preserves values without executing them" {
  check_writer tool-wptangtoc-ols/wptt-update-wptangtoc-ols
}

@test "Version metadata: rollback preserves values without executing them" {
  check_writer tool-wptangtoc-ols/update/wptt-rollback-update-wptangtoc
}

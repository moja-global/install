# Check if essential AppImages files have been bundled correctly
function check_files() {
	[ -s AppDir.desktop ] && echo "[OK] Desktop file exists" || exit 1
	[ -s icon.png ] && echo "[OK] Icon file exists" || exit 1
}

function run_flint_test_binaries() {
	./usr/bin/moja.cli &>/dev/null && echo "[OK] moja.cli" || echo "[ERR] moja.cli"
}

check_files
run_flint_test_binaries

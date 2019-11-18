function abspath   { (cd "$1" 2>/dev/null && pwd -P) }

function corecount {
    getconf _NPROCESSORS_ONLN 2>/dev/null || sysctl -n hw.ncpu
}

function hm_err {
    echo "$1"
    echo "[!]  $2"
    exit 1
}

#!/usr/bin/env bash

this_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source "${this_dir}/util.sh"

if [ -z "${HMALLOC_PROFILE_ENV}" ]; then
    hm_err "check_env.sh" "hmalloc-profile environment not detected. Please run 'env/setup_env.sh' first."
fi

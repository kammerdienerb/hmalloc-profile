build_cfgs=control jemalloc hmalloc_profile
run_cfgs=control jemalloc hmalloc_profile

build_cfg_control=""
build_cfg_jemalloc=""
build_cfg_hmalloc_profile="-lhmalloc"

run_cfg_control=""
run_cfg_jemalloc="LD_PRELOAD=/usr/lib64/libjemalloc.so"
run_cfg_hmalloc_profile="HMALLOC_PROFILE=yes"

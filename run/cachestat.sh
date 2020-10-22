#!/bin/bash
# 28-Dec-2014	Brendan Gregg	Created this.
### default variables
tracing=/sys/kernel/debug/tracing
interval=1; opt_timestamp=0; opt_debug=0
trap 'quit=1' INT QUIT TERM PIPE HUP	# sends execution to end tracing section
function usage {
	cat <<-END >&2
	USAGE: cachestat [-Dht] [interval]
	                 -D              # print debug counters
	                 -h              # this usage message
	                 -t              # include timestamp
	                 interval        # output interval in secs (default 1)
	  eg,
	       cachestat                 # show stats every second
	       cachestat 5               # show stats every 5 seconds
	See the man page and example file for more info.
END
	exit
}
function warn {
	if ! eval "$@"; then
		echo >&2 "WARNING: command failed \"$@\""
	fi
}
function die {
	echo >&2 "$@"
	exit 1
}
### process options
while getopts Dht opt
do
	case $opt in
	D)	opt_debug=1 ;;
	t)	opt_timestamp=1 ;;
	h|?)	usage ;;
	esac
done
shift $(( $OPTIND - 1 ))
### option logic
if (( $# )); then
	interval=$1
fi
echo "Counting cache functions... Output every $interval seconds."
### check permissions
cd $tracing || die "ERROR: accessing tracing. Root user? Kernel has FTRACE?
    debugfs mounted? (mount -t debugfs debugfs /sys/kernel/debug)"
### enable tracing
sysctl -q kernel.ftrace_enabled=1	# doesn't set exit status
printf "mark_page_accessed\nmark_buffer_dirty\nadd_to_page_cache_lru\naccount_page_dirtied\n" > set_ftrace_filter || \
    die "ERROR: tracing these four kernel functions: mark_page_accessed,"\
    "mark_buffer_dirty, add_to_page_cache_lru and account_page_dirtied (unknown kernel version?). Exiting."
warn "echo nop > current_tracer"
if ! echo 1 > function_profile_enabled; then
	echo > set_ftrace_filter
	die "ERROR: enabling function profiling. Have CONFIG_FUNCTION_PROFILER? Exiting."
fi
(( opt_timestamp )) && printf "%-8s " TIME
printf "%8s                  %8s %8s %8s %12s %10s" HITS MISSES DIRTIES RATIO "BUFFERS_MB" "CACHE_MB"
(( opt_debug )) && printf "  DEBUG"
echo
### summarize
quit=0; secs=0
while (( !quit && (!opt_duration || secs < duration) )); do
	(( secs += interval ))
	echo 0 > function_profile_enabled
	echo 1 > function_profile_enabled
	sleep $interval
	(( opt_timestamp )) && printf "%(%H:%M:%S)T " -1
	# cat both meminfo and trace stats, and let awk pick them apart
	cat /proc/meminfo trace_stat/function* | awk -v debug=$opt_debug '
	# match meminfo stats:
	$1 == "Buffers:" && $3 == "kB" { buffers_mb = $2 / 1024 }
	$1 == "Cached:" && $3 == "kB" { cached_mb = $2 / 1024 }
	# identify and save trace counts:
	$2 ~ /[0-9]/ && $3 != "kB" { a[$1] += $2 }
	END {
		mpa = a["mark_page_accessed"]
		mbd = a["mark_buffer_dirty"]
		apcl = a["add_to_page_cache_lru"]
		apd = a["account_page_dirtied"]
		total = mpa - mbd
		misses = apcl - apd
		if (misses < 0)
			misses = 0
		hits = total - misses
		ratio = 100 * hits / total
		printf "%8u                  %8u %8d %7.1f%% %12.0f %10.0f", hits, misses, mbd,
		    ratio, buffers_mb, cached_mb
		if (debug)
			printf "  (%d %d %d %d)", mpa, mbd, apcl, apd
		printf "\n"
	}'
done
### end tracing
echo 2>/dev/null
echo "Ending tracing..." 2>/dev/null
warn "echo 0 > function_profile_enabled"
warn "echo > set_ftrace_filter"


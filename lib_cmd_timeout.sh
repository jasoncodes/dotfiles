cmd_timeout() {
	
	[ $# -ge 2 ] || die "Need at least two args: timeout_sec and command_to_run"
	sleep_time=$1
	shift
	
	# run command in background
	"$@" &
	cmd_pid=$!
	
	# sleep for our timeout then kill the process if it is running
	(
		exec 2> /dev/null # suppress stderr "Terminated" message
		sleep $sleep_time &&
		(
			kill $cmd_pid 2> /dev/null &&
			echo "Timeout $sleep_time seconds exceeded. Killed."
		) ||
		true
	) &
	killer_pid=$!
	
	# wait for cmd_pid to terminate.
	wait $cmd_pid &> /dev/null
	wait_status=$?
	
	# detach and clean up the killer_pid
	disown $killer_pid
	# kill the child `sleep` process which will cause the host subshell to quit
	ps -xo pid,ppid | awk "{ if ( \$2 == $killer_pid ) { print \$1 }}" | xargs kill
	
	return $wait_status
	
}

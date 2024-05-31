# Test if requirements are met
(
	type docker &>/dev/null || ( echo "docker is not available"; exit 1 )
)>&2

# ENV vars for tests
export APP_ENV=development
export APP_KEY="base64:v2LwHrdgnE+RavEXdnF8LgWIibjvEcFkU2qaX5Ji708="

TEST_FILE=$(basename $BATS_TEST_FILENAME .bats)

# stop all containers with the "bats-type" label (matching the optionally supplied value)
#
# $1 optional label value
function stop_bats_containers {
  echo "Stopping all containers with the bats-type label $1"
	docker-compose -f $1 stop
}

# delete all containers
docker_cleanup() {
  echo "Cleaning up all containers $1"
  docker-compose -f $1 down
	docker-compose -f $1 rm -f
}

# Send a HTTP request to container $1 for path $2 and
# Additional curl options can be passed as $@
#
# $1 container name
# $2 HTTP path to query
# $@ additional options to pass to the curl command
function curl_container {
	local -r container=$1
	local -r path=$2
	shift 2
	docker run --rm --label bats-type="curl" curlimages/curl --silent \
		--connect-timeout 5 \
		--max-time 20 \
		--retry 4 --retry-delay 5 \
		"$@" \
		http://$(docker_ip $container)${path}
}

# Retry a command $1 times until it succeeds. Wait $2 seconds between retries.
function retry {
    local attempts=$1
    shift
    local delay=$1
    shift
    local i

    for ((i=0; i < attempts; i++)); do
        run "$@"
        if [ "$status" -eq 0 ]; then
            echo "$output"
            return 0
        fi
        sleep $delay
    done

    echo "Command \"$@\" failed $attempts times. Status: $status. Output: $output" >&2
    false
}

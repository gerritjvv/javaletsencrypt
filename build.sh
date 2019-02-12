#!/usr/bin/env bash

dir=$(cd -P -- "$(dirname -- "$0")" && pwd -P)

set -e

push_docker () {

(
	cd $dir
	docker build -t gerritjvv/letsencrypt:latest .
	docker push gerritjvv/letsencrypt:latest

)

}

CMD="$1"
shift

case $CMD in
	docker )
       push_docker
       ;;
    * )
    echo "Command $CMD not found"
    exit -1
esac

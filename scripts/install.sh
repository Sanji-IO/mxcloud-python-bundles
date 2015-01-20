#!/bin/bash
set -e

export SSHPASS=moxa

DIR=`pwd`/../

# Install repo to target
function install_to_target {
	REMOTE_IP=$1
	TEMP_DIR=$(mktemp -d /tmp/deploy-remote.XXXXXXXX)
	# Create a bare repo
	git clone $DIR $TEMP_DIR --bare

	# Install post-receive hook
	cp ./remote-post-receive "$TEMP_DIR/hooks/post-receive"

	# Rsync to remote target
	sshpass -e rsync -av "$TEMP_DIR/" "moxa@$REMOTE_IP:/home/moxa/deploy.git/"
}

function print_help {
	echo "Usage : $0 <action> <target>"
    echo "    action: install"
    echo "    target: IP address"
}

# Main
if [ $# -lt 2 ]
then
    print_help
    exit
fi

case "$1" in
install)
    echo "[Install] MxCloud to $2..."
    install_to_target $2
    ;;
*)
	print_help
    exit 1
	;;
esac

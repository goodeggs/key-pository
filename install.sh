#!/bin/sh
if [ $USER != "ubuntu" ]; then
  echo "expected you to be running as the ubuntu user, exiting."
  exit 1
fi

cat *.pub > $HOME/.ssh/authorized_keys
chmod 600 $HOME/.ssh/authorized_keys

echo "rebuilt ~/.ssh/authorized_keys"


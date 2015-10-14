#!/bin/bash

################################################################################
## This script can be deployed to a host to auto-generate the authorized_keys
## file, without requiring you to actuall maintain a local copy of the repo.
##
## The file is designed with two circuit breakers, that at least five keys
## should exist in the repository, and that the repository exists and contains
## a "keys" folder, which contains the public keys.
##
## Note that curl is not typically installed by most distributions, and should
## be installed ahead of this script.
##
## Requirements: tar, curl
################################################################################

KEY_DIRECTORY=$HOME/.ssh/goodeggs_keys

# clean the local key cache and re-fetch from Github latest master branch
rm -rf $KEY_DIRECTORY/*
curl -s https://codeload.github.com/goodeggs/key-pository/tar.gz/master | tar xz --strip=2 -C $KEY_DIRECTORY 'key-pository-master/keys/' || exit 1

# Safety mechanism in the event the repository is renamed accidentally and/or someone
# tries to delete all keys and lock us out of the accounts. This check should
# eventually be stronger.
if [ `ls -1 $KEY_DIRECTORY | wc -l` -lt "5" ]; then
  echo "Expected at least 5 public keys. Refusing to update authorized keys as something may be wrong."
  exit 1
fi

# delete the old authorized keys and recreate the file from our public keys
rm ~/.ssh/authorized_keys
for i in `ls -1 $KEY_DIRECTORY`; do cat $KEY_DIRECTORY/$i >> $HOME/.ssh/authorized_keys; done

# allow for a locally specified "persistent key"
# currently this is unused, but allows for special localized access
cat $HOME/.ssh/persistent_keys >> $HOME/.ssh/authorized_keys
chmod 600 $HOME/.ssh/authorized_keys

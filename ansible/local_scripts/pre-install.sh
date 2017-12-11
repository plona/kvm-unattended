#!/bin/bash - 
#===============================================================================
#
#          FILE: pre-install.sh
# 
#         USAGE: ./pre-install.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Marek Płonka (marekpl), marek.plonka@nask.pl
#  ORGANIZATION: NASK
#       CREATED: 11/17/2017 09:07:20 AM
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error
set -o errexit

files="files"
#templates="templates"

rm -rf $files/home/.vim || true
cp -Rp $HOME/.vim $files/home

shopt -s dotglob
pushd $files/home
tar czf ../home.tgz *
popd
shopt -u dotglob

cat /dev/null > log/ansible.log || true

exit 0

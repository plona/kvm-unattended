#!/bin/bash - 
#===============================================================================
#
#          FILE: post-install.sh
# 
#         USAGE: ./post-install.sh 
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

rm -rf $files/home/.vim || true
rm -f $files/*.tgz

exit 0

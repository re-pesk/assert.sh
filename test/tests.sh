#!/usr/bin/env bash

#####################################################################
##
## description:
## Tests runner for assert extension
##
## author: Rėdas Peškaitis
## ISO date: 2025-07-30
##
## license: MIT
##
#####################################################################

set -o nounset

DIR_TEST="$( cd "$( dirname "${0}" )" && pwd )"

"$DIR_TEST/test_assert.dash"
"$DIR_TEST/test_assert.yash"
"$DIR_TEST/test_assert.bash"
"$DIR_TEST/test_assert.zsh"
"$DIR_TEST/test_assert.ksh"
"$DIR_TEST/test_assert.osh"

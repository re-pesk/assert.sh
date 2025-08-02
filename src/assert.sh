#!/usr/bin/env bash

#####################################################################
##
## title: Assert Extension
##
## description:
## Assert extension of shell (bash, ...)
##   with the common assert functions
## Function list based on:
##   http://junit.sourceforge.net/javadoc/org/junit/Assert.html
## Log methods : inspired by
##	- https://natelandau.com/bash-scripting-utilities/
## author: Mark Torok
## date: 07. Dec. 2016
## 
## modified by: Rėdas Peškaitis
## ISO date: 2025-07-30
##
## license: MIT
##
#####################################################################

if command -v tput >/dev/null 2>&1 && tty -s; then
  RED=$(tput setaf 1)
  GREEN=$(tput setaf 2)
  MAGENTA=$(tput setaf 5)
  NORMAL=$(tput sgr0)
  BOLD=$(tput bold)
else
  RED=$(echo -en "\e[31m")
  GREEN=$(echo -en "\e[32m")
  MAGENTA=$(echo -en "\e[35m")
  NORMAL=$(echo -en "\e[00m")
  BOLD=$(echo -en "\e[01m")
fi

log_header() (
  printf "\n${BOLD}${MAGENTA}==========  %s  ==========${NORMAL}\n" "$@" >&2
)

log_success() (
  printf "${GREEN}✔ %s${NORMAL}\n" "$@" >&2
)

log_failure() (
  printf "${RED}✖ %s${NORMAL}\n" "$@" >&2
)

count_lines() (
  wc -l << EOF
$1
EOF
)

current_shell() (
  basename "$(ps -hp $$ | awk '{print $5}')"
)

assert_eq() (
  expected="$1"
  actual="$2"
  msg="${3-}"

  if [ "$expected" = "$actual" ]; then
    return 0
  else
    [ "${#msg}" -gt 0 ] && log_failure "$expected == $actual :: $msg" || true
    return 1
  fi
)

assert_not_eq() (
  expected="$1"
  actual="$2"
  msg="${3-}"

  if [ ! "$expected" = "$actual" ]; then
    return 0
  else
    [ "${#msg}" -gt 0 ] && log_failure "$expected != $actual :: $msg" || true
    return 1
  fi
)

assert_true() (
  actual="$1"
  msg="${2-}"

  assert_eq true "$actual" "$msg"
  return "$?"
)

assert_false() (
  actual="$1"
  msg="${2-}"

  assert_eq false "$actual" "$msg"
  return "$?"
)

assert_array_eq() (
  expected="$1"
  expected_lines_no="$(count_lines "$expected")"

  actual="$2"
  actual_lines_no="$(count_lines "$actual")"

  msg="${3-}"

  if [ ! "$expected_lines_no" = "$actual_lines_no" ]; then
    [ "${#msg}" -gt 0 ] && log_failure "(${expected}) != (${actual}) :: $msg"
    return 1
  fi

  if [ ! "$expected" = "$actual" ]; then
    [ "${#msg}" -gt 0 ] && log_failure "(${expected}) != (${actual}) :: $msg"
    return 1
  fi

  return 0
)

assert_array_not_eq() (
  expected="$1"
  expected_lines_no="$(count_lines "$expected")"

  actual="$2"
  actual_lines_no="$(count_lines "$actual")"

  msg="${3-}"

  if [ ! "$expected_lines_no" = "$actual_lines_no" ]; then
    return 0
  fi

  if [ ! "$expected" = "$actual" ]; then
    return 0
  fi

  [ "${#msg}" -gt 0 ] && log_failure "(${expected}) != (${actual}) :: $msg" || true

  return 1
)

assert_empty() (
  actual=$1
  msg="${2-}"

  assert_eq "" "$actual" "$msg"
  return "$?"
)

assert_not_empty() (
  actual=$1
  msg="${2-}"

  assert_not_eq "" "$actual" "$msg"
  return "$?"
)

assert_contain() (
  haystack="$1"
  needle="${2-}"
  msg="${3-}"

  if [ -z "${needle:+x}" ]; then
    return 0;
  fi

  if [ -z "$haystack" ]; then
    return 1;
  fi

  if [ -z "${haystack##*"$needle"*}" ]; then
    return 0
  else
    [ "${#msg}" -gt 0 ] && log_failure "$haystack doesn't contain $needle :: $msg" || true
    return 1
  fi
)

assert_not_contain() (
  haystack="$1"
  needle="${2-}"
  msg="${3-}"

  if [ -z "${needle:+x}" ]; then
    return 0;
  fi

  if [ -z "$haystack" ]; then
    return 0;
  fi

  if [ "${haystack##*"$needle"*}" ]; then
    return 0
  else
    [ "${#msg}" -gt 0 ] && log_failure "$haystack contains $needle :: $msg" || true
    return 1
  fi
)

assert_gt() (
  first="$1"
  second="$2"
  msg="${3-}"

  if [ "$first" -gt  "$second" ]; then
    return 0
  else
    [ "${#msg}" -gt 0 ] && log_failure "$first > $second :: $msg" || true
    return 1
  fi
)

assert_ge() (
  first="$1"
  second="$2"
  msg="${3-}"

  if [ "$first" -ge  "$second" ]; then
    return 0
  else
    [ "${#msg}" -gt 0 ] && log_failure "$first >= $second :: $msg" || true
    return 1
  fi
)

assert_lt() (
  first="$1"
  second="$2"
  msg="${3-}"

  if [ "$first" -lt  "$second" ]; then
    return 0
  else
    [ "${#msg}" -gt 0 ] && log_failure "$first < $second :: $msg" || true
    return 1
  fi
)

assert_le() (
  first="$1"
  second="$2"
  msg="${3-}"

  if [ "$first" -le  "$second" ]; then
    return 0
  else
    [ "${#msg}" -gt 0 ] && log_failure "$first <= $second :: $msg" || true
    return 1
  fi
)

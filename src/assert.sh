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

log_header() {
  printf "\n${BOLD}${MAGENTA}==========  %s  ==========${NORMAL}\n" "$@" >&2
}

log_success() {
  printf "${GREEN}✔ %s${NORMAL}\n" "$@" >&2
}

log_failure() {
  printf "${RED}✖ %s${NORMAL}\n" "$@" >&2
}

count_lines() {
  wc -l << EOF
$1
EOF
}

assert_eq() {
  local expected="$1"
  local actual="$2"
  local msg="${3-}"

  if [ "$expected" = "$actual" ]; then
    return 0
  else
    [ "${#msg}" -gt 0 ] && log_failure "$expected == $actual :: $msg" || true
    return 1
  fi
}

assert_not_eq() {
  local expected="$1"
  local actual="$2"
  local msg="${3-}"

  if [ ! "$expected" = "$actual" ]; then
    return 0
  else
    [ "${#msg}" -gt 0 ] && log_failure "$expected != $actual :: $msg" || true
    return 1
  fi
}

assert_true() {
  local actual="$1"
  local msg="${2-}"

  assert_eq true "$actual" "$msg"
  return "$?"
}

assert_false() {
  local actual="$1"
  local msg="${2-}"

  assert_eq false "$actual" "$msg"
  return "$?"
}

assert_array_eq() {

  local expected="$1"
  local expected_lines_no="$(count_lines "$expected")"
  # echo "AAE ${expected}"

  local actual="$2"
  local actual_lines_no="$(count_lines "$actual")"
  # echo "AAE ${actual}"

  local msg="${3-}"

  local return_code=0
  if [ ! "$expected_lines_no" = "$actual_lines_no" ]; then
    return_code=1
  fi

  if [ ! "$expected" = "$actual" ]; then
    return_code=1
  fi

  if [ "$return_code" = 1 ]; then
    [ "${#msg}" -gt 0 ] && log_failure "(${expected}) != (${actual}) :: $msg" || true
  fi

  return "$return_code"
}

assert_array_not_eq() {

  local expected="$1"
  local expected_lines_no="$(count_lines "$expected")"
  # echo "AAE ${expected}"

  local actual="$2"
  local actual_lines_no="$(count_lines "$actual")"
  # echo "AAE ${actual}"

  local msg="${3-}"

  local return_code=1
  if [ ! "$expected_lines_no" = "$actual_lines_no" ]; then
    return_code=0
  fi

  if [ ! "$expected" = "$actual" ]; then
    return_code=0
  fi

  if [ "$return_code" = 1 ]; then
    [ "${#msg}" -gt 0 ] && log_failure "(${expected}) != (${actual}) :: $msg" || true
  fi

  return "$return_code"
}

assert_empty() {
  local actual=$1
  local msg="${2-}"

  assert_eq "" "$actual" "$msg"
  return "$?"
}

assert_not_empty() {
  local actual=$1
  local msg="${2-}"

  assert_not_eq "" "$actual" "$msg"
  return "$?"
}

assert_contain() {
  local haystack="$1"
  local needle="${2-}"
  local msg="${3-}"

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
}

assert_not_contain() {
  local haystack="$1"
  local needle="${2-}"
  local msg="${3-}"

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
}

assert_gt() {
  local first="$1"
  local second="$2"
  local msg="${3-}"

  if [ "$first" -gt  "$second" ]; then
    return 0
  else
    [ "${#msg}" -gt 0 ] && log_failure "$first > $second :: $msg" || true
    return 1
  fi
}

assert_ge() {
  local first="$1"
  local second="$2"
  local msg="${3-}"

  if [ "$first" -ge  "$second" ]; then
    return 0
  else
    [ "${#msg}" -gt 0 ] && log_failure "$first >= $second :: $msg" || true
    return 1
  fi
}

assert_lt() {
  local first="$1"
  local second="$2"
  local msg="${3-}"

  if [ "$first" -lt  "$second" ]; then
    return 0
  else
    [ "${#msg}" -gt 0 ] && log_failure "$first < $second :: $msg" || true
    return 1
  fi
}

assert_le() {
  local first="$1"
  local second="$2"
  local msg="${3-}"

  if [ "$first" -le  "$second" ]; then
    return 0
  else
    [ "${#msg}" -gt 0 ] && log_failure "$first <= $second :: $msg" || true
    return 1
  fi
}

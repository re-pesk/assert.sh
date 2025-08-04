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

nl="
"

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
  label="${3-}"
  msg="${4-!=}"

  [ "$expected" = "$actual" ] && return 0
  if [ "${#label}" -gt 0 ]; then
    [ "${label}" = "--" ] && label=""
    log_failure "${label:+${label}:${nl}}'$actual'${nl}${msg}${nl}'$expected'" || true
  fi
  return 1
)

assert_not_eq() (
  expected="$1"
  actual="$2"
  label="${3-}"
  msg="${4-==}"

  [ ! "$expected" = "$actual" ] && return 0
  if [ "${#label}" -gt 0 ]; then
    [ "${label}" = "--" ] && label=""
    log_failure "${label:+${label}:${nl}}'$actual'${nl}${msg}${nl}'$expected'" || true
  fi
  return 1
)

assert_true() (
  assert_eq true "$@"
  return "$?"
)

assert_false() (
  assert_eq false "$@"
  return "$?"
)

assert_array_eq() (
  expected="$1"
  expected_lines_no="$(count_lines "$expected")"

  actual="$2"
  actual_lines_no="$(count_lines "$actual")"

  label="${3-}"
  msg="${4-!=}"

  if [ "$expected_lines_no" -eq "$actual_lines_no" ] && [ "${expected}" = "${actual}" ]; then
    return 0
  fi

  if [ "${#label}" -gt 0 ]; then
    [ "${label}" = "--" ] && label=""
    log_failure "${label:+${label}:${nl}}'$actual'${nl}${msg}${nl}'$expected'" || true
  fi

  return 1
)

assert_array_not_eq() (
  expected="$1"
  expected_lines_no="$(count_lines "$expected")"

  actual="$2"
  actual_lines_no="$(count_lines "$actual")"

  label="${3-}"
  msg="${4-==}"

  if [ ! "$expected_lines_no" -eq "$actual_lines_no" ] || [ ! "$expected" = "$actual" ]; then 
    return 0
  fi

  if [ "${#label}" -gt 0 ]; then
    [ "${label}" = "--" ] && label=""
    log_failure "${label:+${label}:${nl}}'$actual'${nl}${msg}${nl}'$expected'" || true
  fi

  return 1
)

assert_empty() (
  assert_eq "" "$@"
  return "$?"
)

assert_not_empty() (
  assert_not_eq "" "$@"
  return "$?"
)

assert_contain() (
  haystack="$1"
  needle="${2-}"
  msg="${3-}"
  label="${3-}"
  msg="${4-doesn\'t contain}"

  if [ -z "${needle:+x}" ]; then
    return 0;
  fi

  if [ -z "$haystack" ]; then
    return 1;
  fi

  if [ -z "${haystack##*"$needle"*}" ]; then
    return 0
  fi
  if [ "${#label}" -gt 0 ]; then
    [ "${label}" = "--" ] && label=""
    log_failure "${label:+${label}:${nl}}'$haystack'${nl}${msg}${nl}'$needle'" || true
  fi
  return 1
)

assert_not_contain() (
  haystack="$1"
  needle="${2-}"
  label="${3-}"
  msg="${4-contains}"

  if [ -z "${needle:+x}" ]; then
    return 0;
  fi

  if [ -z "$haystack" ]; then
    return 0;
  fi

  if [ "${haystack##*"$needle"*}" ]; then
    return 0
  fi
  if [ "${#label}" -gt 0 ]; then
    [ "${label}" = "--" ] && label=""
    log_failure "${label:+${label}:${nl}}'$haystack'${nl}${msg}${nl}'$needle'" || true
  fi
  return 1
)

assert_gt() (
  first="$1"
  second="$2"
  label="${3-}"
  msg="${4->}"

  if [ "$first" -gt  "$second" ]; then
    return 0
  fi
  if [ "${#label}" -gt 0 ]; then
    [ "${label}" = "--" ] && label=""
    log_failure "${label:+${label}:${nl}}'$first'${nl}${msg}${nl}'$second'" || true
  fi
  return 1
)

assert_ge() (
  first="$1"
  second="$2"
  label="${3-}"
  msg="${4->=}"

  if [ "$first" -ge  "$second" ]; then
    return 0
  fi
  if [ "${#label}" -gt 0 ]; then
    [ "${label}" = "--" ] && label=""
    log_failure "${label:+${label}:${nl}}'$first'${nl}${msg}${nl}'$second'" || true
  fi
  return 1
)

assert_lt() (
  first="$1"
  second="$2"
  label="${3-}"
  msg="${4-<}"

  if [ "$first" -lt  "$second" ]; then
    return 0
  fi

  if [ "${#label}" -gt 0 ]; then
    [ "${label}" = "--" ] && label=""
    log_failure "${label:+${label}:${nl}}'$first'${nl}${msg}${nl}'$second'" || true
  fi
  return 1
)

assert_le() (
  first="$1"
  second="$2"
  label="${3-}"
  msg="${4-<=}"

  if [ "$first" -le  "$second" ]; then
    return 0
  fi
  if [ "${#label}" -gt 0 ]; then
    [ "${label}" = "--" ] && label=""
    log_failure "${label:+${label}:${nl}}'$first'${nl}${msg}${nl}'$second'" || true
  fi
  return 1
)

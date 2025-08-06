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
  DEFAULT=$(tput sgr0)
  BOLD=$(tput bold)
  FG_BLACK=$(tput setaf 0)
  FG_RED=$(tput setaf 1)
  FG_GREEN=$(tput setaf 2)
  FG_YELLOW=$(tput setaf 3)
  FG_BLUE=$(tput setaf 4)
  FG_MAGENTA=$(tput setaf 5)
  FG_CYAN=$(tput setaf 6)
  FG_WHITE=$(tput setaf 7)
  HEADER=${BOLD}${FG_MAGENTA}
  SUCCESS=${FG_GREEN}
  FAILURE=${FG_RED}

else
  DEFAULT=$(printf "\e[00m")
  BOLD=$(printf "\e[01m")
  FG_BLACK=$(printf "\e[30m")
  FG_RED=$(printf "\e[31m")
  FG_GREEN=$(printf "\e[32m")
  FG_YELLOW=$(printf "\e[33m")
  FG_BLUE=$(printf "\e[34m")
  FG_MAGENTA=$(printf "\e[35m")
  FG_CYAN=$(printf "\e[36m")
  FG_WHITE=$(printf "\e[37m")
  HEADER=${BOLD}${FG_MAGENTA}
  SUCCESS=${FG_GREEN}
  FAILURE=${FG_RED}
fi

log_header() (
  printf "\n${HEADER}==========  %s  ==========${DEFAULT}\n" "$@" >&2
)

log_success() (
  printf "${SUCCESS}✔ %s${DEFAULT}\n" "$@" >&2
)

log_failure() (
  printf "${FAILURE}✖ %s${DEFAULT}\n" "$@" >&2
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
    log_failure "${label:+${label}:${nl}${nl}}'$actual'${nl}${nl}${msg}${nl}${nl}'$expected'" || true
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
    log_failure "${label:+${label}:${nl}${nl}}'$actual'${nl}${nl}${msg}${nl}${nl}'$expected'" || true
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
    log_failure "${label:+${label}:${nl}${nl}}'$actual'${nl}${nl}${msg}${nl}${nl}'$expected'" || true
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
    log_failure "${label:+${label}:${nl}${nl}}'$actual'${nl}${nl}${msg}${nl}${nl}'$expected'" || true
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
    log_failure "${label:+${label}:${nl}${nl}}'$haystack'${nl}${nl}${msg}${nl}${nl}'$needle'" || true
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
    log_failure "${label:+${label}:${nl}${nl}}'$haystack'${nl}${nl}${msg}${nl}${nl}'$needle'" || true
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
    log_failure "${label:+${label}:${nl}${nl}}'$first'${nl}${nl}${msg}${nl}${nl}'$second'" || true
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
    log_failure "${label:+${label}:${nl}${nl}}'$first'${nl}${nl}${msg}${nl}${nl}'$second'" || true
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
    log_failure "${label:+${label}:${nl}${nl}}'$first'${nl}${nl}${msg}${nl}${nl}'$second'" || true
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
    log_failure "${label:+${label}:${nl}${nl}}'$first'${nl}${nl}${msg}${nl}${nl}'$second'" || true
  fi
  return 1
)

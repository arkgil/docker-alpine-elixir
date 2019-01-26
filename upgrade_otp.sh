#!/usr/bin/env bash

set -e

PATTERN=""
OTP=""
HELP="f"
BRANCHES=()
SED="sed"

function print_help() {
	cat <<EOF
Usage: $(basename "$0") <branch-pattern> <otp-vsn> [OPTIONS]

<branch-pattern>    Branches the upgrade should be applied to
<otp-vsn>           The new base OTP version

OPTIONS:
  -h | --help    Print this help message
EOF
}

function parse_args() {
	# Source: https://stackoverflow.com/a/14203146/9103501
	POSITIONAL=()
	while [[ $# -gt 0 ]]; do
		key="$1"

		case $key in
		-h | --help)
			HELP="t"
			shift
			;;
		*) # unknown option
			POSITIONAL+=("$1") # save it in an array for later
			shift              # past argument
			;;
		esac
	done
	set -- "${POSITIONAL[@]}" # restore positional parameters
	if [[ $# -lt 2 ]]; then
		echo "Too few command line arguments"
		print_help
		exit 1
	fi
	PATTERN="$1"
	OTP="$2"
}

function find_branches() {
	while read -r line; do
		BRANCHES+=("$line")
	done < <(git branch --list "$PATTERN" --format='%(refname:short)')
}

function upgrade_otp() {
	local branch="$1"
	local otp="$2"
	printf "\nUpgrading branch $branch to OTP $otp.."
	git checkout -q "$branch"
	$SED -i "s#^FROM arkgil/alpine-erlang:.\+#FROM arkgil/alpine-erlang:${otp}#" Dockerfile
	git add Dockerfile
	git commit -q -m "Upgrade OTP to ${otp}" || return 0
}

function main() {
	if [[ "$(uname)" =~ "Darwin" ]]; then
		SED="gsed"
	fi
	parse_args "$@"
	if [[ "$HELP" == "t" ]]; then
		print_help
		exit 0
	fi
	find_branches "$PATTERN"
	if [[ "${#BRANCHES[@]}" -eq 0 ]]; then
		echo "No branches found matching the pattern ${PATTERN}"
		exit 1
	fi
	echo "Applying upgrade to following branches:"
	echo "${BRANCHES[@]}"
	for branch in "${BRANCHES[@]}"; do
		upgrade_otp "$branch" "$OTP"
	done
	git checkout -q master
	echo "Done"
}

main "$@"

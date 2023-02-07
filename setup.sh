#!/bin/bash

# Copyright (c) 2022 Alex313031.

YEL='\033[1;33m' # Yellow
CYA='\033[1;96m' # Cyan
RED='\033[1;31m' # Red
GRE='\033[1;32m' # Green
c0='\033[0m' # Reset Text
bold='\033[1m' # Bold Text
underline='\033[4m' # Underline Text

# Error handling
yell() { echo "$0: $*" >&2; }
die() { yell "$*"; exit 111; }
try() { "$@" || die "${RED}Failed $*"; }

# --help
displayHelp () {
	printf "\n" &&
	printf "${bold}${GRE}Script to copy and prepare files for the Chromium source tree.${c0}\n" &&
	printf "${bold}${YEL}Use the --avx2 flag for AVX2 Build.${c0}\n" &&
	printf "${bold}${YEL}Use the --sse3 flag for SSE3 Build.${c0}\n" &&
	printf "${bold}${YEL}Use the --sse2 flag for a 32 bit SSE2 Build.${c0}\n" &&
	printf "\n"
}

case $1 in
	--help) displayHelp; exit 0;;
esac

printf "\n" &&
printf "${YEL}Creating build output directory...\n" &&
tput sgr0 &&

mkdir -v -p $HOME/chromium/src/out/Release/ &&
cp -r -v win_args.gn $HOME/chromium/src/out/Release/args.gn &&
printf "\n" &&

printf "\n" &&
printf "${YEL}Copying and preparing files for the Chromium source tree....\n" &&
tput sgr0 &&

cp -r -v src/build/. $HOME/chromium/src/build/ &&
cp -r -v src/chrome/. $HOME/chromium/src/chrome/ &&
cp -r -v src/components/. $HOME/chromium/src/components/ &&
cp -r -v src/media/. $HOME/chromium/src/media/ &&
cp -r -v src/third_party/. $HOME/chromium/src/third_party/ &&
cp -r -v src/tools/. $HOME/chromium/src/tools/ &&

# Copy AVX2 files
copyAVX2 () {
	printf "\n" &&
	printf "${YEL}Copying AVX2 build files...${c0}\n" &&
	cp -r -v other/AVX2/build/config/* $HOME/chromium/src/build/config/ &&
	cp -r -v other/AVX2/third_party/opus/src/* $HOME/chromium/src/third_party/opus/src/ &&
	printf "\n"
}

case $1 in
	--avx2) copyAVX2;
esac

# Copy SSE3 files
copySSE3 () {
	printf "\n" &&
	printf "${YEL}Copying SSE3 build files...${c0}\n" &&
	cp -r -v other/SSE3/build/config/* $HOME/chromium/src/build/config/ &&
	printf "\n"
}

case $1 in
	--sse3) copySSE3;
esac

# Copy SSE2 files
copySSE2 () {
	printf "\n" &&
	printf "${YEL}Copying SSE2 build files...${c0}\n" &&
	cp -r -v other/SSE2/build/config/* $HOME/chromium/src/build/config/ &&
	cp -r -v win_args_SSE2.gn $HOME/chromium/src/out/Release/args.gn &&
	printf "\n"
}

case $1 in
	--sse2) copySSE2;
esac

printf "${GRE}Done!\n" &&
printf "\n" &&

printf "${YEL}Exporting variables and setting handy aliases...\n" &&

export NINJA_SUMMARIZE_BUILD=1 &&

export EDITOR=nano &&

export VISUAL=nano &&

alias origin='git checkout -f origin/main' &&

alias gfetch='git fetch --tags' &&

alias rebase='git rebase-update' &&

alias gsync='gclient sync --with_branch_heads --with_tags -f -R -D' &&

alias args='gn args out/Release' &&

alias gnls='gn ls out/Release' &&

alias show='git show-ref' &&

alias runhooks='gclient runhooks' &&

printf "\n" &&
tput sgr0 &&

printf "export ${CYA}NINJA_SUMMARIZE_BUILD=1${c0}\n" &&

printf "export ${CYA}EDITOR=nano${c0}\n" &&

printf "export ${CYA}VISUAL=nano${c0}\n" &&
printf "\n" &&

printf "alias ${YEL}origin${c0} = ${CYA}git checkout -f origin/main${c0}\n" &&

printf "alias ${YEL}gfetch${c0} = ${CYA}git fetch --tags${c0}\n" &&

printf "alias ${YEL}rebase${c0} = ${CYA}git rebase-update${c0}\n" &&

printf "alias ${YEL}gsync${c0} = ${CYA}gclient sync --with_branch_heads --with_tags -f -R -D${c0}\n" &&

printf "alias ${YEL}args${c0} = ${CYA}gn args out/Release${c0}\n" &&

printf "alias ${YEL}gnls${c0} = ${CYA}gn ls out/Release${c0}\n" &&

printf "alias ${YEL}show${c0} = ${CYA}git show-ref${c0}\n" &&

printf "alias ${YEL}runhooks${c0} = ${CYA}gclient runhooks${c0}\n" &&

printf "${GRE}Enjoy Chromium on Windows 7!\n" &&
printf "\n" &&
tput sgr0

exit 0

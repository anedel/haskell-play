#!/bin/bash

## hs-prepare-dirs.bash

## The leading 'HS_' stands for "Haskell Stack"

HS_BASE_DIR="$1"

if [ -z "$HS_BASE_DIR" ]; then
    echo "Please specify the base directory."
    exit 1
fi

if [ ! -e "$HS_BASE_DIR" ]; then
    echo "The given base directory '$HS_BASE_DIR' does not exist!"
    exit 2
fi

if [ -f "$HS_BASE_DIR" ]; then
    echo "The given base directory '$HS_BASE_DIR' is a regular file!"
    exit 3
fi

if [ ! -d "$HS_BASE_DIR" ]; then
    echo "The given base directory '$HS_BASE_DIR' is not a directory!"
    exit 4
fi

if [ ! -w "$HS_BASE_DIR" ]; then
    echo "The given base directory '$HS_BASE_DIR' should be writable!"
    exit 5
fi


## One of the IDEs that seem usable for Haskell is
## IntelliJ IDEA Community Edition (the open source version) from JetBrains.
##
IDEA_DIR="$HS_BASE_DIR/IntelliJ-IDEA-Community-Ed"

 STACK_BIN_DIR="$HS_BASE_DIR/stack-bin"
STACK_ROOT_DIR="$HS_BASE_DIR/stack-root"

GLOBAL_PROJ_DIR="$STACK_ROOT_DIR/global-project"

GLOBAL_STACK_FILE="$GLOBAL_PROJ_DIR/stack.yaml"


mkdir "$IDEA_DIR"

mkdir "$STACK_BIN_DIR"
mkdir "$STACK_ROOT_DIR"

mkdir "$GLOBAL_PROJ_DIR"

echo 'resolver: lts' > "$GLOBAL_STACK_FILE"

echo 'packages: []' >> "$GLOBAL_STACK_FILE"
    ## This second line in '.../global-project/stack.yaml' was needed
    ## at the time of writing (February 25th -- March 3rd, 2019)
    ## to avoid the following error from 'stack ghci' = 'stack repl':
    ##    Stack looks for packages in the directories configured in the 'packages' and 'extra-deps' fields defined in your stack.yaml
    ##    The current entry points to ( ... STACK_ROOT_DIR's value here... )/global-project/ but no .cabal or package.yaml file could be found there.


generate_bash_config_lines() {
    local DATE="$(date)"

    echo
    echo "## Haskell Stack config (generated $DATE):"
    echo
    echo "export STACK_ROOT='$STACK_ROOT_DIR'"
    echo "export PATH=\"$STACK_BIN_DIR:\$HOME/.local/bin:\$PATH\""
    echo
    echo 'eval "$(stack --bash-completion-script stack)"'
    echo
    echo "## End of Haskell Stack config (generated $DATE)."
    echo
}


BASHRC_FILE=~/.bashrc

echo "Bash startup file for interactive shell launch should be '$BASHRC_FILE'"

if [ ! -w "$BASHRC_FILE" ]; then
    echo "Bash startup file '$BASHRC_FILE' should exist and be writable!"
    exit 8
fi

echo "Appending Haskell Stack config lines to '$BASHRC_FILE' ..."

generate_bash_config_lines >> "$BASHRC_FILE"

echo "Haskell Stack changes appended to '$BASHRC_FILE' (hopefully)."

echo
echo "bash  ...get.haskellstack.org...  -d $STACK_BIN_DIR"
echo
echo "Check '$BASHRC_FILE', delete obsolete config lines from previous runs of this script."
echo
echo 'Start a new shell for next steps:'
echo
echo "Run the following from outside of a project: stack config set resolver lts"
echo "Check the file '$GLOBAL_STACK_FILE'"
echo
echo "You might need to symlink the Stack root directory '$STACK_ROOT_DIR'"
echo "so it also appears in its default location:"
echo "  if [ ! -e ~/.stack ]; then ln -s '$STACK_ROOT_DIR' ~/.stack ; fi"
echo
echo "  cd '$IDEA_DIR' && tar xzf /path/to/ideaIC-20xx....tar.gz # (downloaded from JetBrains)"
echo


## EoF


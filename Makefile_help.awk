#!/usr/bin/env -S awk -f

# This awk program prints help for Makefiles.
# It expects section headers to start with `##@` and target documentation to start with `##`.
# For example, help the following Makefile:
# |
# | ##@ Important targets
# | build: stuff ## Build a thing
# | 	@echo building...
# | stuff: ## Make stuff
# | 	@echo stuff...
# |
# Would be printed as:
# |
# | Usage:
# |   make <target>
# |
# | Important targets
# |   build                         Build a thing
# |   stuff                         Make stuff
# |

# Learn how to use awk here: https://www.gnu.org/software/gawk/manual/html_node/Getting-Started.html.
# tl;dr an awk program is a collection of 'pattern { action }'. Each is run against every line
# of the input. If the pattern matches on the line the action is executed.

# This action runs before any line is tested.
BEGIN {
  # Set the field separator to split between a Make target`s definition and it`s documentation.
  # For example:
  #  | ...
  #  | some-target: a-requirement another-requirement ## This is what the target does.
  #  | <field 1>  ^ <field separator>                  ^ <field 2>
  #  | ...
  # Now the target can be read with $1 its documentation with $2.
  FS = ":.*##";
  # Print an explanation on how to make a target.
  printf "\nUsage:\n  make \033[36m<target>\033[0m\n";
}

# Match every line that looks like a section header, e.g. `##@ Very important targets`.
/^##@/ {
  # Trim `##@ ` from the start of the line a print the section header in bold green.
  printf "\n\033[1m\033[32m%s\033[0m\n", substr($0, 5);
}

# Match every line that looks like a Make target with documentation.
/^[%0-9a-zA-Z_-]+:.*?##/ {
  # Print the Make target in blue and its right-justified documentation.
  printf "  \033[36m%-28s\033[0m %s\n", $1, $2;
}

# This action runs after all line have been tested.
END {
  # Print a cheeky message.
  print "\n\033[3m\"Be data, my friend!\"\033[0m";
}

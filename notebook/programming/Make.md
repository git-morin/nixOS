# Make

[Make](https://en.wikipedia.org/wiki/Make_(software)) is a declarative file (`Makefile`) which is often used as a build/developer tool for software.

I sometimes use a `Makefile`, and when I do I use the following template: 

```makefile
SHELL := /usr/bin/env bash
.DEFAULT_GOAL := help

hello:  ## Output 'Hello World'
	echo "Hello world"

world: # Output 'Hi World'
	echo "Hi world"

### Commands with ## after and on the same line as the subcommand name are shown in the help message using the comment as the command description.
help: ## Output help about the make commands.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

### Same rule as above but for a singular # and it will output every subcommand.
help-more: # Output extra help about the make commands.
	@grep -E '^[a-zA-Z_-]+:.*?# .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?# "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
```

This template allows subcommands to have their description shown in the `help` message.
To describe a subcommand, I add a `## description` after its declaration.
I also have a `help-more` command, which displays subcommands with a `# description` after their declaration (kind of like a verbose `help` showing everything)

```shell
$> make
hello                          Output 'Hello World'
help                           Output help about the make commands.
$> make help-more 
hello                          Output 'Hello World'
help-more                      Output extra help about the make commands.
help                           Output help about the make commands.
world                          Output 'Hi World'
```
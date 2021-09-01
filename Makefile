include make/general/Makefile
NETWORK := proxylampy
STACK   := proxy
include make/docker/Makefile

COMMANDS_SUPPORTED_COMMANDS := linter
COMMANDS_SUPPORTS_MAKE_ARGS := $(findstring $(firstword $(MAKECMDGOALS)), $(COMMANDS_SUPPORTED_COMMANDS))
ifneq "$(COMMANDS_SUPPORTS_MAKE_ARGS)" ""
  COMMANDS_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(COMMANDS_ARGS):;@:)
endif

GREEN := \033[0;32m
RED := \033[0;31m
YELLOW := \033[0;33m
NC := \033[0m
NEED := ${GREEN}%-20s${NC}: %s\n
MISSING :=${RED}ARGUMENT missing${NC}\n
ARGUMENTS := make ${PURPLE}%s${NC} ${YELLOW}ARGUMENT${NC}\n

.PHONY: install
install: node_modules ## Installation application
	@make docker image-pull -i
	@make docker deploy -i

.PHONY: linter
linter: node_modules ### Scripts Linter
ifeq ($(COMMAND_ARGS),all)
	@make linter readme -i
else ifeq ($(COMMAND_ARGS),readme)
	@npm run linter-markdown README.md
else
	@printf "${MISSING}"
	@echo "---"
	@printf "${ARGUMENTS}" linter
	@echo "---"
	@printf "${NEED}" "all" "all"
	@printf "${NEED}" "readme" "linter README.md"
endif
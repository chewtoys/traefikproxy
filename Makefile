include make/general/Makefile
NETWORK := proxynetwork
STACK   := proxy
include make/docker/Makefile

.PHONY: install
install: node_modules ## Installation application
	@make folders -i
	@make docker image-pull -i
	@make docker deploy -i

.PHONY: folders
folders: ## creation des dossier
	@mkdir letsencrypt

.PHONY: linter
linter: node_modules ## Scripts Linter *
ifeq ($(COMMAND_ARGS),all)
	@make linter readme -i
else ifeq ($(COMMAND_ARGS),readme)
	@npm run linter-markdown README.md
else
	@echo "ARGUMENT missing"
	@echo "---"
	@echo "make linter ARGUMENT"
	@echo "---"
	@echo "all: all"
	@echo "readme: linter README.md"
endif
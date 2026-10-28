.RECIPEPREFIX = >
.DEFAULT_GOAL := help
.PHONY: help check fmt init-tools

help: ## Muestra esta ayuda
> @grep -E '^[a-z-]+:.*##' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*## "}; {printf "  %-12s %s\n", $$1, $$2}'

check: ## Ejecuta todos los hooks de pre-commit sobre todo el repo
> pre-commit run --all-files

fmt: ## Formatea el codigo de Terraform
> terraform fmt -recursive

init-tools: ## Descarga los plugins de tflint
> tflint --init

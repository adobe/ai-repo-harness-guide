# Copyright 2026 Adobe. All rights reserved.
# This file is licensed to you under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License. You may obtain a copy
# of the License at http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software distributed under
# the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS
# OF ANY KIND, either express or implied. See the License for the specific language
# governing permissions and limitations under the License.

# Agents: run only make targets listed here. No direct shell commands.

.DEFAULT_GOAL := help

# ─── Help ─────────────────────────────────────────────────────────────────────

.PHONY: help
help: ## Show available commands
	@echo "Usage: make <target>"
	@echo ""
	@echo "Available targets:"
	@awk 'BEGIN {FS=":.*## "}; /^[a-zA-Z0-9_-]+:.*## / { printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

# ─── Dependencies ─────────────────────────────────────────────────────────────

.PHONY: lock
lock: ## Regenerate uv.lock from pyproject.toml
	uv lock

# ─── Docs ─────────────────────────────────────────────────────────────────────

.PHONY: docs-stage-skills
docs-stage-skills: ## Copy published skills into guide/skills/ for the build
	rm -rf guide/skills/harness-setup guide/skills/harness-inspect
	cp -rL .agents/skills/harness-setup .agents/skills/harness-inspect guide/skills/

.PHONY: docs-build
docs-build: docs-stage-skills  ## Build the docs site
	zensical build

.PHONY: docs-serve
docs-serve: docs-stage-skills  ## Serve the docs site locally
	zensical serve

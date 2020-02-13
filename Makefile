SHELL := /bin/bash
PATH := $(PWD)/test:$(PATH)

test-render:
	@helm template \
		terraform \
		. \
		--values ci/gcs.yaml \
		| kubeval
	@helm template \
		terraform \
		. \
		--values ci/gcs.yaml \
		--set-file google.serviceAccountKey=service-account-key.json \
		| kubeval

test-wrapper:
	@(./terraform-wrapper.sh -eq "**running locally**")



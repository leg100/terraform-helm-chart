test-render:
	@helm template \
		terraform \
		. \
		--values ci/gcs.yaml \
		--set-file google.serviceAccountKey=service-account-key.json \
		| kubeval

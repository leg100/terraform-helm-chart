test-render:
	@helm template \
		chart-1581237981 \
		. \
		--set-file google.serviceAccountKey=service-account-key.json \
		--set backend.create=true \
		--set backend.type=gcs \
		--set backend.config.bucket=automatize-tfstate \
		--set backend.config.prefix=funk \
		--set gcs.project=automatize-admin \
		| kubeval

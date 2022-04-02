.PHONY: build-docs

build-docs:
	swift package \
			--allow-writing-to-directory ./docs \
		generate-documentation \
			--target OAuth2Models \
			--output-path ./docs \
			--emit-digest \
			--disable-indexing \
			--transform-for-static-hosting \
			--hosting-base-path 'swift-oauth2-models'

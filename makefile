.PHONY: build-docs test test-docker test-local

build-docs:
	update-docc-gh-pages-documentation-site swift-oauth2-models OAuth2Models

test: test-local test-docker

test-docker:
	docker build .

test-local:
	swift test

FROM swift:5.9-focal as build

# Set up a build area
WORKDIR /build

# First just resolve dependencies.
# This creates a cached layer that can be reused
# as long as your Package.swift/Package.resolved
# files do not change.
COPY ./Package.* ./
RUN --mount=type=cache,target=/code/.build \
	swift package resolve

# Copy entire repo into container
COPY . .

# Run tests. The docker build will fail if the tests fail
RUN --mount=type=cache,target=/code/.build \
	swift test

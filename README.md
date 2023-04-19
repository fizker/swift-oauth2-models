# swift-oauth2-models

Swift models compatible with the [RFC 6749 OAuth2 spec](https://tools.ietf.org/html/rfc6749).

There is no logic outside of validations for data content and parsing of the raw JSON models into Swifty types.

DocC documentation for the project can be found at [https://fizker.github.io/swift-oauth2-models/documentation/oauth2models/](https://fizker.github.io/swift-oauth2-models/documentation/oauth2models/).


## How to use

1. Add `.package(url: "https://github.com/fizker/swift-oauth2-models.git", .upToNextMinor(from: "0.3.0"))` to the list of dependencies in your Package.swift file.
2. Add `.product(name: "OAuth2Models", package: "swift-oauth2-models")` to the dependencies of the targets that need to use the models.
3. Add `import OAuth2Models` in the file and use the types. See the examples or tests for more details at this level.


## Examples

For examples, see the content of the [Examples playground](Examples.playground).

- [4.5 Extension Grants](Examples.playground/Pages/4.5%20Extension%20Grant.xcplaygroundpage/Contents.swift) - Shows how to use custom types or types otherwise not supported by this library.
- [Decoding Custom Properties](Examples.playground/Pages/4.5%20Extension%20Grant.xcplaygroundpage/Contents.swift) - Shows how to decode custom properties.
  Short version: Simply call `decoder.decode(type, from: data)` multiple times with different `type` values and the same `data` value.

- [Encoding Custom Properties](Examples.playground/Pages/4.5%20Extension%20Grant.xcplaygroundpage/Contents.swift) - Shows how to encode custom properties.
  Short version: Use a custom `Encodable` type with an array of `Encodable` items, and a custom `encode(to:)` encoding the items one after another.

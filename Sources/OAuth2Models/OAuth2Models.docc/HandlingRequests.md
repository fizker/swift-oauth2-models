# Handling an incoming request

How to handle an incoming request and sending the appropriate response.

## Overview

### Handling a specific request

Typically, handling an incoming request starts at an endpoint. For example, a client
could post a ``PasswordAccessTokenRequest`` to a `/token` endpoint.

To decode such a request using [Vapor](https://vapor.codes):

```swift
app.post("token") { req in
	let request = try req.content.decode(PasswordAccessTokenRequest.self)
	...
}
```

The different types of `AccessTokenRequest` are all strongly typed, so that if the
client sent a ``ClientCredentialsAccessTokenRequest`` instead, the decoding would
fail and an error would be thrown.


### Supporting multiple Request types

Often, a server has to support multiple different Request types. For example, the
server could support one `AccessTokenRequest` and the ``RefreshTokenRequest``.
Or it could support multiple `AccessTokenRequest`s.

The naive way would be to catch the `DecodingError` thrown by the decode attempt, and then try another request:

```swift
app.post("token") { req in
	do {
		let request = try req.content.decode(PasswordAccessTokenRequest.self)
		...
	} catch _ as DecodingError {
		let request = try req.content.decode(RefreshTokenRequest.self)
		...
	}
}
```

But this can be quite verbose, and include a lot of boiler plate. Instead, the
``GrantRequest`` enum can be used in this scenario:

```swift
app.post("token") { req -> String in
	switch try req.content.decode(GrantRequest.self) {
	case .authCodeAccessToken(_), .clientCredentialsAccessToken(_):
		throw ErrorResponse(code: .unsupportedGrantType, description: nil)
	case let .passwordAccessToken(request):
		...
	case let .refreshToken(request):
		...
	}
}
```


### Handling custom or unsupported request types

To handle custom request types or request types not supported by this library,
see <doc:CustomTypes> for more details.

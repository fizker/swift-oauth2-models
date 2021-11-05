# Handling an incoming request

How to handle an incoming request and sending the appropriate response.

## Overview

### Handling a specific request

Typically, handling an incoming request starts at an endpoint. For example, an app
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

The simplest way would be to catch the `DecodingError` thrown by the decode attempt, and then try another request:

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


### Custom Grant Types

The OAuth2 standard is open-ended, so that new `Grant Type`s can be added as necessary.
This does mean that it is possible to require types that this library does not support.

In that case, the solution is simple. The ``GrantRequest`` throws an error if an
unknown `Grant Type` is detected.

```swift
app.post("token") { req -> String in
	do {
		let grant = try req.content.decode(GrantRequest.self)
		...

	} catch let GrantRequest.Error.unknownGrantType(type)
		where type == "my-custom-grant-type"
	{
		let customRequest = try req.content.decode(MyCustomType.self)
		...
	}
}
```

Alternatively, the custom type could be handled first, and only try the ``OAuth2Models``
types if the custom type cannot decode. Care should be taken though to ensure that
the custom type is as strict as possible, so that it does not absorb values of the other types.

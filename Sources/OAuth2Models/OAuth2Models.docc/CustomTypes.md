# Custom Grant Types and Properties

The OAuth2 standard is open, meaning that new Grant Types and custom properties are allowed.

The standard allows for adding custom Grant Types and custom properties.


## Custom Grant Types

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


## Decoding custom properties

Decoding custom properties is simple, because of the way that Swift handle decoding.
The basic concept is to make a type containing only the custom properties, and then
simply decoding the content twice.

```swift
struct CustomModel: Codable {
	// This is Optional because it is not part of the standard.
	var customProperty: String?
}

app.post("token") { req in
	let request = try req.content.decode(PasswordAccessTokenRequest.self)
	let custom = try req.content.decode(CustomModel.self)
	...
}
```


## Encoding custom properties

Encoding customer properties are a tad more complicated than decoding, because
each encoding would create an isolated result. So instead, a wrapper type is required:

```swift
struct MultipleValuesEncoder: Encodable {
	/// The items are encoded in the order that they have in the array, in case any property names overlap.
	var items: [Encodable]

	func encode(to encoder: Encoder) throws {
		try items.map { try $0.encode(to: encoder) }
	}
}

func sendRequest(_ request: PasswordAccessTokenRequest) async throws {
	let customModel = CustomModel(customProperty: "some value")
	let content = MultipleValuesEncoder(items: [ request, customModel ])
	await post(content, to: "/token")
}
```

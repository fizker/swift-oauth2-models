//: [Previous](@previous)

/*:
# Encoding Custom Properties

Encoding custom properties are a bit more complicated that decoding, but only slightly more.

First, make a Wrapper type with a custom `encode(to:)` func. This enables any combinations of types
conforming to `Encodable` to be encoded into the same output. The example `Wrapper` encodes items in
the order that they are passed in, so if any properties have the same name, the value in the latter item would win.

Then simply make a type with the custom properties. When encoding, pass the custom type and any other Encodable
into the `Wrapper`, and pass that into the `Encoder`.
*/

import Foundation
import OAuth2Models

/// The items are encoded in the order that they have in the array, in case any property names overlap.
struct Wrapper: Encodable {
	var items: [Encodable]

	func encode(to encoder: Encoder) throws {
		try items.map { try $0.encode(to: encoder) }
	}
}

struct CustomModel: Codable {
	var customVal: String
	var otherCustom: Int?
}

func encode() throws -> String {
	let encoder = JSONEncoder()
	encoder.outputFormatting = [ .prettyPrinted, .sortedKeys ]

	let password = PasswordAccessTokenRequest(username: "foo", password: "bar")
	let custom = CustomModel(customVal: "foo", otherCustom: 123)
	let data = try encoder.encode(Wrapper(items: [custom, password]))

	return String(data: data, encoding: .utf8)!
}

try encode()

//: [Next](@next)

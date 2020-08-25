//: [Previous](@previous)

/*:
# Decoding Custom Properties

Decoding custom properties is simple. Just decode with the built-in type first
to ascertain the grant type, and then decode with your own type to get the custom properties.
*/

import Foundation
import OAuth2Models

struct CustomModel: Codable {
	var customVal: String
	var otherCustom: Int?
}

func decode(_ json: String) throws -> (PasswordAccessTokenRequest, CustomModel?) {
	let data = json.data(using: .utf8)!
	let decoder = JSONDecoder()

	let standard = try decoder.decode(PasswordAccessTokenRequest.self, from: data)
	let custom = try? decoder.decode(CustomModel.self, from: data)

	return (standard, custom)
}

// Has no custom properties
try decode("""
{
	"grant_type": "password",
	"username": "foo",
	"password": "bar"
}
""")

// Has both custom properties
try decode("""
{
	"grant_type": "password",
	"username": "foo",
	"password": "bar",
	"customVal": "baz",
	"otherCustom": 1
}
""")

// Has the required value in the custom type
try decode("""
{
	"grant_type": "password",
	"username": "foo",
	"password": "bar",
	"customVal": "baz"
}
""")

// Has invalid value for the required value (Number instead of String)
try decode("""
{
	"grant_type": "password",
	"username": "foo",
	"password": "bar",
	"customVal": 1
}
""")

//: [Next](@next)

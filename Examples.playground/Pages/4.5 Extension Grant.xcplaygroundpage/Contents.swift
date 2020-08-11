/*:
# 4.5 Extension Grant

Example showing how to parse both the built-in types as well as custom grant types not supported by this package.
*/

import Foundation
import OAuth2Models

//: Lets assume that we use a custom grant request with grant_type == custom-type
struct CustomGrantRequest: Codable {
	enum GrantType: String, Codable { case custom = "custom-type" }
	let grant_type: GrantType
	let custom_token: String
}

enum ReturnType {
	case custom(String)
	case knownType(GrantRequest)
}
func parseJSON(_ json: String) throws -> ReturnType {
	let data = json.data(using: .utf8)!
	let decoder = JSONDecoder()

	do {
		//: We try the built-in types first
		let grant = try decoder.decode(GrantRequest.self, from: data)
		return .knownType(grant)

	//: If it fails with our custom type, we try to decode to our CustomGrantRequest
	} catch let GrantRequest.Error.unknownGrantType(type)
		where type == CustomGrantRequest.GrantType.custom.rawValue
	{
		let customType = try decoder.decode(CustomGrantRequest.self, from: data)
		return .custom(customType.custom_token)
	}

	//: Any other error is propagated upward for regular handling
}

// Returns some-token
try! parseJSON("""
{
	"grant_type": "custom-type",
	"custom_token": "some-token"
}
""")

// Returns a PasswordAccessTokenRequest
try! parseJSON("""
{
	"grant_type": "password",
	"username": "abc",
	"password": "def"
}
""")

// Throws the GrantRequest.Error.unknownGrantType error
try? parseJSON("""
{
	"grant_type": "another-custom"
}
""")

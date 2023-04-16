import Foundation
import XCTest
import OAuth2Models

class ClientCredentialsAccessTokenRequestTests: XCTestCase {
	var json: [ClientCredentialsAccessTokenRequest.CodingKeys: String] = [:]

	override func setUpWithError() throws {
		json = [
			.grantType: "client_credentials",
			.scope: "foo bar",
		]
	}

	func test__setUp__noChanges__decodesAsExpected() throws {
		let data = try encode(json)
		XCTAssertNoThrow(try decode(data) as ClientCredentialsAccessTokenRequest)
	}

	func test__decodable__missingScope__decodesAsExpected() throws {
		json.removeValue(forKey: .scope)
		let data = try encode(json)
		let actual = try decode(data) as ClientCredentialsAccessTokenRequest

		let expected = ClientCredentialsAccessTokenRequest()
		XCTAssertEqual(expected, actual)
	}

	func test__decodable__scopeSetToNull__decodesAsExpected() throws {
		let data = """
		{
			"grant_type": "client_credentials",
			"scope": null
		}
		""".data(using: .utf8)!
		let request = try decode(data) as ClientCredentialsAccessTokenRequest

		XCTAssertTrue(request.scope.isEmpty)
	}

	func test__decodable__invalidGrantType__throws() throws {
		json[.grantType] = "foo"
		let data = try encode(json)

		XCTAssertThrowsError(try decode(data) as ClientCredentialsAccessTokenRequest)
	}

	func test__decodable__missingGrantType__throws() throws {
		json.removeValue(forKey: .grantType)
		let data = try encode(json)
		XCTAssertThrowsError(try decode(data) as ClientCredentialsAccessTokenRequest)
	}

	func test__encodable__fullObject__encodesAsExpected() throws {
		let object = ClientCredentialsAccessTokenRequest(grantType: .clientCredentials, scope: "abc", clientID: "id", clientSecret: "secret")
		let data = try encode(object)
		let actual = try decode(data) as [String: String]

		let expected = [
			"grant_type": "client_credentials",
			"scope": "abc",
			"client_id": "id",
			"client_secret": "secret",
		]
		XCTAssertEqual(actual, expected)
	}

	func test__encodable__minimalObject__encodesAsExpected() throws {
		let object = ClientCredentialsAccessTokenRequest()
		let data = try encode(object)
		let actual = try decode(data) as [String: String]

		let expected = [
			"grant_type": "client_credentials",
		]
		XCTAssertEqual(actual, expected)
	}

	func test__encodable__scopeWithMultipleValues__encodesAsExpected() throws {
		let value = ClientCredentialsAccessTokenRequest(scope: try Scope(items: ["foo", "bar"]))
		let data = try encode(value)
		var actual = try decode(data) as [String:String]

		let expected = [
			"grant_type": "client_credentials",
		]

		// Scope is unsorted, so we need to convert to an unsorted storage
		XCTAssertEqual(["bar", "foo"], try Scope(string: actual["scope"] ?? ""))
		actual.removeValue(forKey: "scope")

		XCTAssertEqual(actual, expected)
	}

	func test__encodable__clientIDIsPresent_clientSecretIsNot__encodesAsExpected() throws {
		let object = ClientCredentialsAccessTokenRequest(grantType: .clientCredentials, scope: "abc", clientID: "id")
		let data = try encode(object)
		let actual = try decode(data) as [String: String]

		let expected = [
			"grant_type": "client_credentials",
			"scope": "abc",
			"client_id": "id",
		]
		XCTAssertEqual(actual, expected)
	}

	func test__encodable__clientIDIsNotPresent_clientSecretIsPresent__encodesAsExpected() throws {
		let object = ClientCredentialsAccessTokenRequest(grantType: .clientCredentials, scope: "abc", clientSecret: "secret")
		let data = try encode(object)
		let actual = try decode(data) as [String: String]

		let expected = [
			"grant_type": "client_credentials",
			"scope": "abc",
			"client_secret": "secret",
		]
		XCTAssertEqual(actual, expected)
	}

	func test__encodable__clientSecretIsEmptyString__clientSecretIsIncluded() throws {
		let object = ClientCredentialsAccessTokenRequest(grantType: .clientCredentials, scope: "abc", clientID: "id", clientSecret: "")
		let data = try encode(object)
		let actual = try decode(data) as [String: String]

		let expected = [
			"grant_type": "client_credentials",
			"scope": "abc",
			"client_id": "id",
			"client_secret": "",
		]
		XCTAssertEqual(actual, expected)
	}
}

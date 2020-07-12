import XCTest
import OAuth2Models

final class AccessTokenRequestTests: XCTestCase {
	var json: [AccessTokenRequest.CodingKeys: String] = [:]

	override func setUpWithError() throws {
		json = [
			.grantType: "authorization_code",
			.code: "abc",
			.redirectURL: "https://example.com/a",
			.clientID: "def",
		]
	}

	func test__setUp__noChanges__decodesCorrectly() throws {
		let data = try encode(json)
		XCTAssertNoThrow(try decode(data) as AccessTokenRequest)
	}

	func test__decodable__missingRedirectURI__returnsDecodedObject() throws {
		json.removeValue(forKey: .redirectURL)
		let data = try encode(json)
		let request = try decode(data) as AccessTokenRequest

		XCTAssertNil(request.redirectURL)
	}

	func test__decodable__invalidGrantType__throws() throws {
		json[.grantType] = "foo"
		let data = try encode(json)

		XCTAssertThrowsError(try decode(data) as AccessTokenRequest)
	}

	func test__decodable__invalidRedirectURL__throws() throws {
		throw XCTSkip("Should throw if URL is invalid. It currently simply decodes to nil")

		json[.redirectURL] = "invalid"
		let data = try encode(json)

		XCTAssertThrowsError(try decode(data) as AccessTokenRequest)
	}

	func test__encodable__fullObject__encodesAsExpected() throws {
		let object = AccessTokenRequest(
			grantType: .authorizationCode,
			code: "foo",
			redirectURL: "https://example.com",
			clientID: "baz"
		)
		let data = try encode(object)
		let actual = try decode(data) as [String: String]

		let expected = [
			"grant_type": "authorization_code",
			"code": "foo",
			"redirect_uri": "https://example.com",
			"client_id": "baz",
		]

		XCTAssertEqual(actual, expected)
	}

	func test__encodable__minimalObject__encodesAsExpected() throws {
		let object = AccessTokenRequest(
			code: "foo",
			redirectURL: nil,
			clientID: nil
		)
		let data = try encode(object)
		let actual = try decode(data) as [String: String]

		let expected = [
			"grant_type": "authorization_code",
			"code": "foo",
		]

		XCTAssertEqual(actual, expected)
	}
}

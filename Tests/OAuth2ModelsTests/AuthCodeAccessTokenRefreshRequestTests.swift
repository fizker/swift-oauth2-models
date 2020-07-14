import XCTest
import OAuth2Models

final class AuthCodeGrantAccessTokenRefreshRequestTests: XCTestCase {
	var json: [AuthCodeAccessTokenRefreshRequest.CodingKeys: String] = [:]

	override func setUpWithError() throws {
		json = [
			.grantType: "refresh_token",
			.refreshToken: "foo",
			.scope: "bar",
		]
	}

	func test__setUp__noChanges__decodesCorrectly() throws {
		let data = try encode(json)
		XCTAssertNoThrow(try decode(data) as AuthCodeAccessTokenRefreshRequest)
	}

	func test__decodable__scopeSetToNull__returnsDecodedObject() throws {
		json[.scope] = nil
		let data = """
		{
			"grant_type": "refresh_token",
			"refresh_token": "foo",
			"scope": null
		}
		""".data(using: .utf8)!
		let request = try decode(data) as AuthCodeAccessTokenRefreshRequest

		XCTAssertTrue(request.scope.isEmpty)
	}

	func test__decodable__missingScope__returnsDecodedObject() throws {
		json.removeValue(forKey: .scope)
		let data = try encode(json)
		let request = try decode(data) as AuthCodeAccessTokenRefreshRequest

		XCTAssertTrue(request.scope.isEmpty)
	}

	func test__decodable__invalidGrantType__throws() throws {
		json[.grantType] = "foo"
		let data = try encode(json)

		XCTAssertThrowsError(try decode(data) as AuthCodeAccessTokenRefreshRequest)
	}

	func test__decodable__missingGrantType__throws() throws {
		json.removeValue(forKey: .grantType)
		let data = try encode(json)

		XCTAssertThrowsError(try decode(data) as AuthCodeAccessTokenRefreshRequest)
	}

	func test__decodable__missingRefreshToken__throws() throws {
		json.removeValue(forKey: .refreshToken)
		let data = try encode(json)

		XCTAssertThrowsError(try decode(data) as AuthCodeAccessTokenRefreshRequest)
	}

	func test__encodable__fullObject__encodesAsExpected() throws {
		let object = AuthCodeAccessTokenRefreshRequest(refreshToken: "foo", scope: "bar")
		let data = try encode(object)
		let actual = try decode(data) as [String: String]

		let expected = [
			"grant_type": "refresh_token",
			"refresh_token": "foo",
			"scope": "bar",
		]

		XCTAssertEqual(actual, expected)
	}

	func test__encodable__minimalObject__encodesAsExpected() throws {
		let object = AuthCodeAccessTokenRefreshRequest(refreshToken: "foo")
		let data = try encode(object)
		let actual = try decode(data) as [String: String]

		let expected = [
			"grant_type": "refresh_token",
			"refresh_token": "foo",
		]

		XCTAssertEqual(actual, expected)
	}
}

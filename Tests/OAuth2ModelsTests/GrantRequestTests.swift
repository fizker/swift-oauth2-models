import XCTest
import OAuth2Models

final class GrantRequestTests: XCTestCase {
	var accessTokenJSON: [AccessTokenRequest.CodingKeys: String] = [:]
	var accessTokenRefreshJSON: [AccessTokenRefreshRequest.CodingKeys: String] = [:]

	override func setUpWithError() throws {
		accessTokenJSON = [
			.grantType: "authorization_code",
			.code: "abc",
			.redirectURL: "https://example.com/a",
			.clientID: "def",
		]
		accessTokenRefreshJSON = [
			.grantType: "refresh_token",
			.refreshToken: "foo",
			.scope: "bar",
		]
	}

	func test__decodable__unknownGrantType__throws() throws {
		accessTokenRefreshJSON[.grantType] = "foo"
		let data = try encode(accessTokenRefreshJSON)

		XCTAssertThrowsError(try decode(data) as GrantRequest) { e in
			if let e = e as? GrantRequest.Error {
				switch e {
				case .unknownGrantType(let type):
					XCTAssertEqual("foo", type)
				}
			} else {
				XCTFail("Unexpected error: \(e)")
			}
		}
	}

	func test__decodable__AccessTokenRefreshRequest_FullData__returnsObject() throws {
		let data = try encode(accessTokenRefreshJSON)
		let expected = try decode(data) as AccessTokenRefreshRequest
		let actual = try decode(data) as GrantRequest

		XCTAssertEqual(.refreshAccessToken(expected), actual)
	}

	func test__decodable__AccessTokenRefreshRequest_minimumData__returnsObject() throws {
		accessTokenRefreshJSON.removeValue(forKey: .scope)
		let data = try encode(accessTokenRefreshJSON)
		let expected = try decode(data) as AccessTokenRefreshRequest
		let actual = try decode(data) as GrantRequest

		XCTAssertEqual(.refreshAccessToken(expected), actual)
	}

	func test__decodable__AccessTokenRequest_FullData__returnsObject() throws {
		let data = try encode(accessTokenJSON)
		let expected = try decode(data) as AccessTokenRequest
		let actual = try decode(data) as GrantRequest

		XCTAssertEqual(.accessToken(expected), actual)
	}

	func test__decodable__AccessTokenRequest_minimumData__returnsObject() throws {
		accessTokenJSON.removeValue(forKey: .redirectURL)
		let data = try encode(accessTokenJSON)
		let expected = try decode(data) as AccessTokenRequest
		let actual = try decode(data) as GrantRequest

		XCTAssertEqual(.accessToken(expected), actual)
	}
}

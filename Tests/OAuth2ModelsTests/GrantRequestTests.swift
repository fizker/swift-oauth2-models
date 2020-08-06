import XCTest
import OAuth2Models

final class GrantRequestTests: XCTestCase {
	var accessTokenJSON: [AuthCodeAccessTokenRequest.CodingKeys: String] = [:]
	var accessTokenRefreshJSON: [AuthCodeAccessTokenRefreshRequest.CodingKeys: String] = [:]
	var passwordAccessTokenJSON: [PasswordAccessTokenRequest.CodingKeys: String] = [:]

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
		passwordAccessTokenJSON = [
			.grantType: "password",
			.username: "foo",
			.password: "bar",
			.scope: "baz",
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

	func test__decodable__AuthCodeGrantAccessTokenRefreshRequest_FullData__returnsObject() throws {
		let data = try encode(accessTokenRefreshJSON)
		let expected = try decode(data) as AuthCodeAccessTokenRefreshRequest
		let actual = try decode(data) as GrantRequest

		XCTAssertEqual(.authCodeRefreshAccessToken(expected), actual)
	}

	func test__decodable__AuthCodeGrantAccessTokenRefreshRequest_minimumData__returnsObject() throws {
		accessTokenRefreshJSON.removeValue(forKey: .scope)
		let data = try encode(accessTokenRefreshJSON)
		let expected = try decode(data) as AuthCodeAccessTokenRefreshRequest
		let actual = try decode(data) as GrantRequest

		XCTAssertEqual(.authCodeRefreshAccessToken(expected), actual)
	}

	func test__decodable__AuthCodeGrantAccessTokenRequest_FullData__returnsObject() throws {
		let data = try encode(accessTokenJSON)
		let expected = try decode(data) as AuthCodeAccessTokenRequest
		let actual = try decode(data) as GrantRequest

		XCTAssertEqual(.authCodeAccessToken(expected), actual)
	}

	func test__decodable__AuthCodeGrantAccessTokenRequest_minimumData__returnsObject() throws {
		accessTokenJSON.removeValue(forKey: .redirectURL)
		let data = try encode(accessTokenJSON)
		let expected = try decode(data) as AuthCodeAccessTokenRequest
		let actual = try decode(data) as GrantRequest

		XCTAssertEqual(.authCodeAccessToken(expected), actual)
	}

	func test__decodable__PasswordAccessTokenRequest__fullData() throws {
		let data = try encode(passwordAccessTokenJSON)
		let expected = try decode(data) as PasswordAccessTokenRequest
		let actual = try decode(data) as GrantRequest

		XCTAssertEqual(.passwordAccessToken(expected), actual)
	}

	func test__decodable__PasswordAccessTokenRequest__minimumData() throws {
		passwordAccessTokenJSON.removeValue(forKey: .scope)
		let data = try encode(passwordAccessTokenJSON)
		let expected = try decode(data) as PasswordAccessTokenRequest
		let actual = try decode(data) as GrantRequest

		XCTAssertEqual(.passwordAccessToken(expected), actual)
	}
}

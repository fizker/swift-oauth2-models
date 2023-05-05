import XCTest
import OAuth2Models

final class GrantRequestTests: XCTestCase {
	var accessTokenJSON: [AuthCodeAccessTokenRequest.CodingKeys: String] = [:]
	var accessTokenRefreshJSON: [RefreshTokenRequest.CodingKeys: String] = [:]
	var passwordAccessTokenJSON: [PasswordAccessTokenRequest.CodingKeys: String] = [:]
	var clientCredentialsAccessTokenRequestJSON: [ClientCredentialsAccessTokenRequest.CodingKeys: String] = [:]

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
		clientCredentialsAccessTokenRequestJSON = [
			.grantType: "client_credentials",
			.scope: "foo bar",
		]
	}

	func test__decodable__unknownGrantType__returnsObject() throws {
		accessTokenRefreshJSON[.grantType] = "foo"
		let data = try encode(accessTokenRefreshJSON)

		let actual = try decode(data) as GrantRequest

		XCTAssertEqual(.unknown("foo"), actual)
	}

	func test__decodable__AuthCodeGrantRefreshTokenRequest_FullData__returnsObject() throws {
		let data = try encode(accessTokenRefreshJSON)
		let expected = try decode(data) as RefreshTokenRequest
		let actual = try decode(data) as GrantRequest

		XCTAssertEqual(.refreshToken(expected), actual)
	}

	func test__decodable__AuthCodeGrantRefreshTokenRequest_minimumData__returnsObject() throws {
		accessTokenRefreshJSON.removeValue(forKey: .scope)
		let data = try encode(accessTokenRefreshJSON)
		let expected = try decode(data) as RefreshTokenRequest
		let actual = try decode(data) as GrantRequest

		XCTAssertEqual(.refreshToken(expected), actual)
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

	func test__decodable__PasswordAccessTokenRequest_fullData__decodesAsExpected() throws {
		let data = try encode(passwordAccessTokenJSON)
		let expected = try decode(data) as PasswordAccessTokenRequest
		let actual = try decode(data) as GrantRequest

		XCTAssertEqual(.passwordAccessToken(expected), actual)
	}

	func test__decodable__PasswordAccessTokenRequest_minimumData__decodesAsExpected() throws {
		passwordAccessTokenJSON.removeValue(forKey: .scope)
		let data = try encode(passwordAccessTokenJSON)
		let expected = try decode(data) as PasswordAccessTokenRequest
		let actual = try decode(data) as GrantRequest

		XCTAssertEqual(.passwordAccessToken(expected), actual)
	}

	func test__decodable__ClientCredentialsAccessTokenRequest_fullData__decodesAsExpected() throws {
		let data = try encode(clientCredentialsAccessTokenRequestJSON)
		let expected = try decode(data) as ClientCredentialsAccessTokenRequest
		let actual = try decode(data) as GrantRequest

		XCTAssertEqual(.clientCredentialsAccessToken(expected), actual)
	}

	func test__decodable__ClientCredentialsAccessTokenRequest_minimumData__decodesAsExpected() throws {
		clientCredentialsAccessTokenRequestJSON.removeValue(forKey: .scope)
		let data = try encode(clientCredentialsAccessTokenRequestJSON)
		let expected = try decode(data) as ClientCredentialsAccessTokenRequest
		let actual = try decode(data) as GrantRequest

		XCTAssertEqual(.clientCredentialsAccessToken(expected), actual)
	}
}

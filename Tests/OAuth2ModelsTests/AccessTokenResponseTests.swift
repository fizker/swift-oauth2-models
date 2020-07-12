import XCTest
import OAuth2Models

final class AccessTokenResponseTests: XCTestCase {
	func test__decodable__fullObject__decodesAsExpected() throws {
		let data = try json()
		let object = try decode(data)

		XCTAssertEqual(object.accessToken, "access token value")
		XCTAssertEqual(object.type, .bearer)
		XCTAssertEqual(object.expiration, .seconds(123))
		XCTAssertEqual(object.refreshToken, "refresh token value")
		XCTAssertEqual(object.scope, "some scope")
	}

	func test__decodable__minimumObject__decodesAsExpected() throws {
		let data = try json(expiresIn: nil, refreshToken: nil, scope: nil)
		let object = try decode(data)

		XCTAssertEqual(object.accessToken, "access token value")
		XCTAssertEqual(object.type, .bearer)
		XCTAssertNil(object.expiration)
		XCTAssertNil(object.refreshToken)
		XCTAssertNil(object.scope)
	}

	func test__decodable__decimalExpiration__decodesAsExpected() throws {
		let data = try json(expiresIn: 123.8)
		let object = try decode(data)

		XCTAssertEqual(object.expiration, .seconds(123))
	}

	func test__decodable__macTokenType__decodesAsExpected() throws {
		let data = try json(tokenType: "mac")
		let object = try decode(data)

		XCTAssertEqual(object.type, .mac)
	}

	func test__decodable__invalidExpiresIn__throws() throws {
		let data = try json(expiresIn: #""abc""#)
		XCTAssertThrowsError(try decode(data))
	}

	func test__encodable__fullObject_macTokenType__returnsValidJSON() throws {
		let object = AccessTokenResponse(accessToken: "foo", type: .mac, expiresIn: .oneDay, refreshToken: "ref tok", scope: "scope")
		let json = try encode(object)
		let jsonObject = try JSONSerialization.jsonObject(with: json, options: []) as! NSDictionary

		XCTAssertEqual(jsonObject, [
			"access_token": "foo",
			"token_type": "mac",
			"expires_in": 86400,
			"refresh_token": "ref tok",
			"scope": "scope",
		])
	}

	func test__encodable__minimumObject_macTokenType__returnsValidJSON() throws {
		let object = AccessTokenResponse(accessToken: "foo", type: .mac, expiresIn: nil)
		let json = try encode(object)
		let jsonObject = try JSONSerialization.jsonObject(with: json, options: []) as! NSDictionary

		XCTAssertEqual(jsonObject, [
			"access_token": "foo",
			"token_type": "mac",
		])
	}

	private func json(
		accessToken: String = "access token value",
		tokenType: String = "bearer",
		expiresIn: Double,
		refreshToken: String? = "refresh token value",
		scope: String? = "some scope"
	) throws -> Data {
		try json(
			accessToken: accessToken,
			tokenType: tokenType,
			expiresIn: "\(expiresIn)",
			refreshToken: refreshToken,
			scope: scope
		)
	}
	private func json(
		accessToken: String = "access token value",
		tokenType: String = "bearer",
		expiresIn: String? = "123",
		refreshToken: String? = "refresh token value",
		scope: String? = "some scope"
	) throws -> Data {
		func encode<T: Encodable>(_ v: T) throws -> String {
			let data = try OAuth2ModelsTests.encode(v)
			let string = String(data: data, encoding: .utf8)
			return string!
		}

		var values = [
			#""access_token": \#(try encode(accessToken))"#,
			#""token_type": \#(try encode(tokenType))"#,
		]

		if let expiresIn = expiresIn {
			values.append(#""expires_in": \#(expiresIn)"#)
		}
		if let refreshToken = refreshToken {
			values.append(#""refresh_token": \#(try encode(refreshToken))"#)
		}
		if let scope = scope {
			values.append(#""scope": \#(try encode(scope))"#)
		}

		let json = """
		{
			\(values.joined(separator: ",\n\t"))
		}
		"""

		return json.data(using: .utf8)!
	}

	private func decode(_ data: Data) throws -> AccessTokenResponse {
		try OAuth2ModelsTests.decode(data)
	}
}

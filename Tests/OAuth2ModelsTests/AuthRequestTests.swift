import XCTest
import OAuth2Models

final class AuthRequestTests: XCTestCase {
	typealias JSON = [AuthRequest.CodingKeys: String]
	var json: JSON = [:]

	override func setUpWithError() throws {
		json = [
			.clientID: "client",
			.responseType: "code",
			.redirectURL: "https://example.com",
			.state: "some state",
			.scope: "some scope",
		]
	}

	func test__equalsOperator() throws {
		let tests = [
			(
				AuthRequest(
					responseType: .code,
					clientID: "client",
					redirectURL: URL(string: "https://example.com")!,
					state: "some state",
					scope: "some scope"
				),
				AuthRequest(
					responseType: .code,
					clientID: "client",
					redirectURL: URL(string: "https://example.com")!,
					state: "some state",
					scope: "some scope"
				),
				true
			),
			(
				AuthRequest(
					responseType: .code,
					clientID: "client",
					redirectURL: URL(string: "https://example.com")!,
					state: "some state",
					scope: "some scope"
				),
				AuthRequest(
					responseType: .token,
					clientID: "client",
					redirectURL: URL(string: "https://example.com")!,
					state: "some state",
					scope: "some scope"
				),
				false
			),
			(
				AuthRequest(
					responseType: .code,
					clientID: "client",
					redirectURL: URL(string: "https://example.com")!,
					state: "some state",
					scope: "some scope"
				),
				AuthRequest(
					responseType: .code,
					clientID: "client2",
					redirectURL: URL(string: "https://example.com")!,
					state: "some state",
					scope: "some scope"
				),
				false
			),
			(
				AuthRequest(
					responseType: .code,
					clientID: "client",
					redirectURL: URL(string: "https://example.com")!,
					state: "some state",
					scope: "some scope"
				),
				AuthRequest(
					responseType: .code,
					clientID: "client",
					state: "some state",
					scope: "some scope"
				),
				false
			),
			(
				AuthRequest(
					responseType: .code,
					clientID: "client",
					redirectURL: URL(string: "https://example.com")!,
					state: "some state",
					scope: "some scope"
				),
				AuthRequest(
					responseType: .code,
					clientID: "client",
					redirectURL: URL(string: "https://example.com/foo")!,
					state: "some state",
					scope: "some scope"
				),
				false
			),
			(
				AuthRequest(
					responseType: .code,
					clientID: "client",
					redirectURL: URL(string: "https://example.com")!,
					state: "some state",
					scope: "some scope"
				),
				AuthRequest(
					responseType: .code,
					clientID: "client",
					redirectURL: URL(string: "https://foo.com")!,
					state: "some state",
					scope: "some scope"
				),
				false
			),
			(
				AuthRequest(
					responseType: .code,
					clientID: "client",
					redirectURL: URL(string: "https://example.com")!,
					state: "some state",
					scope: "some scope"
				),
				AuthRequest(
					responseType: .code,
					clientID: "client",
					redirectURL: URL(string: "https://example.com")!,
					state: "some other state",
					scope: "some scope"
				),
				false
			),
			(
				AuthRequest(
					responseType: .code,
					clientID: "client",
					redirectURL: URL(string: "https://example.com")!,
					state: "some state",
					scope: "some scope"
				),
				AuthRequest(
					responseType: .code,
					clientID: "client",
					redirectURL: URL(string: "https://example.com")!,
					state: nil,
					scope: "some scope"
				),
				false
			),
			(
				AuthRequest(
					responseType: .code,
					clientID: "client",
					redirectURL: URL(string: "https://example.com")!,
					state: "some state",
					scope: "some scope"
				),
				AuthRequest(
					responseType: .code,
					clientID: "client",
					redirectURL: URL(string: "https://example.com")!,
					state: "some state",
					scope: "some other scope"
				),
				false
			),
			(
				AuthRequest(
					responseType: .code,
					clientID: "client",
					redirectURL: URL(string: "https://example.com")!,
					state: "some state",
					scope: "some scope"
				),
				AuthRequest(
					responseType: .code,
					clientID: "client",
					redirectURL: URL(string: "https://example.com")!,
					state: "some state",
					scope: Scope()
				),
				false
			),
		]

		for (lhs, rhs, expected) in tests {
			XCTAssertEqual(lhs == rhs, expected, "\(lhs) == \(rhs)")
			XCTAssertEqual(lhs == rhs, rhs == lhs, "order of operands")
		}
	}

	func test__decodable__scopeSetToNull__decodesAsExpected() throws {
		let json = """
		{
			"response_type": "code",
			"client_id": "client",
			"scope": null
		}
		"""

		let data = json.data(using: .utf8)!
		let object = try decode(data) as AuthRequest

		XCTAssertEqual(object, AuthRequest(
			responseType: .code,
			clientID: "client",
			state: nil,
			scope: Scope()
		))
	}

	func test__decodable__authCode_minimumObject__decodesAsExpected() throws {
		json.removeValue(forKey: .redirectURL)
		json.removeValue(forKey: .scope)
		json.removeValue(forKey: .state)

		let data = try encode(json)
		let object = try decode(data) as AuthRequest

		XCTAssertEqual(object, AuthRequest(
			responseType: .code,
			clientID: "client",
			state: nil,
			scope: Scope()
		))
	}

	func test__decodable__authCode_fullObject__decodesAsExpected() throws {
		let data = try encode(json)
		let object = try decode(data) as AuthRequest

		XCTAssertEqual(object, AuthRequest(
			responseType: .code,
			clientID: "client",
			redirectURL: URL(string: "https://example.com")!,
			state: "some state",
			scope: "some scope"
		))
	}

	func test__decodable__implicitGrant_minimumObject__decodesAsExpected() throws {
		json[.responseType] = "token"
		json.removeValue(forKey: .redirectURL)
		json.removeValue(forKey: .scope)
		json.removeValue(forKey: .state)

		let data = try encode(json)
		let object = try decode(data) as AuthRequest

		XCTAssertEqual(object, AuthRequest(
			responseType: .token,
			clientID: "client",
			state: nil,
			scope: Scope()
		))
	}

	func test__decodable__implicitGrant_fullObject__decodesAsExpected() throws {
		json[.responseType] = "token"
		let data = try encode(json)
		let object = try decode(data) as AuthRequest

		XCTAssertEqual(object, AuthRequest(
			responseType: .token,
			clientID: "client",
			redirectURL: URL(string: "https://example.com")!,
			state: "some state",
			scope: "some scope"
		))
	}

	func test__decodable__invalidRedirectURL__throws() throws {
		throw XCTSkip("Should throw if URL is invalid. It currently simply decodes to nil")

		json[.redirectURL] = "invalid"
		let data = try encode(json)

		XCTAssertThrowsError(try decode(data) as AuthRequest)
	}

	func test__decodable__invalidResponseType__throws() throws {
		json[.responseType] = "foo"
		let data = try encode(json)
		XCTAssertThrowsError(try decode(data) as AuthRequest)
	}

	func test__encodable__authCode_fullObject__encodesAsJSON() throws {
		let object = AuthRequest(
			responseType: .code,
			clientID: "client",
			redirectURL: URL(string: "https://example.com")!,
			state: "some state",
			scope: "some scope"
		)
		let data = try encode(object)
		var actual = try decode(data) as [String: String]

		let expected: [String: String] = [
			"client_id": "client",
			"response_type": "code",
			"redirect_uri": "https://example.com",
			"state": "some state",
		]

		let expectedScope = ["some", "scope"]
		let actualScope = actual.removeValue(forKey: "scope")?.split(separator: " ").map(String.init)

		XCTAssertEqual(actual, expected)
		XCTAssertEqual(actualScope?.sorted(), expectedScope.sorted())
	}

	func test__encodable__authCode_minimumObject__encodesAsJSON() throws {
		let object = AuthRequest(
			responseType: .code,
			clientID: "client",
			state: nil,
			scope: Scope()
		)
		let data = try encode(object)
		let actual = try decode(data) as [String: String]

		let expected: [String: String] = [
			"client_id": "client",
			"response_type": "code",
		]

		XCTAssertEqual(actual, expected)
	}

	func test__encodable__implicitGrant_fullObject__encodesAsJSON() throws {
		let object = AuthRequest(
			responseType: .token,
			clientID: "client",
			redirectURL: URL(string: "https://example.com")!,
			state: "some state",
			scope: "some scope"
		)
		let data = try encode(object)
		var actual = try decode(data) as [String: String]

		let expected: [String: String] = [
			"client_id": "client",
			"response_type": "token",
			"redirect_uri": "https://example.com",
			"state": "some state",
		]

		let expectedScope = ["some", "scope"]
		let actualScope = actual.removeValue(forKey: "scope")?.split(separator: " ").map(String.init)

		XCTAssertEqual(actual, expected)
		XCTAssertEqual(actualScope?.sorted(), expectedScope.sorted())
	}

	func test__encodable__implicitGrant_minimumObject__encodesAsJSON() throws {
		let object = AuthRequest(
			responseType: .token,
			clientID: "client",
			state: nil,
			scope: Scope()
		)
		let data = try encode(object)
		let actual = try decode(data) as [String: String]

		let expected: [String: String] = [
			"client_id": "client",
			"response_type": "token",
		]

		XCTAssertEqual(actual, expected)
	}

	func test__response__minimalObject__returnsAuthResponse() throws {
		let request = AuthRequest(
			responseType: .code,
			clientID: "client id",
			state: nil,
			scope: Scope()
		)

		let response = request.response(code: "response code")

		XCTAssertEqual(response, AuthCodeAuthResponse(code: "response code", state: nil))
	}

	func test__response__fullObject__returnsAuthResponse() throws {
		let request = AuthRequest(
			responseType: .code,
			clientID: "client id",
			redirectURL: URL(string: "https://example.com")!,
			state: "some state",
			scope: "some scope"
		)

		let response = request.response(code: "response code")

		XCTAssertEqual(response, AuthCodeAuthResponse(code: "response code", state: "some state"))
	}

	func test__error__minimalObject_minimalError__returnsErrorResponse() throws {
		let request = AuthRequest(
			responseType: .code,
			clientID: "client id",
			state: nil,
			scope: Scope()
		)

		let error = request.error(
			code: .temporarilyUnavailable,
			description: nil,
			url: nil
		)

		XCTAssertEqual(error, ErrorResponse(
			code: .temporarilyUnavailable,
			description: nil,
			state: nil
		))
	}

	func test__error__fullObject_minimalError__returnsErrorResponse() throws {
		let request = AuthRequest(
			responseType: .code,
			clientID: "client id",
			redirectURL: URL(string: "https://example.com")!,
			state: "some state",
			scope: "some scope"
		)

		let error = request.error(
			code: .temporarilyUnavailable,
			description: nil,
			url: nil
		)

		XCTAssertEqual(error, ErrorResponse(
			code: .temporarilyUnavailable,
			description: nil,
			state: "some state"
		))
	}

	func test__error__minimalObject_fullError__returnsErrorResponse() throws {
		let request = AuthRequest(
			responseType: .code,
			clientID: "client id",
			state: nil,
			scope: Scope()
		)

		let error = request.error(
			code: .temporarilyUnavailable,
			description: "error description",
			url: "https://example.com/error"
		)

		XCTAssertEqual(error, ErrorResponse(
			code: .temporarilyUnavailable,
			description: "error description",
			url: "https://example.com/error",
			state: nil
		))
	}

	func test__error__fullObject_fullError__returnsErrorResponse() throws {
		let request = AuthRequest(
			responseType: .code,
			clientID: "client id",
			state: "some state",
			scope: "some scope"
		)

		let error = request.error(
			code: .temporarilyUnavailable,
			description: "error description",
			url: "https://example.com/error"
		)

		XCTAssertEqual(error, ErrorResponse(
			code: .temporarilyUnavailable,
			description: "error description",
			url: "https://example.com/error",
			state: "some state"
		))
	}
}

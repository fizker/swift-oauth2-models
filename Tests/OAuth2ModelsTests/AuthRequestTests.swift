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
					clientID: "client",
					redirectURL: URL(string: "https://example.com")!,
					state: "some state",
					scope: "some scope"
				),
				AuthRequest(
					clientID: "client",
					redirectURL: URL(string: "https://example.com")!,
					state: "some state",
					scope: "some scope"
				),
				true
			),
			(
				AuthRequest(
					clientID: "client",
					redirectURL: URL(string: "https://example.com")!,
					state: "some state",
					scope: "some scope"
				),
				AuthRequest(
					clientID: "client2",
					redirectURL: URL(string: "https://example.com")!,
					state: "some state",
					scope: "some scope"
				),
				false
			),
			(
				AuthRequest(
					clientID: "client",
					redirectURL: URL(string: "https://example.com")!,
					state: "some state",
					scope: "some scope"
				),
				AuthRequest(
					clientID: "client",
					state: "some state",
					scope: "some scope"
				),
				false
			),
			(
				AuthRequest(
					clientID: "client",
					redirectURL: URL(string: "https://example.com")!,
					state: "some state",
					scope: "some scope"
				),
				AuthRequest(
					clientID: "client",
					redirectURL: URL(string: "https://example.com/foo")!,
					state: "some state",
					scope: "some scope"
				),
				false
			),
			(
				AuthRequest(
					clientID: "client",
					redirectURL: URL(string: "https://example.com")!,
					state: "some state",
					scope: "some scope"
				),
				AuthRequest(
					clientID: "client",
					redirectURL: URL(string: "https://foo.com")!,
					state: "some state",
					scope: "some scope"
				),
				false
			),
			(
				AuthRequest(
					clientID: "client",
					redirectURL: URL(string: "https://example.com")!,
					state: "some state",
					scope: "some scope"
				),
				AuthRequest(
					clientID: "client",
					redirectURL: URL(string: "https://example.com")!,
					state: "some other state",
					scope: "some scope"
				),
				false
			),
			(
				AuthRequest(
					clientID: "client",
					redirectURL: URL(string: "https://example.com")!,
					state: "some state",
					scope: "some scope"
				),
				AuthRequest(
					clientID: "client",
					redirectURL: URL(string: "https://example.com")!,
					state: nil,
					scope: "some scope"
				),
				false
			),
			(
				AuthRequest(
					clientID: "client",
					redirectURL: URL(string: "https://example.com")!,
					state: "some state",
					scope: "some scope"
				),
				AuthRequest(
					clientID: "client",
					redirectURL: URL(string: "https://example.com")!,
					state: "some state",
					scope: "some other scope"
				),
				false
			),
			(
				AuthRequest(
					clientID: "client",
					redirectURL: URL(string: "https://example.com")!,
					state: "some state",
					scope: "some scope"
				),
				AuthRequest(
					clientID: "client",
					redirectURL: URL(string: "https://example.com")!,
					state: "some state",
					scope: nil
				),
				false
			),
		]

		for (lhs, rhs, expected) in tests {
			XCTAssertEqual(lhs == rhs, expected, "\(lhs) == \(rhs)")
			XCTAssertEqual(lhs == rhs, rhs == lhs, "order of operands")
		}
	}

	func test__decodable__minimumObject__decodesAsExpected() throws {
		json.removeValue(forKey: .redirectURL)
		json.removeValue(forKey: .scope)
		json.removeValue(forKey: .state)

		let data = try encode(json)
		let object = try decode(data) as AuthRequest

		XCTAssertEqual(object, AuthRequest(
			responseType: .code,
			clientID: "client",
			state: nil,
			scope: nil
		))
	}

	func test__decodable__fullObject__decodesAsExpected() throws {
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

	func test__encodable__fullObject__encodesAsJSON() throws {
		let object = AuthRequest(
			clientID: "client",
			redirectURL: URL(string: "https://example.com")!,
			state: "some state",
			scope: "some scope"
		)
		let data = try encode(object)
		let actual = try decode(data) as [String: String]

		let expected: [String: String] = [
			"client_id": "client",
			"response_type": "code",
			"redirect_uri": "https://example.com",
			"scope": "some scope",
			"state": "some state",
		]

		XCTAssertEqual(actual, expected)
	}

	func test__encodable__minimumObject__encodesAsJSON() throws {
		let object = AuthRequest(
			clientID: "client",
			state: nil,
			scope: nil
		)
		let data = try encode(object)
		let actual = try decode(data) as [String: String]

		let expected: [String: String] = [
			"client_id": "client",
			"response_type": "code",
		]

		XCTAssertEqual(actual, expected)
	}

	func test__response__minimalObject__returnsAuthResponse() throws {
		let request = AuthRequest(
			clientID: "client id",
			state: nil,
			scope: nil
		)

		let response = request.response(code: "response code")

		XCTAssertEqual(response, AuthResponse(code: "response code", state: nil))
	}

	func test__response__fullObject__returnsAuthResponse() throws {
		let request = AuthRequest(
			clientID: "client id",
			redirectURL: URL(string: "https://example.com")!,
			state: "some state",
			scope: "some scope"
		)

		let response = request.response(code: "response code")

		XCTAssertEqual(response, AuthResponse(code: "response code", state: "some state"))
	}

	func test__error__minimalObject_minimalError__returnsAuthError() throws {
		let request = AuthRequest(
			clientID: "client id",
			state: nil,
			scope: nil
		)

		let error = request.error(
			code: .temporarilyUnavailable,
			description: nil
		)

		XCTAssertEqual(error, AuthError(
			code: .temporarilyUnavailable,
			description: nil,
			state: nil
		))
	}

	func test__error__fullObject_minimalError__returnsAuthError() throws {
		let request = AuthRequest(
			clientID: "client id",
			redirectURL: URL(string: "https://example.com")!,
			state: "some state",
			scope: "some scope"
		)

		let error = request.error(
			code: .temporarilyUnavailable,
			description: nil
		)

		XCTAssertEqual(error, AuthError(
			code: .temporarilyUnavailable,
			description: nil,
			state: "some state"
		))
	}

	func test__error__minimalObject_fullError__returnsAuthError() throws {
		let request = AuthRequest(
			clientID: "client id",
			state: nil,
			scope: nil
		)

		let error = request.error(
			code: .temporarilyUnavailable,
			description: "error description",
			url: URL(string: "https://example.com/error")!
		)

		XCTAssertEqual(error, AuthError(
			code: .temporarilyUnavailable,
			description: "error description",
			url: URL(string: "https://example.com/error")!,
			state: nil
		))
	}

	func test__error__fullObject_fullError__returnsAuthError() throws {
		let request = AuthRequest(
			clientID: "client id",
			state: "some state",
			scope: "some scope"
		)

		let error = request.error(
			code: .temporarilyUnavailable,
			description: "error description",
			url: URL(string: "https://example.com/error")!
		)

		XCTAssertEqual(error, AuthError(
			code: .temporarilyUnavailable,
			description: "error description",
			url: URL(string: "https://example.com/error")!,
			state: "some state"
		))
	}
}

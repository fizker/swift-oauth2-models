import XCTest
import OAuth2Models

extension AuthError {
	init(code: ErrorCode, description: String?, state: String?) throws {
		let r = AuthRequest(clientID: "", state: state, scope: nil)
		self = try r.error(code: code, description: description)
	}

	init(code: ErrorCode, description: String?, url: URL, state: String?) throws {
		let r = AuthRequest(clientID: "", state: state, scope: nil)
		self = try r.error(code: code, description: description, url: url)
	}
}

final class AuthErrorTests: XCTestCase {
	typealias JSON = [AuthError.CodingKeys: String]
	var json: JSON = [:]
	var request = AuthRequest(clientID: "", state: nil, scope: nil)

	override func setUpWithError() throws {
		json = [
			.code: "server_error",
			.description: "some description",
			.url: "https://example.com",
			.state: "some state",
		]

		request = AuthRequest(clientID: "client id", state: nil, scope: nil)
	}

	func test__equalsOperator() throws {
		let tests = [
			(
				try AuthError(
					code: .accessDenied,
					request: AuthRequest(
						clientID: "clietn 1",
						redirectURL: URL(string: "https://example.com")!,
						state: "the state",
						scope: "some scope"
					),
					description: nil
				),
				try AuthError(
					code: .accessDenied,
					request: AuthRequest(
						clientID: "client 2",
						state: "the state",
						scope: nil
					),
					description: nil
				),
				true
			),
			(
				try AuthError(
					code: .accessDenied,
					request: AuthRequest(
						clientID: "clietn 1",
						redirectURL: URL(string: "https://example.com")!,
						state: "the state",
						scope: "some scope"
					),
					description: nil
				),
				try AuthError(
					code: .accessDenied,
					description: nil,
					state: "the state"
				),
				true
			),
			(
				try AuthError(
					code: .accessDenied,
					description: "foo",
					state: "bar"
				),
				try AuthError(
					code: .accessDenied,
					description: "foo",
					state: "bar"
				),
				true
			),
			(
				try AuthError(
					code: .accessDenied,
					description: "foo",
					url: URL(string: "https://example.com")!,
					state: "bar"
				),
				try AuthError(
					code: .accessDenied,
					description: "foo",
					url: URL(string: "http://example.com")!,
					state: "bar"
				),
				false
			),
			(
				try AuthError(
					code: .invalidScope,
					description: "foo",
					url: URL(string: "https://example.com")!,
					state: "bar"
				),
				try AuthError(
					code: .invalidScope,
					description: "foo",
					state: "bar"
				),
				false
			),
			(
				try AuthError(
					code: .invalidRequest,
					description: "foo",
					state: "bar"
				),
				try AuthError(
					code: .invalidRequest,
					description: "foo",
					state: nil
				),
				false
			),
			(
				try AuthError(
					code: .serverError,
					description: nil,
					state: nil
				),
				try AuthError(
					code: .serverError,
					description: nil,
					state: nil
				),
				true
			),
			(
				try AuthError(
					code: .accessDenied,
					description: "foo",
					state: nil
				),
				try AuthError(
					code: .accessDenied,
					description: nil,
					state: nil
				),
				false
			),
		]

		for (lhs, rhs, expected) in tests {
			XCTAssertEqual(lhs == rhs, expected, "\(lhs) == \(rhs)")
			XCTAssertEqual(lhs == rhs, rhs == lhs, "order of operands")
		}
	}

	func test__decodable__fullObject__decodesAsExpected() throws {
		let data = try encode(json)
		let object = try decode(data) as AuthError

		XCTAssertEqual(object, try AuthError(
			code: .serverError,
			description: "some description",
			url: URL(string: "https://example.com")!,
			state: "some state"
		))
	}

	func test__decodable__minimalObject__decodesAsExpected() throws {
		json.removeValue(forKey: .description)
		json.removeValue(forKey: .state)
		json.removeValue(forKey: .url)

		let data = try encode(json)
		let object = try decode(data) as AuthError

		XCTAssertEqual(object, try AuthError(
			code: .serverError,
			description: nil,
			state: nil
		))
	}

	func test__encodable__fullObject__encodesAsExpected() throws {
		request.state = "some state"
		let object = try AuthError(
			code: .accessDenied,
			request: request,
			description: "some description",
			url: URL(string: "https://example.com")!
		)
		let data = try encode(object)

		let actual = try decode(data) as [String: String]

		let expected = [
			"error": "access_denied",
			"error_description": "some description",
			"error_uri": "https://example.com",
			"state": "some state",
		]

		XCTAssertEqual(actual, expected)
	}

	func test__encodable__minimalObject__encodesAsExpected() throws {
		request.state = nil
		let object = try AuthError(
			code: .accessDenied,
			request: request,
			description: nil
		)
		let data = try encode(object)

		let actual = try decode(data) as [String: String]

		let expected = [
			"error": "access_denied",
		]

		XCTAssertEqual(actual, expected)
	}

	func test__init__invalidCharactersInDescription__throws() throws {
		XCTAssertThrowsError(try AuthError(code: .accessDenied, description: "å", state: nil)) { error in
			XCTAssertEqual(error as? AuthError.CharacterSetError, .invalidCharacterInDescription)
		}
	}
}

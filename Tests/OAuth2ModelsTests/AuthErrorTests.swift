import XCTest
import OAuth2Models

extension AuthError {
	init(error: ErrorCode, description: String?, state: String?) {
		let r = AuthRequest(clientID: "", state: state, scope: nil)
		self = r.error(error: error, description: description)
	}

	init(error: ErrorCode, description: String?, url: URL, state: String?) {
		let r = AuthRequest(clientID: "", state: state, scope: nil)
		self = r.error(error: error, description: description, url: url)
	}
}

final class AuthErrorTests: XCTestCase {
	typealias JSON = [AuthError.CodingKeys: String]
	var json: JSON = [:]
	var request = AuthRequest(clientID: "", state: nil, scope: nil)

	override func setUpWithError() throws {
		json = [
			.error: "server_error",
			.description: "some description",
			.url: "https://example.com",
			.state: "some state",
		]

		request = AuthRequest(clientID: "client id", state: nil, scope: nil)
	}

	func test__equalsOperator() throws {
		let tests = [
			(
				AuthError(
					error: .accessDenied,
					request: AuthRequest(
						clientID: "clietn 1",
						redirectURL: URL(string: "https://example.com")!,
						state: "the state",
						scope: "some scope"
					),
					description: nil
				),
				AuthError(
					error: .accessDenied,
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
				AuthError(
					error: .accessDenied,
					request: AuthRequest(
						clientID: "clietn 1",
						redirectURL: URL(string: "https://example.com")!,
						state: "the state",
						scope: "some scope"
					),
					description: nil
				),
				AuthError(
					error: .accessDenied,
					description: nil,
					state: "the state"
				),
				true
			),
			(
				AuthError(
					error: .accessDenied,
					description: "foo",
					state: "bar"
				),
				AuthError(
					error: .accessDenied,
					description: "foo",
					state: "bar"
				),
				true
			),
			(
				AuthError(
					error: .accessDenied,
					description: "foo",
					url: URL(string: "https://example.com")!,
					state: "bar"
				),
				AuthError(
					error: .accessDenied,
					description: "foo",
					url: URL(string: "http://example.com")!,
					state: "bar"
				),
				false
			),
			(
				AuthError(
					error: .invalidScope,
					description: "foo",
					url: URL(string: "https://example.com")!,
					state: "bar"
				),
				AuthError(
					error: .invalidScope,
					description: "foo",
					state: "bar"
				),
				false
			),
			(
				AuthError(
					error: .invalidRequest,
					description: "foo",
					state: "bar"
				),
				AuthError(
					error: .invalidRequest,
					description: "foo",
					state: nil
				),
				false
			),
			(
				AuthError(
					error: .serverError,
					description: nil,
					state: nil
				),
				AuthError(
					error: .serverError,
					description: nil,
					state: nil
				),
				true
			),
			(
				AuthError(
					error: .accessDenied,
					description: "foo",
					state: nil
				),
				AuthError(
					error: .accessDenied,
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

		XCTAssertEqual(object, AuthError(
			error: .serverError,
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

		XCTAssertEqual(object, AuthError(
			error: .serverError,
			description: nil,
			state: nil
		))
	}

	func test__encodable__fullObject__encodesAsExpected() throws {
		request.state = "some state"
		let object = AuthError(
			error: .accessDenied,
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
		let object = AuthError(
			error: .accessDenied,
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
}

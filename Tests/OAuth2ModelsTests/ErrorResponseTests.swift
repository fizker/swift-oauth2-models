import XCTest
import OAuth2Models

final class ErrorResponseTests: XCTestCase {
	typealias JSON = [ErrorResponse.CodingKeys: String]
	var json: JSON = [:]
	var request = AuthRequest(responseType: .code, clientID: "", state: nil)

	override func setUpWithError() throws {
		json = [
			.code: "server_error",
			.description: "some description",
			.url: "https://example.com",
			.state: "some state",
		]

		request = AuthRequest(responseType: .code, clientID: "client id", state: nil)
	}

	func test__equalsOperator() throws {
		let tests = [
			(
				ErrorResponse(
					code: .accessDenied,
					request: AuthRequest(
						responseType: .code,
						clientID: "clietn 1",
						redirectURL: URL(string: "https://example.com")!,
						state: "the state",
						scope: "some scope"
					),
					description: nil,
					url: nil
				),
				ErrorResponse(
					code: .accessDenied,
					request: AuthRequest(
						responseType: .code,
						clientID: "client 2",
						state: "the state",
						scope: Scope()
					),
					description: nil,
					url: nil
				),
				true
			),
			(
				ErrorResponse(
					code: .accessDenied,
					request: AuthRequest(
						responseType: .code,
						clientID: "clietn 1",
						redirectURL: URL(string: "https://example.com")!,
						state: "the state",
						scope: "some scope"
					),
					description: nil,
					url: nil
				),
				ErrorResponse(
					code: .accessDenied,
					description: nil,
					state: "the state"
				),
				true
			),
			(
				ErrorResponse(
					code: .accessDenied,
					description: "foo",
					state: "bar"
				),
				ErrorResponse(
					code: .accessDenied,
					description: "foo",
					state: "bar"
				),
				true
			),
			(
				ErrorResponse(
					code: .accessDenied,
					description: "foo",
					url: "https://example.com",
					state: "bar"
				),
				ErrorResponse(
					code: .accessDenied,
					description: "foo",
					url: "http://example.com",
					state: "bar"
				),
				false
			),
			(
				ErrorResponse(
					code: .invalidScope,
					description: "foo",
					url: "https://example.com",
					state: "bar"
				),
				ErrorResponse(
					code: .invalidScope,
					description: "foo",
					state: "bar"
				),
				false
			),
			(
				ErrorResponse(
					code: .invalidRequest,
					description: "foo",
					state: "bar"
				),
				ErrorResponse(
					code: .invalidRequest,
					description: "foo",
					state: nil
				),
				false
			),
			(
				ErrorResponse(
					code: .serverError,
					description: nil,
					state: nil
				),
				ErrorResponse(
					code: .serverError,
					description: nil,
					state: nil
				),
				true
			),
			(
				ErrorResponse(
					code: .accessDenied,
					description: "foo",
					state: nil
				),
				ErrorResponse(
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
		let object = try decode(data) as ErrorResponse

		XCTAssertEqual(object, ErrorResponse(
			code: .serverError,
			description: "some description",
			url: "https://example.com",
			state: "some state"
		))
	}

	func test__decodable__minimalObject__decodesAsExpected() throws {
		json.removeValue(forKey: .description)
		json.removeValue(forKey: .state)
		json.removeValue(forKey: .url)

		let data = try encode(json)
		let object = try decode(data) as ErrorResponse

		XCTAssertEqual(object, ErrorResponse(
			code: .serverError,
			description: nil,
			state: nil
		))
	}

	func test__encodable__fullObject__encodesAsExpected() throws {
		request.state = "some state"
		let object = ErrorResponse(
			code: .accessDenied,
			request: request,
			description: "some description",
			url: "https://example.com"
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
		let object = ErrorResponse(
			code: .accessDenied,
			request: request,
			description: nil,
			url: nil
		)
		let data = try encode(object)

		let actual = try decode(data) as [String: String]

		let expected = [
			"error": "access_denied",
		]

		XCTAssertEqual(actual, expected)
	}
}

import XCTest
import OAuth2Models

extension AuthResponse {
	init(code: String, state: String?) {
		let r = AuthRequest(clientID: "", state: state, scope: nil)
		self = r.response(code: code)
	}
}

final class AuthResponseTests: XCTestCase {
	typealias JSON = [AuthResponse.CodingKeys: String]
	var json: JSON = [:]
	var request = AuthRequest(clientID: "", state: nil, scope: nil)

	override func setUpWithError() throws {
		json = [
			.code: "some code",
			.state: "some state",
		]

		request = AuthRequest(clientID: "client id", state: nil, scope: nil)
	}

	func test__equalsOperator() throws {
		let tests = [
			(
				AuthResponse(
					code: "code",
					request: AuthRequest(
						clientID: "foo",
						state: "the state",
						scope: nil
					)
				),
				AuthResponse(
					code: "code",
					request: AuthRequest(
						clientID: "bar",
						redirectURL: URL(string: "https://example.com")!,
						state: "the state",
						scope: "some scope"
					)
				),
				true
			),
			(
				AuthResponse(code: "code", state: "state"),
				AuthResponse(code: "code", state: "state"),
				true
			),
			(
				AuthResponse(code: "code", state: nil),
				AuthResponse(code: "code", state: nil),
				true
			),
			(
				AuthResponse(code: "code", state: "state"),
				AuthResponse(code: "code2", state: "state"),
				false
			),
			(
				AuthResponse(code: "code", state: "state"),
				AuthResponse(code: "code", state: "state2"),
				false
			),
			(
				AuthResponse(code: "code", state: "state"),
				AuthResponse(code: "code", state: nil),
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
		let object = try decode(data) as AuthResponse

		XCTAssertEqual(object, AuthResponse(code: "some code", state: "some state"))
	}

	func test__decodable__minimalObject__decodesAsExpected() throws {
		json.removeValue(forKey: .state)
		let data = try encode(json)
		let object = try decode(data) as AuthResponse

		XCTAssertEqual(object, AuthResponse(code: "some code", state: nil))
	}

	func test__encodable__minimalObject__encodesAsExpected() throws {
		request.state = nil
		let object = AuthResponse(code: "some code", request: request)
		let data = try encode(object)
		let actual = try decode(data) as [String: String]

		let expected = [
			"code": "some code",
		]

		XCTAssertEqual(actual, expected)
	}

	func test__encodable__fullObject__encodesAsExpected() throws {
		request.state = "some state"
		let object = AuthResponse(code: "some code", request: request)
		let data = try encode(object)
		let actual = try decode(data) as [String: String]

		let expected = [
			"code": "some code",
			"state": "some state",
		]

		XCTAssertEqual(actual, expected)
	}
}

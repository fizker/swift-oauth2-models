import XCTest
import OAuth2Models

final class AuthCodeAuthResponseTests: XCTestCase {
	typealias JSON = [AuthCodeAuthResponse.CodingKeys: String]
	var json: JSON = [:]
	var request = AuthRequest(responseType: .code, clientID: "", state: nil)

	override func setUpWithError() throws {
		json = [
			.code: "some code",
			.state: "some state",
		]

		request = AuthRequest(responseType: .code, clientID: "client id", state: nil)
	}

	func test__equalsOperator() throws {
		let tests = [
			(
				AuthCodeAuthResponse(
					code: "code",
					request: AuthRequest(
						responseType: .code,
						clientID: "foo",
						state: "the state",
						scope: Scope()
					)
				),
				AuthCodeAuthResponse(
					code: "code",
					request: AuthRequest(
						responseType: .code,
						clientID: "bar",
						redirectURL: URL(string: "https://example.com")!,
						state: "the state",
						scope: "some scope"
					)
				),
				true
			),
			(
				AuthCodeAuthResponse(code: "code", state: "state"),
				AuthCodeAuthResponse(code: "code", state: "state"),
				true
			),
			(
				AuthCodeAuthResponse(code: "code", state: nil),
				AuthCodeAuthResponse(code: "code", state: nil),
				true
			),
			(
				AuthCodeAuthResponse(code: "code", state: "state"),
				AuthCodeAuthResponse(code: "code2", state: "state"),
				false
			),
			(
				AuthCodeAuthResponse(code: "code", state: "state"),
				AuthCodeAuthResponse(code: "code", state: "state2"),
				false
			),
			(
				AuthCodeAuthResponse(code: "code", state: "state"),
				AuthCodeAuthResponse(code: "code", state: nil),
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
		let object = try decode(data) as AuthCodeAuthResponse

		XCTAssertEqual(object, AuthCodeAuthResponse(code: "some code", state: "some state"))
	}

	func test__decodable__minimalObject__decodesAsExpected() throws {
		json.removeValue(forKey: .state)
		let data = try encode(json)
		let object = try decode(data) as AuthCodeAuthResponse

		XCTAssertEqual(object, AuthCodeAuthResponse(code: "some code", state: nil))
	}

	func test__encodable__minimalObject__encodesAsExpected() throws {
		request.state = nil
		let object = AuthCodeAuthResponse(code: "some code", request: request)
		let data = try encode(object)
		let actual = try decode(data) as [String: String]

		let expected = [
			"code": "some code",
		]

		XCTAssertEqual(actual, expected)
	}

	func test__encodable__fullObject__encodesAsExpected() throws {
		request.state = "some state"
		let object = AuthCodeAuthResponse(code: "some code", request: request)
		let data = try encode(object)
		let actual = try decode(data) as [String: String]

		let expected = [
			"code": "some code",
			"state": "some state",
		]

		XCTAssertEqual(actual, expected)
	}
}

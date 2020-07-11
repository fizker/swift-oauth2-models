import XCTest
import OAuth2Models

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

	func test__decodable__fullObject__decodesAsExpected() throws {
		let data = try encode(json)
		let object = try decode(data) as AuthResponse

		XCTAssertEqual(object.code, "some code")
		XCTAssertEqual(object.state, "some state")
	}

	func test__decodable__minimalObject__decodesAsExpected() throws {
		json.removeValue(forKey: .state)
		let data = try encode(json)
		let object = try decode(data) as AuthResponse

		XCTAssertEqual(object.code, "some code")
		XCTAssertNil(object.state)
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

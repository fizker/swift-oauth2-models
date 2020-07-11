import XCTest
import OAuth2Models

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

	func test__decodable__fullObject__decodesAsExpected() throws {
		let data = try encode(json)
		let object = try decode(data) as AuthError

		XCTAssertEqual(object.error, .serverError)
		XCTAssertEqual(object.description, "some description")
		XCTAssertEqual(object.url, URL(string: "https://example.com")!)
		XCTAssertEqual(object.state, "some state")
	}

	func test__decodable__minimalObject__decodesAsExpected() throws {
		json.removeValue(forKey: .description)
		json.removeValue(forKey: .state)
		json.removeValue(forKey: .url)

		let data = try encode(json)
		let object = try decode(data) as AuthError

		XCTAssertEqual(object.error, .serverError)
		XCTAssertNil(object.description)
		XCTAssertNil(object.url)
		XCTAssertNil(object.state)
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

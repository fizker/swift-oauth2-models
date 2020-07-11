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

	func test__decodable__minimumObject__decodesAsExpected() throws {
		json.removeValue(forKey: .redirectURL)
		json.removeValue(forKey: .scope)
		json.removeValue(forKey: .state)

		let data = try encode(json)
		let object = try decode(data) as AuthRequest

		XCTAssertEqual(object.clientID, "client")
		XCTAssertEqual(object.responseType, .code)
		XCTAssertNil(object.redirectURL)
		XCTAssertNil(object.state)
		XCTAssertNil(object.scope)
	}

	func test__decodable__fullObject__decodesAsExpected() throws {
		let data = try encode(json)
		let object = try decode(data) as AuthRequest

		XCTAssertEqual(object.clientID, "client")
		XCTAssertEqual(object.responseType, .code)
		XCTAssertEqual(object.redirectURL, URL(string: "https://example.com")!)
		XCTAssertEqual(object.state, "some state")
		XCTAssertEqual(object.scope, "some scope")
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

		XCTAssertEqual(response.code, "response code")
		XCTAssertNil(response.state)
	}

	func test__response__fullObject__returnsAuthResponse() throws {
		let request = AuthRequest(
			clientID: "client id",
			redirectURL: URL(string: "https://example.com")!,
			state: "some state",
			scope: "some scope"
		)

		let response = request.response(code: "response code")

		XCTAssertEqual(response.code, "response code")
		XCTAssertEqual(response.state, "some state")
	}

	func test__error__minimalObject_minimalError__returnsAuthError() throws {
		let request = AuthRequest(
			clientID: "client id",
			state: nil,
			scope: nil
		)

		let error = request.error(
			error: .temporarilyUnavailable,
			description: nil
		)

		XCTAssertEqual(error.error, .temporarilyUnavailable)
		XCTAssertNil(error.description)
		XCTAssertNil(error.url)
		XCTAssertNil(error.state)
	}

	func test__error__fullObject_minimalError__returnsAuthError() throws {
		let request = AuthRequest(
			clientID: "client id",
			redirectURL: URL(string: "https://example.com")!,
			state: "some state",
			scope: "some scope"
		)

		let error = request.error(
			error: .temporarilyUnavailable,
			description: nil
		)

		XCTAssertEqual(error.error, .temporarilyUnavailable)
		XCTAssertNil(error.description)
		XCTAssertNil(error.url)
		XCTAssertEqual(error.state, "some state")
	}

	func test__error__minimalObject_fullError__returnsAuthError() throws {
		let request = AuthRequest(
			clientID: "client id",
			state: nil,
			scope: nil
		)

		let error = request.error(
			error: .temporarilyUnavailable,
			description: "error description",
			url: URL(string: "https://eaxmple.com/error")!
		)

		XCTAssertEqual(error.error, .temporarilyUnavailable)
		XCTAssertEqual(error.description, "error description")
		XCTAssertEqual(error.url, URL(string: "https://eaxmple.com/error")!)
		XCTAssertNil(error.state)
	}

	func test__error__fullObject_fullError__returnsAuthError() throws {
		let request = AuthRequest(
			clientID: "client id",
			state: "some state",
			scope: "some scope"
		)

		let error = request.error(
			error: .temporarilyUnavailable,
			description: "error description",
			url: URL(string: "https://eaxmple.com/error")!
		)

		XCTAssertEqual(error.error, .temporarilyUnavailable)
		XCTAssertEqual(error.description, "error description")
		XCTAssertEqual(error.url, URL(string: "https://eaxmple.com/error")!)
		XCTAssertEqual(error.state, "some state")
	}
}

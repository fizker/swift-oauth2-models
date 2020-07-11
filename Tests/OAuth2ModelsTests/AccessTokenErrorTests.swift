import XCTest
import OAuth2Models

final class AccessTokenErrorTests: XCTestCase {
	typealias JSON = [AccessTokenError.CodingKeys: String]
	var json: JSON = [:]

	override func setUpWithError() throws {
		json = [
			.error: "invalid_request",
			.description: "Some description",
			.url: "https://example.com",
		]
	}

	func test__decodable__fullObject__decodesAsExpected() throws {
		let data = try encode(json)
		let object = try decode(data) as AccessTokenError

		XCTAssertEqual(object.error, .invalidRequest)
		XCTAssertEqual(object.description, "Some description")
		XCTAssertEqual(object.url, URL(string: "https://example.com")!)
	}

	func test__decodable__minimumObject__decodesAsExpected() throws {
		json.removeValue(forKey: .description)
		json.removeValue(forKey: .url)
		let data = try encode(json)
		let object = try decode(data) as AccessTokenError

		XCTAssertEqual(object.error, .invalidRequest)
		XCTAssertNil(object.description)
		XCTAssertNil(object.url)
	}

	func test__decodable__noErrorCode__throws() throws {
		json.removeValue(forKey: .error)
		let data = try encode(json)
		XCTAssertThrowsError(try decode(data) as AccessTokenError)
	}

	func test__encodable__minimumObject__returnsExpectedJSON() throws {
		let object = AccessTokenError(error: .invalidRequest, description: nil, url: nil)
		let data = try encode(object)

		XCTAssertEqual(
			String(data: data, encoding: .utf8),
			#"{"error":"invalid_request"}"#
		)
	}

	func test__encodable__fullObject__returnsExpectedJSON() throws {
		let object = AccessTokenError(error: .invalidRequest, description: "Some description", url: URL(string: "https://example.com/foo"))
		let data = try encode(object)

		XCTAssertEqual(
			String(data: data, encoding: .utf8),
			#"{"error":"invalid_request","error_description":"Some description","error_uri":"https:\/\/example.com\/foo"}"#
		)
	}
}

import XCTest
import OAuth2Models

final class AccessTokenRequestTests: XCTestCase {
	var json: [AccessTokenRequest.CodingKeys: String] = [:]

	override func setUpWithError() throws {
		json = [
			.grantType: "authorization_code",
			.code: "abc",
			.redirectURL: "https://example.com/a",
			.clientID: "def",
		]
	}

	func test__setUp__noChanges__decodesCorrectly() throws {
		let data = try encodeData()
		XCTAssertNoThrow(try decode(data))
	}

	func test__decodable__missingRedirectURI__returnsDecodedObject() throws {
		json.removeValue(forKey: .redirectURL)
		let data = try encodeData()
		let request = try decode(data)

		XCTAssertNil(request.redirectURL)
	}

	func test__decodable__invalidGrantType__throws() throws {
		json[.grantType] = "foo"
		let data = try encodeData()

		XCTAssertThrowsError(try decode(data))
	}

	func test__decodable__invalidRedirectURL__throws() throws {
		throw XCTSkip("Should throw if URL is invalid. It currently simply decodes to nil")

		json[.redirectURL] = "invalid"
		let data = try encode(json)

		XCTAssertThrowsError(try decode(data))
	}

	private func decode(_ data: Data) throws -> AccessTokenRequest {
		return try OAuth2ModelsTests.decode(data)
	}

	private func encodeData() throws -> Data {
		return try encode(json)
	}
}

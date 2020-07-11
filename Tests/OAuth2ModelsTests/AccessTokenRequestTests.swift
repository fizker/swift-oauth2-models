import XCTest
import OAuth2Models

final class AccessTokenRequestTests: XCTestCase {
	var json: [AccessTokenRequest.CodingKeys: String] = [:]

	override func setUpWithError() throws {
		json = [
			.grantType: "authorization_code",
			.code: "abc",
			.redirectURI: "https://example.com/a",
			.clientID: "def",
		]
	}

	func test__setUp__noChanges__decodesCorrectly() throws {
		let data = try encodeData()
		XCTAssertNoThrow(try decode(data))
	}

	func test__decodable__missingRedirectURI__returnsDecodedObject() throws {
		json.removeValue(forKey: .redirectURI)
		let data = try encodeData()
		let request = try decode(data)

		XCTAssertNil(request.redirectURI)
	}

	func test__decodable__invalidGrantType__throws() throws {
		json[.grantType] = "foo"
		let data = try encodeData()

		XCTAssertThrowsError(try decode(data))
	}

	private func decode(_ data: Data) throws -> AccessTokenRequest {
		return try OAuth2ModelsTests.decode(data)
	}

	private func encodeData() throws -> Data {
		return try encode(json)
	}
}

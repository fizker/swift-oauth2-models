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

	func test__decodable__missingGrantType__throws() throws {
		json.removeValue(forKey: .grantType)
		let data = try encodeData()

		XCTAssertThrowsError(try decode(data))
	}

	func test__decodable__missingCode__throws() throws {
		json.removeValue(forKey: .code)
		let data = try encodeData()

		XCTAssertThrowsError(try decode(data))
	}

	func test__decodable__missingClientID__returnsDecodedObject() throws {
		json.removeValue(forKey: .clientID)
		let data = try encodeData()

		let request = try decode(data)

		XCTAssertNil(request.clientID)
	}

	func test__decodable__invalidGrantType__throws() throws {
		json[.grantType] = "foo"
		let data = try encodeData()

		XCTAssertThrowsError(try decode(data))
	}

	private func decode(_ data: Data) throws -> AccessTokenRequest {
		let decoder = JSONDecoder()
		return try decoder.decode(AccessTokenRequest.self, from: data)
	}

	private func encodeData() throws -> Data {
		var codableData = [String:String]()
		for (k, v) in json {
			codableData[k.rawValue] = v
		}
		let encoder = JSONEncoder()
		let json = try encoder.encode(codableData)
		return json
	}
}

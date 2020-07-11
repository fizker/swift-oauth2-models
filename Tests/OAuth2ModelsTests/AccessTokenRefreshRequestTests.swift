import XCTest
import OAuth2Models

final class AccessTokenRefreshRequestTests: XCTestCase {
	var json: [AccessTokenRefreshRequest.CodingKeys: String] = [:]

	override func setUpWithError() throws {
		json = [
			.grantType: "refresh_token",
			.refreshToken: "foo",
			.scope: "bar",
		]
	}

	func test__setUp__noChanges__decodesCorrectly() throws {
		let data = try encodeData()
		XCTAssertNoThrow(try decode(data))
	}

	func test__decodable__missingScope__returnsDecodedObject() throws {
		json.removeValue(forKey: .scope)
		let data = try encodeData()
		let request = try decode(data)

		XCTAssertNil(request.scope)
	}

	func test__decodable__invalidGrantType__throws() throws {
		json[.grantType] = "foo"
		let data = try encodeData()

		XCTAssertThrowsError(try decode(data))
	}

	func test__decodable__missingGrantType__throws() throws {
		json.removeValue(forKey: .grantType)
		let data = try encodeData()

		XCTAssertThrowsError(try decode(data))
	}

	func test__decodable__missingRefreshToken__throws() throws {
		json.removeValue(forKey: .refreshToken)
		let data = try encodeData()

		XCTAssertThrowsError(try decode(data))
	}

	private func decode(_ data: Data) throws -> AccessTokenRefreshRequest {
		let decoder = JSONDecoder()
		return try decoder.decode(AccessTokenRefreshRequest.self, from: data)
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

import XCTest
import OAuth2Models

class PasswordAccessTokenRequestTests: XCTestCase {
	var json: [PasswordAccessTokenRequest.CodingKeys: String] = [:]

	override func setUpWithError() throws {
		json = [
			.grantType: "password",
			.username: "abc",
			.password: "def",
			.scope: "ghi jkl",
		]
	}

	func test__setUp__noChanges__decodesCorrectly() throws {
		let data = try encode(json)
		XCTAssertNoThrow(try decode(data) as PasswordAccessTokenRequest)
	}

	func test__decodable__emptyScope__decodesCorrectly() throws {
		let json = """
		{
			"grant_type": "password",
			"username": "abc",
			"password": "def",
			"scope": ""
		}
		"""
		let data = json.data(using: .utf8)!
		let request = try decode(data) as PasswordAccessTokenRequest

		XCTAssertTrue(request.scope.isEmpty)
	}

	func test__decodable__nullScope__decodesCorrectly() throws {
		let json = """
		{
			"grant_type": "password",
			"username": "abc",
			"password": "def",
			"scope": null
		}
		"""
		let data = json.data(using: .utf8)!
		let request = try decode(data) as PasswordAccessTokenRequest

		XCTAssertTrue(request.scope.isEmpty)
	}

	func test__decodable__missingScope__decodesCorrectly() throws {
		let json = """
		{
			"grant_type": "password",
			"username": "abc",
			"password": "def"
		}
		"""
		let data = json.data(using: .utf8)!
		let request = try decode(data) as PasswordAccessTokenRequest

		XCTAssertTrue(request.scope.isEmpty)
	}

	func test__decodable__missingPassword__throws() throws {
		json.removeValue(forKey: .password)
		let data = try encode(json)
		XCTAssertThrowsError(try decode(data) as PasswordAccessTokenRequest)
	}

	func test__decodable__missingUsername__throws() throws {
		json.removeValue(forKey: .username)
		let data = try encode(json)
		XCTAssertThrowsError(try decode(data) as PasswordAccessTokenRequest)
	}

	func test__encodable__noScope__encodesWithoutScope() throws {
		let value = PasswordAccessTokenRequest(username: "abc", password: "def")
		let data = try encode(value)
		let actual = try decode(data) as [String:String]

		let expected = [
			"grant_type": "password",
			"username": "abc",
			"password": "def",
		]

		XCTAssertEqual(actual, expected)
	}

	func test__encodable__scopeWithMultipleValues__encodesAsExpected() throws {
		let value = PasswordAccessTokenRequest(username: "abc", password: "def", scope: try Scope(items: ["foo", "bar"]))
		let data = try encode(value)
		var actual = try decode(data) as [String:String]

		let expected = [
			"grant_type": "password",
			"username": "abc",
			"password": "def",
			"scope": "foo bar",
		]

		// Scope is unsorted, so we need to convert to an unsorted storage
		XCTAssertEqual(["bar", "foo"], try Scope(string: actual["scope"] ?? ""))
		actual.removeValue(forKey: "scope")

		XCTAssertEqual(actual, expected)
	}
}

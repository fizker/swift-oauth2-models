import XCTest
@testable import OAuth2Models

final class OAuth2ModelsTests: XCTestCase {
	func testExample() {
		// This is an example of a functional test case.
		// Use XCTAssert and related functions to verify your tests produce the correct
		// results.
		XCTAssertEqual(OAuth2Models().text, "Hello, World!")
	}

	static var allTests = [
		("testExample", testExample),
	]
}

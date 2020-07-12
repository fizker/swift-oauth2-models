import XCTest
import OAuth2Models

extension ErrorDescription: ExpressibleByStringLiteral {
	public init(stringLiteral value: StringLiteralType) {
		try! self.init(value)
	}
}
extension ErrorURL: ExpressibleByStringLiteral {
	public init(stringLiteral value: StringLiteralType) {
		let url = URL(string: value)!
		try! self.init(url)
	}
}

final class CharSetValidationTests: XCTestCase {
	func test__ErrorDescription_init__invalidCharacters__throws() throws {
		XCTAssertThrowsError(try ErrorDescription.init("aæbcådeøf")) { error in
			if case let CharacterSetValidationError.containsInvalidCharacters(characters) = error {
				XCTAssertEqual(characters, "æåø")
			} else {
				XCTFail("Failed with invalid error: \(error)")
			}
		}
	}
}

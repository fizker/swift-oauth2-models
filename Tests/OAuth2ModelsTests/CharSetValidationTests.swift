import XCTest
import OAuth2Models

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

	func test__ErrorDescription_init__emptyString__throws() throws {
		XCTAssertThrowsError(try ErrorDescription.init("")) { error in
			if case CharacterSetValidationError.emptyValue = error {
			} else {
				XCTFail("Failed with invalid error: \(error)")
			}
		}
	}
}

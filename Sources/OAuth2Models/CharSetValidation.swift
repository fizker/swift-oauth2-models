import Foundation

private let validTextCharacters = CharacterSet(charactersIn: Unicode.Scalar(0x20)...Unicode.Scalar(0x7e))
	.subtracting(CharacterSet(arrayLiteral: Unicode.Scalar(0x22), Unicode.Scalar(0x5c)))
private let validURLCharacters = validTextCharacters.subtracting(CharacterSet(arrayLiteral: Unicode.Scalar(0x20)))

enum ValidCharacterSet {
	case url
	case text

	var characterSet: CharacterSet {
		switch self {
		case .url: return validURLCharacters
		case .text: return validTextCharacters
		}
	}
}

func assert(_ value: String, matchesOnly charset: ValidCharacterSet) throws {
	let invalidCharacters = value.unicodeScalars.filter(charset.characterSet.inverted.contains)
	guard invalidCharacters.isEmpty
	else { throw CharacterSetValidationError.containsInvalidCharacters(String(invalidCharacters)) }
}

/// Error thrown when a string includes invalid characters.
public enum CharacterSetValidationError: Swift.Error {
	/// Error thrown when a string includes invalid characters. The associated value is the characters that were invalid.
	case containsInvalidCharacters(String)
}

/// Wraps the description field of the error models and ensures that it contains only the characters that the spec allows.
public struct ErrorDescription {
	let value: String

	/// Initializes the wrapper.
	/// - Parameter string: The value to wrap
	/// - Throws: `CharacterSetValidationError.containsInvalidCharacters(_)` if any characters were invalid.
	///
	public init(_ string: String) throws {
		self.value = string

		try assert(string, matchesOnly: .text)
	}
}

/// Wraps the URL field of the error models and ensures that it contains only the characters that the spec allows.
public struct ErrorURL {
	let value: URL

	/// Initializes the wrapper.
	/// - Parameter url: The value to wrap
	/// - Throws: `CharacterSetValidationError.containsInvalidCharacters(_)` if any characters were invalid.
	///
	public init(_ url: URL) throws {
		self.value = url

		try assert(url.absoluteString, matchesOnly: .url)
	}
}

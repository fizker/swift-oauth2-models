import Foundation

private let validCharactersIncludingSpace = CharacterSet(charactersIn: Unicode.Scalar(0x20)...Unicode.Scalar(0x7e))
	.subtracting(CharacterSet(arrayLiteral: Unicode.Scalar(0x22), Unicode.Scalar(0x5c)))
private let validCharactersExcludingSpace = validCharactersIncludingSpace.subtracting(CharacterSet(arrayLiteral: Unicode.Scalar(0x20)))

enum ValidCharacterSet {
	case includingSpace
	case excludingSpace

	var characterSet: CharacterSet {
		switch self {
		case .excludingSpace: return validCharactersExcludingSpace
		case .includingSpace: return validCharactersIncludingSpace
		}
	}

	func isValid(_ str: String) -> Bool {
		str.unicodeScalars.allSatisfy(characterSet.contains(_:))
	}
}

func assert(_ value: String, charset: ValidCharacterSet) throws {
	if value.isEmpty {
		throw CharacterSetValidationError.emptyValue
	}

	let invalidCharacters = value.unicodeScalars.filter(charset.characterSet.inverted.contains)
	guard invalidCharacters.isEmpty
	else { throw CharacterSetValidationError.containsInvalidCharacters(String(invalidCharacters)) }
}

/// Error thrown when a string includes invalid characters.
public enum CharacterSetValidationError: Swift.Error {
	/// Error thrown when a string includes invalid characters. The associated value is the characters that were invalid.
	case containsInvalidCharacters(String)

	/// Error thrown when a string is empty.
	case emptyValue
}

/// Wraps the description field of the error models and ensures that it contains only the characters that the spec allows.
public struct ErrorDescription: Sendable {
	/// The value.
	public let value: String

	/// Initializes the wrapper.
	/// - Parameter string: The value to wrap
	/// - Throws: ``CharacterSetValidationError/containsInvalidCharacters(_:)`` if any characters were invalid.
	public init(_ string: String) throws {
		self.value = string

		try assert(string, charset: .includingSpace)
	}
}

extension ErrorDescription: ExpressibleByStringInterpolation {
	/// Initializes the wrapper from a `String` literal. This invokes the throwing ``init(_:)`` with `try!`, which crashes at runtime.
	public init(stringLiteral value: String) {
		try! self.init(value)
	}
}

/// Wraps the URL field of the error models and ensures that it contains only the characters that the spec allows.
public struct ErrorURL: Sendable {
	/// The value.
	public let value: URL

	/// Initializes the wrapper.
	/// - Parameter url: The value to wrap
	/// - Throws: ``CharacterSetValidationError/containsInvalidCharacters(_:)`` if any characters were invalid.
	public init(_ url: URL) throws {
		self.value = url

		try assert(url.absoluteString, charset: .excludingSpace)
	}
}

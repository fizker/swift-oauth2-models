import Foundation

private let validTextCharacters = CharacterSet(charactersIn: Unicode.Scalar(0x20)...Unicode.Scalar(0x7e))
	.subtracting(CharacterSet(arrayLiteral: Unicode.Scalar(0x22), Unicode.Scalar(0x5c)))
private let validURLCharacters = validTextCharacters.subtracting(CharacterSet(arrayLiteral: Unicode.Scalar(0x20)))

enum ValidCharacterSet {
	case url
	case text

	var validCharacters: CharacterSet {
		switch self {
		case .url: return validURLCharacters
		case .text: return validTextCharacters
		}
	}

	func isValid(_ string: String) -> Bool {
		isValid(string.unicodeScalars)
	}
	func isValid<T: Sequence>(_ scalars: T) -> Bool where T.Element == Unicode.Scalar {
		scalars.allSatisfy(validCharacters.contains)
	}
}

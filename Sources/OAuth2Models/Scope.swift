/// Represents a list of scopes. The items are distinct.
public struct Scope {
	private(set) var items: Set<String>

	/// Returns an empty Scope. This is equivalent to calling ``init()``.
	public static var empty: Scope { .init() }

	/// Creates an empty scope.
	public init() {
		items = []
	}

	private static func splitStringInput(_ string: String) -> Set<String> {
		let values = string.split(separator: " ").map(String.init)
		return Set(values)
	}
	fileprivate init(unvalidatedString: String) {
		items = Self.splitStringInput(unvalidatedString)
	}

	/// Parses and creates a scope from a string.
	///
	/// The input string is split on white-space, so that `"foo bar baz"` becomes the scopes `["foo", "bar", "baz"]`.
	///
	/// The resulting list is distinct, so that `"foo bar foo"` becomes the scopes `["foo", "bar"]`.
	/// - throws: If the string is empty, ``CharacterSetValidationError/emptyValue`` is thrown. If the string contains any invalid characters, ``CharacterSetValidationError/containsInvalidCharacters(_:)`` is thrown with the violating characters.
	public init(string: String) throws {
		if string.isEmpty {
			throw CharacterSetValidationError.emptyValue
		}

		let items = Self.splitStringInput(string)
		try self.init(items: items)
	}

	/// Creates a Scope list from the given `Sequence`.
	/// - throws: If the string is empty, ``CharacterSetValidationError/emptyValue`` is thrown. If the string contains any invalid characters, ``CharacterSetValidationError/containsInvalidCharacters(_:)`` is thrown with the violating characters.
	public init<T: Sequence>(items: T) throws where T.Element == String {
		try self.init(items: Set(items))
	}

	/// Creates a Scope list from the given `Set`.
	/// - throws: If the string is empty, ``CharacterSetValidationError/emptyValue`` is thrown. If the string contains any invalid characters, ``CharacterSetValidationError/containsInvalidCharacters(_:)`` is thrown with the violating characters.
	public init(items: Set<String>) throws {
		for item in items {
			try Self.assert(item)
		}

		self.items = items
	}

	fileprivate static func assert(_ item: String) throws { try OAuth2Models.assert(item, charset: Self.validCharacters) }
	fileprivate static let validCharacters = ValidCharacterSet.excludingSpace

	/// Checks that all the items are valid.
	/// - returns: True if all items are valid, otherwise false.
	public var isValid: Bool { items.allSatisfy(Self.validCharacters.isValid(_:)) }
}

public extension Scope {
	/// Returns a Boolean value that indicates whether the given element exists in the set.
	///
	/// Complexity: O(1)
	///
	/// - parameter member: An element to look for in the set.
	/// - returns: `true` if member exists in the set; otherwise, `false`.
	func contains(_ member: String) -> Bool { items.contains(member) }

	/// Inserts the given element in the set if it is not already present.
	///
	/// - parameter newMember: An element to insert into the set.
	/// - returns: `(true, newMember)` if `newMember` was not contained in the set. If an element equal to `newMember` was already contained in the set, the method returns `(false, oldMember)`.
	mutating func insert(_ newMember: String) throws -> (Bool, String) {
		try Self.assert(newMember)
		return items.insert(newMember)
	}
}
extension Scope: Sequence {
	public typealias Iterator = Set<String>.Iterator
	public typealias Element = String
	public func makeIterator() -> Iterator { items.makeIterator() }
}
extension Scope: Collection {
	public typealias Index = Set<String>.Index
	public typealias Indices = Set<String>.Indices
	public typealias SubSequence = Set<String>.SubSequence

	public var count: Int { items.count }
	public var startIndex: Set<String>.Index { items.startIndex }
	public var endIndex: Index { items.endIndex }
	public var indices: Indices { items.indices }
	public var isEmpty: Bool { items.isEmpty }

	public subscript(bounds: Range<Index>) -> SubSequence { items[bounds] }
	public subscript(position: Set<String>.Index) -> String { items[position] }

	public func index(after i: Set<String>.Index) -> Set<String>.Index { items.index(after: i) }
}
extension Scope: Equatable {
	public static func ==<T: Collection>(lhs: T, rhs: Scope) -> Bool where T.Element == String {
		rhs == lhs
	}
	public static func ==<T: Collection>(lhs: Scope, rhs: T) -> Bool where T.Element == String {
		guard lhs.count == rhs.count
		else { return false }

		return rhs.allSatisfy(lhs.contains(_:))
	}
}
extension Scope: Codable {
	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		if isEmpty {
			try container.encodeNil()
		} else {
			try container.encode(items.joined(separator: " "))
		}
	}

	public init(from decoder: Decoder) throws {
		if var container = try? decoder.unkeyedContainer() {
			var values: [String] = []
			while !container.isAtEnd {
				values.append(try container.decode(String.self))
			}
			self.init(unvalidatedString: values.joined(separator: " "))
		} else {
			let container = try decoder.singleValueContainer()

			if container.decodeNil() {
				self.init()
			} else {
				let string = try container.decode(String.self)
				self.init(unvalidatedString: string)
			}
		}
	}
}

extension Scope: ExpressibleByStringLiteral {
	/// Initializes the wrapper from a `String` literal. This invokes the throwing ``init(string:)`` with `try!`, which crashes at runtime.
	public init(stringLiteral value: StringLiteralType) {
		try! self.init(string: value)
	}
}
extension Scope: ExpressibleByArrayLiteral {
	/// Initializes the wrapper from a `String...` literal. This invokes the throwing ``init(items:)`` with `try!`, which crashes at runtime.
	public init(arrayLiteral elements: String...) {
		try! self.init(items: elements)
	}
}

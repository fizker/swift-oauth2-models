public struct Scope {
	private(set) var items: Set<String>

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

	public init(string: String) throws {
		let items = Self.splitStringInput(string)
		try self.init(items: items)
	}

	public init<T: Sequence>(items: T) throws where T.Element == String {
		try self.init(items: Set(items))
	}
	public init(items: Set<String>) throws {
		for item in items {
			try Self.assert(item)
		}

		self.items = items
	}

	fileprivate static func assert(_ item: String) throws { try OAuth2Models.assert(item, charset: Self.validCharacters) }
	fileprivate static let validCharacters = ValidCharacterSet.excludingSpace

	public var isValid: Bool { items.allSatisfy(Self.validCharacters.isValid(_:)) }
}

public extension Scope {
	func contains(_ value: String) -> Bool { items.contains(value) }
	mutating func insert(_ newElement: String) throws -> (Bool, String) {
		try Self.assert(newElement)
		return items.insert(newElement)
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

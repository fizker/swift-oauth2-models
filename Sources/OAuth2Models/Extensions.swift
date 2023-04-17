import Foundation

/// Convenience `Codable` support for `Result` when `Success` is `Codable` (such as any
/// responses or requests) and the error is `Codable` (such as `ErrorResponse`).
extension Result: Decodable where Success: Decodable, Failure: Decodable {
	public init(from decoder: Decoder) throws {
		do {
			self = .success(try Success(from: decoder))
		} catch {
			self = .failure(try Failure(from: decoder))
		}
	}
}
extension Result: Encodable where Success: Encodable, Failure: Encodable {
	public func encode(to encoder: Encoder) throws {
		switch self {
		case let .success(value):
			try value.encode(to: encoder)
		case let .failure(error):
			try error.encode(to: encoder)
		}
	}
}

/// Convenience decoders for when the type to decode can be easily inferred.
extension KeyedDecodingContainer {
	func decode<T: Decodable>(forKey key: Key) throws -> T {
		return try decode(T.self, forKey: key)
	}
	func decodeIfPresent<T: Decodable>(forKey key: Key) throws -> T? {
		return try decodeIfPresent(T.self, forKey: key)
	}
}

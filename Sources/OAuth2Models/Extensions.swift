import Foundation

/// Convenience decoders for when the type to decode can be easily inferred.
extension KeyedDecodingContainer {
	func decode<T: Decodable>(forKey key: Key) throws -> T {
		return try decode(T.self, forKey: key)
	}
	func decodeIfPresent<T: Decodable>(forKey key: Key) throws -> T? {
		return try decodeIfPresent(T.self, forKey: key)
	}
}

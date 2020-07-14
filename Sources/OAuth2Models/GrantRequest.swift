import Foundation

/// Convenience Decodable to make it easier to have a single endpoint support all grant types.
public enum GrantRequest: Decodable, Equatable {
	/// The grant is for AccessTokenRequest.
	case authCodeAccessToken(AuthCodeAccessTokenRequest)
	/// The grant is for AccessTokenRefreshRequest.
	case authCodeRefreshAccessToken(AuthCodeAccessTokenRefreshRequest)

	/// The errors that can happen when decoding a GrantRequest.
	public enum Error: Swift.Error {
		/// Error thrown when the grant_type does not match a known grant type.
		case unknownGrantType(String)
	}

	private struct GrantTypeWrapper: Codable {
		enum CodingKeys: String, CodingKey {
			case type = "grant_type"
		}
		var type: String
	}

	public init(from decoder: Decoder) throws {
		let wrapper = try GrantTypeWrapper(from: decoder)

		if let _ = AuthCodeAccessTokenRequest.GrantType(rawValue: wrapper.type) {
			let req = try AuthCodeAccessTokenRequest(from: decoder)
			self = .authCodeAccessToken(req)
		} else if let _ = AuthCodeAccessTokenRefreshRequest.GrantType(rawValue: wrapper.type) {
			let req = try AuthCodeAccessTokenRefreshRequest(from: decoder)
			self = .authCodeRefreshAccessToken(req)
		} else {
			throw Error.unknownGrantType(wrapper.type)
		}
	}
}

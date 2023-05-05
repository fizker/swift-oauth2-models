import Foundation

/// Convenience `Decodable` to make it easier to have a single endpoint support all grant types.
public enum GrantRequest: Decodable, Equatable {
	/// The grant is for ``AuthCodeAccessTokenRequest``.
	case authCodeAccessToken(AuthCodeAccessTokenRequest)
	/// The grant is for ``ClientCredentialsAccessTokenRequest``
	case clientCredentialsAccessToken(ClientCredentialsAccessTokenRequest)
	/// The grant is for ``PasswordAccessTokenRequest``.
	case passwordAccessToken(PasswordAccessTokenRequest)
	/// The grant is for ``RefreshTokenRequest``.
	case refreshToken(RefreshTokenRequest)

	/// The grant is a type not known to this wrapper.
	case unknown(String)

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
		} else if let _ = RefreshTokenRequest.GrantType(rawValue: wrapper.type) {
			let req = try RefreshTokenRequest(from: decoder)
			self = .refreshToken(req)
		} else if let _ = PasswordAccessTokenRequest.GrantType(rawValue: wrapper.type) {
			let req = try PasswordAccessTokenRequest(from: decoder)
			self = .passwordAccessToken(req)
		} else if let _ = ClientCredentialsAccessTokenRequest.GrantType(rawValue: wrapper.type) {
			let req = try ClientCredentialsAccessTokenRequest(from: decoder)
			self = .clientCredentialsAccessToken(req)
		} else {
			self = .unknown(wrapper.type)
		}
	}
}

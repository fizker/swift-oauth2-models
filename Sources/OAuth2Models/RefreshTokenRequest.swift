import Foundation

/// [6.](https://tools.ietf.org/html/rfc6749#section-6) Refreshing an Access Token
///
/// If the authorization server issued a refresh token to the client, the
/// client makes a refresh request to the token endpoint by adding the
/// following parameters using the `application/x-www-form-urlencoded`
/// format per Appendix B with a character encoding of UTF-8 in the HTTP
/// request entity-body:
public struct RefreshTokenRequest: Codable, Equatable {
	public enum CodingKeys: String, CodingKey {
		case grantType = "grant_type"
		case refreshToken = "refresh_token"
		case scope
	}

	/// Available grant types
	public enum GrantType: String, Codable { case refreshToken = "refresh_token" }

	/// REQUIRED.  Value MUST be set to ``GrantType/refreshToken``.
	public var grantType: GrantType

	/// REQUIRED.  The refresh token issued to the client.
	public var refreshToken: String

	/// OPTIONAL.  The scope of the access request as described by
	/// Section 3.3.  The requested scope MUST NOT include any scope
	/// not originally granted by the resource owner, and if omitted is
	/// treated as equal to the scope originally granted by the
	/// resource owner.
	public var scope: Scope

	/// Creates a new ``RefreshTokenRequest``.
	/// - Parameter grantType: The type of grant.
	/// - Parameter refreshToken: The refresh token issued to the client.
	/// - Parameter scope: The scope of the access request.
	public init(grantType: GrantType = .refreshToken, refreshToken: String, scope: Scope = Scope()) {
		self.grantType = grantType
		self.refreshToken = refreshToken
		self.scope = scope
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		grantType = try container.decode(forKey: .grantType)
		refreshToken = try container.decode(forKey: .refreshToken)
		scope = try container.decodeIfPresent(forKey: .scope) ?? Scope()
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		try container.encode(grantType, forKey: .grantType)
		try container.encode(refreshToken, forKey: .refreshToken)
		if !scope.isEmpty {
			try container.encode(scope, forKey: .scope)
		}
	}
}

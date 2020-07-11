import Foundation

/// [4.1.3](https://tools.ietf.org/html/rfc6749#section-4.1.3).  Access Token Request
///
/// The client makes a request to the token endpoint by sending the
/// following parameters using the "application/x-www-form-urlencoded"
/// format per Appendix B with a character encoding of UTF-8 in the HTTP
/// request entity-body
public struct AccessTokenRequest: Codable, Equatable {
	public enum CodingKeys: String, CodingKey {
		case grantType = "grant_type"
		case code
		case redirectURI = "redirect_uri"
		case clientID = "client_id"
	}

	/// The available grant types.
	public enum GrantType: String, Codable { case authorizationCode = "authorization_code" }

	/// REQUIRED.  Value MUST be set to "authorization_code".
	public var grantType: GrantType = .authorizationCode

	/// REQUIRED.  The authorization code received from the authorization server.
	public var code: String

	/// REQUIRED, if the "redirect_uri" parameter was included in the
	/// authorization request as described in Section 4.1.1, and their
	/// values MUST be identical.
	public var redirectURI: URL?

	/// REQUIRED, if the client is not authenticating with the
	/// authorization server as described in Section 3.2.1.
	public var clientID: String?

	/// Creates a new `AccessTokenRequest`.
	///
	/// - Parameter grantType: The type. Defaults to `GrantType.authorizationCode`.
	/// - Parameter code: The authorization code.
	/// - Parameter redirectURI: The URL that a successful AccessToken must be delivered to.
	/// - Parameter clientID: The ID of the client that is requesting the AccessToken.
	public init(
		grantType: GrantType = .authorizationCode,
		code: String,
		redirectURI: URL?,
		clientID: String?
	) {
		self.grantType = grantType
		self.code = code
		self.redirectURI = redirectURI
		self.clientID = clientID
	}
}

/// [6.](https://tools.ietf.org/html/rfc6749#section-6) Refreshing an Access Token
///
/// If the authorization server issued a refresh token to the client, the
/// client makes a refresh request to the token endpoint by adding the
/// following parameters using the "application/x-www-form-urlencoded"
/// format per Appendix B with a character encoding of UTF-8 in the HTTP
/// request entity-body:
public struct AccessTokenRefreshRequest: Codable, Equatable {
	public enum CodingKeys: String, CodingKey {
		case grantType = "grant_type"
		case refreshToken = "refresh_token"
		case scope
	}

	/// Available grant types
	public enum GrantType: String, Codable { case refreshToken = "refresh_token" }

	/// REQUIRED.  Value MUST be set to "refresh_token".
	public var grantType: GrantType

	/// REQUIRED.  The refresh token issued to the client.
	public var refreshToken: String

	/// OPTIONAL.  The scope of the access request as described by
	/// Section 3.3.  The requested scope MUST NOT include any scope
	/// not originally granted by the resource owner, and if omitted is
	/// treated as equal to the scope originally granted by the
	/// resource owner.
	public var scope: String?

	/// Creates a new `AccessTokenRefreshRequest`.
	/// - Parameter grantType: The type of grant.
	/// - Parameter refreshToken: The refresh token issued to the client.
	/// - Parameter scope: The scope of the access request.
	public init(grantType: GrantType = .refreshToken, refreshToken: String, scope: String? = nil) {
		self.grantType = grantType
		self.refreshToken = refreshToken
		self.scope = scope
	}
}

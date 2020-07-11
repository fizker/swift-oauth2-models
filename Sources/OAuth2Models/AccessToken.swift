import Foundation

/// Convenience Decodable to make it easier to have a single endpoint support all grant types.
public enum GrantRequest: Decodable, Equatable {
	/// The grant is for AccessTokenRequest.
	case accessToken(AccessTokenRequest)
	/// The grant is for AccessTokenRefreshRequest.
	case refreshAccessToken(AccessTokenRefreshRequest)

	/// The errors that can happen when decoding a GrantRequest.
	public enum GrantRequestError: Error {
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

		if let _ = AccessTokenRequest.GrantType(rawValue: wrapper.type) {
			let req = try AccessTokenRequest(from: decoder)
			self = .accessToken(req)
		} else if let _ = AccessTokenRefreshRequest.GrantType(rawValue: wrapper.type) {
			let req = try AccessTokenRefreshRequest(from: decoder)
			self = .refreshAccessToken(req)
		} else {
			throw GrantRequestError.unknownGrantType(wrapper.type)
		}
	}
}

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

/// [5.1.](https://tools.ietf.org/html/rfc6749#section-5.1)  Successful Response
///
/// The authorization server issues an access token and optional refresh
/// token, and constructs the response by adding the following parameters
/// to the entity-body of the HTTP response with a 200 (OK) status code:
public struct AccessTokenResponse: Codable, Equatable {
	public enum CodingKeys: String, CodingKey {
		case accessToken = "access_token"
		case tokenType = "token_type"
		case expiresIn = "expires_in"
		case refreshToken = "refresh_token"
		case scope
	}

	// The available token types.
	public enum AccessTokenType: String, Codable {
		case bearer, mac
	}

	/// REQUIRED.  The access token issued by the authorization server.
	public var accessToken: String

	/// REQUIRED.  The type of the token issued as described in
	/// Section 7.1.  Value is case insensitive.
	public var tokenType: AccessTokenType

	/// RECOMMENDED.  The lifetime in seconds of the access token.  For
	/// example, the value "3600" denotes that the access token will
	/// expire in one hour from the time the response was generated.
	/// If omitted, the authorization server SHOULD provide the
	/// expiration time via other means or document the default value.
	public var expiresIn: TokenExpiration?

	/// OPTIONAL.  The refresh token, which can be used to obtain new
	/// access tokens using the same authorization grant as described
	/// in Section 6.
	public var refreshToken: String?

	/// OPTIONAL, if identical to the scope requested by the client;
	/// otherwise, REQUIRED.  The scope of the access token as
	/// described by Section 3.3.
	public var scope: String?

	/// Creates a new `AccessTokenResponse`.
	///
	/// - Parameter accessToken: The access token issued by the authorization server.
	/// - Parameter tokenType: The type of access token.
	/// - Parameter expiresIn: The expiration time for the token.
	/// - Parameter refreshToken: The refresh token.
	/// - Parameter scope: The scope.
	public init(
		accessToken: String,
		tokenType: AccessTokenType,
		expiresIn: TokenExpiration?,
		refreshToken: String? = nil,
		scope: String? = nil
	) {
		self.accessToken = accessToken
		self.tokenType = tokenType
		self.expiresIn = expiresIn
		self.refreshToken = refreshToken
		self.scope = scope
	}
}

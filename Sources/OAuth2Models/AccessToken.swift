import Foundation

/// Convenience Decodable to make it easier to have a single endpoint support all grant types.
public enum GrantRequest: Decodable, Equatable {
	/// The grant is for AccessTokenRequest.
	case accessToken(AccessTokenRequest)
	/// The grant is for AccessTokenRefreshRequest.
	case refreshAccessToken(AccessTokenRefreshRequest)

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

		if let _ = AccessTokenRequest.GrantType(rawValue: wrapper.type) {
			let req = try AccessTokenRequest(from: decoder)
			self = .accessToken(req)
		} else if let _ = AccessTokenRefreshRequest.GrantType(rawValue: wrapper.type) {
			let req = try AccessTokenRefreshRequest(from: decoder)
			self = .refreshAccessToken(req)
		} else {
			throw Error.unknownGrantType(wrapper.type)
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
		case redirectURL = "redirect_uri"
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
	public var redirectURL: URL?

	/// REQUIRED, if the client is not authenticating with the
	/// authorization server as described in Section 3.2.1.
	public var clientID: String?

	/// Creates a new `AccessTokenRequest`.
	///
	/// - Parameter grantType: The type. Defaults to `GrantType.authorizationCode`.
	/// - Parameter code: The authorization code.
	/// - Parameter redirectURL: The URL that a successful AccessToken must be delivered to.
	/// - Parameter clientID: The ID of the client that is requesting the AccessToken.
	public init(
		grantType: GrantType = .authorizationCode,
		code: String,
		redirectURL: URL?,
		clientID: String?
	) {
		self.grantType = grantType
		self.code = code
		self.redirectURL = redirectURL
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
		case type = "token_type"
		case expiration = "expires_in"
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
	public var type: AccessTokenType

	/// RECOMMENDED.  The lifetime in seconds of the access token.  For
	/// example, the value "3600" denotes that the access token will
	/// expire in one hour from the time the response was generated.
	/// If omitted, the authorization server SHOULD provide the
	/// expiration time via other means or document the default value.
	public var expiration: TokenExpiration?

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
	/// - Parameter type: The type of access token.
	/// - Parameter expiresIn: The expiration time for the token.
	/// - Parameter refreshToken: The refresh token.
	/// - Parameter scope: The scope.
	public init(
		accessToken: String,
		type: AccessTokenType,
		expiresIn: TokenExpiration?,
		refreshToken: String? = nil,
		scope: String? = nil
	) {
		self.accessToken = accessToken
		self.type = type
		self.expiration = expiresIn
		self.refreshToken = refreshToken
		self.scope = scope
	}
}

/// [5.2.](https://tools.ietf.org/html/rfc6749#section-5.2) Error Response
public struct AccessTokenError: Codable {
	/// Error thrown during the init function
	public enum Error: Swift.Error {
		/// Thrown when the description contains invalid characters.
		case invalidCharacterInDescription
		/// Thrown when the URL contains invalid characters.
		case invalidCharacterInURL
	}

	public enum CodingKeys: String, CodingKey {
		case code = "error"
		case description = "error_description"
		case url = "error_uri"
	}

	/// The available error codes.
	public enum ErrorCode: String, Codable {
		/// The request is missing a required parameter, includes an
		/// unsupported parameter value (other than grant type),
		/// repeats a parameter, includes multiple credentials,
		/// utilizes more than one mechanism for authenticating the
		/// client, or is otherwise malformed.
		case invalidRequest = "invalid_request"

		/// Client authentication failed (e.g., unknown client, no
		/// client authentication included, or unsupported
		/// authentication method).  The authorization server MAY
		/// return an HTTP 401 (Unauthorized) status code to indicate
		/// which HTTP authentication schemes are supported.  If the
		/// client attempted to authenticate via the "Authorization"
		/// request header field, the authorization server MUST
		/// respond with an HTTP 401 (Unauthorized) status code and
		/// include the "WWW-Authenticate" response header field
		/// matching the authentication scheme used by the client.
		case invalidClient = "invalid_client"

		/// The provided authorization grant (e.g., authorization
		/// code, resource owner credentials) or refresh token is
		/// invalid, expired, revoked, does not match the redirection
		/// URI used in the authorization request, or was issued to another client.
		case invalidGrant = "invalid_grant"

		/// The authenticated client is not authorized to use this authorization grant type.
		case unauthorizedClient = "unauthorized_client"

		/// The authorization grant type is not supported by the authorization server.
		case unsupportedGrantType = "unsupported_grant_type"

		/// The requested scope is invalid, unknown, malformed,
		/// or exceeds the scope granted by the resource owner.
		case invalidScope = "invalid_scope"
	}

	let validCharacters = CharacterSet(charactersIn: Unicode.Scalar(0x20)...Unicode.Scalar(0x7e))
		.subtracting(CharacterSet(arrayLiteral: Unicode.Scalar(0x22), Unicode.Scalar(0x5c)))

	/// REQUIRED.  A single ASCII [USASCII] error code.
	/// Values for the "error" parameter MUST NOT include characters
	/// outside the set %x20-21 / %x23-5B / %x5D-7E.
	public var code: ErrorCode

	/// OPTIONAL.  Human-readable ASCII [USASCII] text providing
	/// additional information, used to assist the client developer in
	/// understanding the error that occurred.
	/// Values for the "error_description" parameter MUST NOT include
	/// characters outside the set %x20-21 / %x23-5B / %x5D-7E.
	public var description: String?

	/// OPTIONAL.  A URI identifying a human-readable web page with
	/// information about the error, used to provide the client
	/// developer with additional information about the error.
	/// Values for the "error_uri" parameter MUST conform to the
	/// URI-reference syntax and thus MUST NOT include characters
	/// outside the set %x21 / %x23-5B / %x5D-7E.
	public var url: URL?

	/// Creates a new AccessTokenError.
	///
	/// - Parameter code: Machine-readable error code.
	/// - Parameter description: Human-readable description of the error.
	/// - Parameter url: URL for human-readable error page.
	public init(code: ErrorCode, description: String?, url: URL?) throws {
		self.code = code
		self.description = description
		self.url = url

		if let description = description?.unicodeScalars {
			guard description.allSatisfy(validCharacters.contains)
			else { throw Error.invalidCharacterInDescription }
		}

		if let url = url?.absoluteString.unicodeScalars {
			guard url.allSatisfy(validCharacters.subtracting(CharacterSet(arrayLiteral: Unicode.Scalar(0x20))).contains)
			else { throw Error.invalidCharacterInURL }
		}
	}
}

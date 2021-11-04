import Foundation

/// [4.1.3](https://tools.ietf.org/html/rfc6749#section-4.1.3).  Access Token Request
///
/// The client makes a request to the token endpoint by sending the
/// following parameters using the `application/x-www-form-urlencoded`
/// format per Appendix B with a character encoding of UTF-8 in the HTTP
/// request entity-body
public struct AuthCodeAccessTokenRequest: Codable, Equatable {
	public enum CodingKeys: String, CodingKey {
		case grantType = "grant_type"
		case code
		case redirectURL = "redirect_uri"
		case clientID = "client_id"
	}

	/// The available grant types.
	public enum GrantType: String, Codable { case authorizationCode = "authorization_code" }

	/// REQUIRED.  Value MUST be set to ``GrantType/authorizationCode``.
	public var grantType: GrantType = .authorizationCode

	/// REQUIRED.  The authorization code received from the authorization server.
	public var code: String

	/// REQUIRED, if the ``redirectURL`` parameter was included in the
	/// authorization request as described in Section 4.1.1, and their
	/// values MUST be identical.
	public var redirectURL: URL?

	/// REQUIRED, if the client is not authenticating with the
	/// authorization server as described in Section 3.2.1.
	public var clientID: String?

	/// Creates a new ``AuthCodeAccessTokenRequest``.
	///
	/// - Parameter grantType: The type. Defaults to ``GrantType/authorizationCode``.
	/// - Parameter code: The authorization code.
	/// - Parameter redirectURL: The URL that a successful ``AccessTokenResponse`` must be delivered to.
	/// - Parameter clientID: The ID of the client that is requesting the  ``AccessTokenResponse``.
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

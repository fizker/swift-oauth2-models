import Foundation

/// [4.4.2](https://tools.ietf.org/html/rfc6749#section-4.4.2). Client Credentials Access Token Request
///
///  The client makes a request to the token endpoint by adding the
///  following parameters using the `application/x-www-form-urlencoded`
///  format per Appendix B with a character encoding of UTF-8 in the HTTP
///  request entity-body:
///
/// The client MUST authenticate with the authorization server as  described in [Section 3.2.1](https://tools.ietf.org/html/rfc6749#section-3.2.1).
public struct ClientCredentialsAccessTokenRequest: Codable, Equatable, Sendable {
	public enum CodingKeys: String, CodingKey {
		case grantType = "grant_type"
		case scope
		case clientID = "client_id"
		case clientSecret = "client_secret"
	}

	public enum GrantType: String, Codable, Sendable {
		case clientCredentials = "client_credentials"
	}

	/// REQUIRED.  Value MUST be set to ``GrantType-swift.enum/clientCredentials``.
	public var grantType: GrantType

	/// OPTIONAL.  The scope of the access request as described by Section 3.3.
	public var scope: Scope

	/// OPTIONAL. The authorization server MAY support including the
	/// client credentials in the request-body using the following parameters
	/// The client identifier issued to the client during the registration process described
	/// by [Section 2.2](https://datatracker.ietf.org/doc/html/rfc6749#section-2.2).
	public var clientID: String?

	/// OPTIONAL. The client secret.  The client MAY omit the parameter if the client secret is an empty string.
	public var clientSecret: String?

	/// Creates a new ``ClientCredentialsAccessTokenRequest``
	/// - Parameter grantType: Value MUST be set to ``GrantType-swift.enum/clientCredentials``.
	/// - Parameter scope: The scope of the access request as described by Section 3.3.
	public init(grantType: GrantType = .clientCredentials, scope: Scope = Scope(), clientID: String? = nil, clientSecret: String? = nil) {
		self.grantType = grantType
		self.scope = scope
		self.clientID = clientID
		self.clientSecret = clientSecret
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		grantType = try container.decode(forKey: .grantType)
		scope = try container.decodeIfPresent(forKey: .scope) ?? Scope()
		clientID = try container.decodeIfPresent(forKey: .clientID)
		clientSecret = try container.decodeIfPresent(forKey: .clientSecret)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		try container.encode(grantType, forKey: .grantType)
		if !scope.isEmpty {
			try container.encode(scope, forKey: .scope)
		}
		if let clientID {
			try container.encode(clientID, forKey: .clientID)
		}
		if let clientSecret {
			try container.encode(clientSecret, forKey: .clientSecret)
		}
	}
}

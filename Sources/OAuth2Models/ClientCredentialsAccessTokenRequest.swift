import Foundation

/// [4.4.2](https://tools.ietf.org/html/rfc6749#section-4.4.2). Client Credentials Access Token Request
///
///  The client makes a request to the token endpoint by adding the
///  following parameters using the `application/x-www-form-urlencoded`
///  format per Appendix B with a character encoding of UTF-8 in the HTTP
///  request entity-body:
///
/// The client MUST authenticate with the authorization server as  described in [Section 3.2.1](https://tools.ietf.org/html/rfc6749#section-3.2.1).
public struct ClientCredentialsAccessTokenRequest: Codable, Equatable {
	public enum CodingKeys: String, CodingKey {
		case grantType = "grant_type"
		case scope
	}

	public enum GrantType: String, Codable {
		case clientCredentials = "client_credentials"
	}

	/// REQUIRED.  Value MUST be set to ``GrantType-swift.enum/clientCredentials``.
	public var grantType: GrantType

	/// OPTIONAL.  The scope of the access request as described by Section 3.3.
	public var scope: Scope

	/// Creates a new ``ClientCredentialsAccessTokenRequest``
	/// - Parameter grantType: Value MUST be set to ``GrantType-swift.enum/clientCredentials``.
	/// - Parameter scope: The scope of the access request as described by Section 3.3.
	public init(grantType: GrantType = .clientCredentials, scope: Scope = Scope()) {
		self.grantType = grantType
		self.scope = scope
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		grantType = try container.decode(forKey: .grantType)
		scope = try container.decodeIfPresent(forKey: .scope) ?? Scope()
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		try container.encode(grantType, forKey: .grantType)
		if !scope.isEmpty {
			try container.encode(scope, forKey: .scope)
		}
	}
}

import Foundation

/// [4.3.2](https://tools.ietf.org/html/rfc6749#section-4.3.2). Resource Owner Password Credentials Access Token Request
///
/// The client makes a request to the token endpoint by adding the
/// following parameters using the `application/x-www-form-urlencoded`
/// format per Appendix B with a character encoding of UTF-8 in the HTTP
/// request entity-body
public struct PasswordAccessTokenRequest: Codable, Equatable, Sendable {
	public enum CodingKeys: String, CodingKey {
		case grantType = "grant_type"
		case username
		case password
		case scope
	}

	/// The available grant types.
	public enum GrantType: String, Codable, Sendable {
		case password
	}

	/// REQUIRED.  Value MUST be set to ``GrantType-swift.enum/password``.
	public var grantType: GrantType

	/// REQUIRED.  The resource owner username.
	public var username: String

	/// REQUIRED.  The resource owner password.
	public var password: String

	/// OPTIONAL.  The scope of the access request as described by Section 3.3.
	public var scope: Scope

	/// Creates a new ``PasswordAccessTokenRequest``.
	/// - Parameter grantType: Value MUST be set to ``GrantType-swift.enum/password``.
	/// - Parameter username: The resource owner username.
	/// - Parameter password: The resource owner password.
	/// - Parameter scope: The scope of the access request as described by Section 3.3.
	public init(
		grantType: GrantType = .password,
		username: String,
		password: String,
		scope: Scope = Scope()
	) {
		self.grantType = grantType
		self.username = username
		self.password = password
		self.scope = scope
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		grantType = try container.decode(forKey: .grantType)
		username = try container.decode(forKey: .username)
		password = try container.decode(forKey: .password)
		scope = try container.decodeIfPresent(forKey: .scope) ?? Scope()
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		try container.encode(grantType, forKey: .grantType)
		try container.encode(username, forKey: .username)
		try container.encode(password, forKey: .password)
		if !scope.isEmpty {
			try container.encode(scope, forKey: .scope)
		}
	}
}

import Foundation

/// [4.3.2](https://tools.ietf.org/html/rfc6749#section-4.3.2). Resource Owner Password Credentials Access Token Request
///
/// The client makes a request to the token endpoint by adding the
/// following parameters using the "application/x-www-form-urlencoded"
/// format per Appendix B with a character encoding of UTF-8 in the HTTP
/// request entity-body
public struct PasswordAccessTokenRequest: Codable, Equatable {
	public enum CodingKeys: String, CodingKey {
		case grantType = "grant_type"
		case username
		case password
		case scope
	}

	public enum GrantType: String, Codable { case password }

	/// REQUIRED.  Value MUST be set to "password".
	public var grantType: GrantType = .password

	/// REQUIRED.  The resource owner username.
	public var username: String

	/// REQUIRED.  The resource owner password.
	public var password: String

	/// OPTIONAL.  The scope of the access request as described by Section 3.3.
	public var scope: Scope?
}

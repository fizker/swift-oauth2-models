import Foundation

/// [5.1.](https://tools.ietf.org/html/rfc6749#section-5.1)  Successful Response
///
/// The authorization server issues an access token and optional refresh
/// token, and constructs the response by adding the following parameters
/// to the entity-body of the HTTP response with a 200 (OK) status code:
public struct AccessTokenResponse: Codable, Equatable {
	/// Convenience type for referencing a Codable `Result<Self, ErrorResponse>`.
	public typealias Result = Swift.Result<Self, ErrorResponse>

	public enum CodingKeys: String, CodingKey {
		case accessToken = "access_token"
		case type = "token_type"
		case expiration = "expires_in"
		case refreshToken = "refresh_token"
		case scope
	}

	// The available token types.
	public enum AccessTokenType: String, Codable, CaseIterable {
		case bearer, mac

		public init(from decoder: Decoder) throws {
			let container = try decoder.singleValueContainer()
			let value = try container.decode(String.self)
			let lowercased = value.lowercased()

			for `case` in Self.allCases {
				if `case`.rawValue == lowercased {
					self = `case`
					return
				}
			}

			throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unknown AccessTokenType: \(value)")
		}
	}

	/// REQUIRED.  The access token issued by the authorization server.
	public var accessToken: String

	/// REQUIRED.  The type of the token issued as described in
	/// Section 7.1.  Value is case insensitive.
	public var type: AccessTokenType

	/// RECOMMENDED.  The lifetime in seconds of the access token.  For
	/// example, the value `3600` denotes that the access token will
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
	public var scope: Scope?

	/// Creates a new ``AccessTokenResponse``.
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
		scope: Scope = Scope()
	) {
		self.accessToken = accessToken
		self.type = type
		self.expiration = expiresIn
		self.refreshToken = refreshToken
		self.scope = scope
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		accessToken = try container.decode(forKey: .accessToken)
		type = try container.decode(forKey: .type)
		expiration = try container.decodeIfPresent(forKey: .expiration)
		refreshToken = try container.decodeIfPresent(forKey: .refreshToken)
		scope = try container.decodeIfPresent(forKey: .scope)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(accessToken, forKey: .accessToken)
		try container.encode(type, forKey: .type)
		try expiration.map { try container.encode($0, forKey: .expiration) }
		try refreshToken.map { try container.encode($0, forKey: .refreshToken) }
		if let scope, !scope.isEmpty {
			try container.encode(scope, forKey: .scope)
		}
	}
}

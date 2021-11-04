import Foundation

/// [4.1.1.](https://tools.ietf.org/html/rfc6749#section-4.1.1) Authorization Request
///
/// The client constructs the request URI by adding the following
/// parameters to the query component of the authorization endpoint URI
/// using the `application/x-www-form-urlencoded` format, per Appendix B.
public struct AuthRequest: Codable, Equatable {
	public enum CodingKeys: String, CodingKey {
		case clientID = "client_id"
		case responseType = "response_type"
		case redirectURL = "redirect_uri"
		case state
		case scope
	}

	/// Available response types.
	public enum ResponseType: String, Codable {
		/// 4.1.1. Authorization Code Grant
		case code
		/// 4.2.1. Implicit Grant
		case token
	}

	/// REQUIRED
	public var responseType: ResponseType

	/// REQUIRED.  The client identifier as described in Section 2.2.
	public var clientID: String

	/// OPTIONAL.  As described in Section 3.1.2.
	public var redirectURL: URL?

	/// OPTIONAL.  The scope of the access request as described by Section 3.3.
	public var scope: Scope

	/// RECOMMENDED.  An opaque value used by the client to maintain
	/// state between the request and callback.
	///
	/// The authorization server includes this value when redirecting the user-agent back
	/// to the client.  The parameter SHOULD be used for preventing
	/// cross-site request forgery as described in Section 10.12.
	public var state: String?

	/// Creates a new ``AuthRequest``.
	///
	/// - Parameter responseType: The type of the response.
	/// - Parameter clientID: The client identifier.
	/// - Parameter redirectURL: The URL that the response should be redirected to.
	/// - Parameter state: A state property that the response should include.
	/// - Parameter scope: The scope of the access request.
	public init(
		responseType: ResponseType,
		clientID: String,
		redirectURL: URL,
		state: String?,
		scope: Scope = Scope()
	) {
		self.responseType = responseType
		self.clientID = clientID
		self.redirectURL = redirectURL
		self.state = state
		self.scope = scope
	}

	/// Creates a new ``AuthRequest`` without a redirect URL.
	///
	/// - Parameter responseType: The type of the response.
	/// - Parameter clientID: The client identifier.
	/// - Parameter state: A state property that the response should include.
	/// - Parameter scope: The scope of the access request.
	public init(
		responseType: ResponseType,
		clientID: String,
		state: String?,
		scope: Scope = Scope()
	) {
		self.responseType = responseType
		self.clientID = clientID
		self.redirectURL = nil
		self.state = state
		self.scope = scope
	}

	/// Creates a new ``AuthCodeAuthResponse`` based on this request.
	///
	/// - Parameter code: The authorization code to use when requesting an access token.
	public func response(code: String) -> AuthCodeAuthResponse {
		AuthCodeAuthResponse(code: code, request: self)
	}

	/// Creates a new ``ErrorResponse`` based on this request.
	///
	/// - Parameter code: A machine-readable error code.
	/// - Parameter description: A human-readable description.
	/// - Parameter url: A URL to a human-readable web page.
	public func error(code: ErrorResponse.ErrorCode, description: ErrorDescription?, url: ErrorURL?) -> ErrorResponse {
		ErrorResponse(code: code, request: self, description: description, url: url)
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		responseType = try container.decode(forKey: .responseType)
		clientID = try container.decode(forKey: .clientID)
		redirectURL = try container.decodeIfPresent(forKey: .redirectURL)
		state = try container.decodeIfPresent(forKey: .state)
		scope = try container.decodeIfPresent(forKey: .scope) ?? Scope()
	}
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		try container.encode(responseType, forKey: .responseType)
		try container.encode(clientID, forKey: .clientID)
		try redirectURL.map { try container.encode($0, forKey: .redirectURL) }
		try state.map { try container.encode($0, forKey: .state) }
		if !scope.isEmpty {
			try container.encode(scope, forKey: .scope)
		}
	}
}

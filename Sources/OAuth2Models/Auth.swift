import Foundation

/// [4.1.1.](https://tools.ietf.org/html/rfc6749#section-4.1.1) Authorization Request
///
/// The client constructs the request URI by adding the following
/// parameters to the query component of the authorization endpoint URI
/// using the "application/x-www-form-urlencoded" format, per Appendix B.
public struct AuthRequest: Codable {
	public enum CodingKeys: String, CodingKey {
		case clientID = "client_id"
		case responseType = "response_type"
		case redirectURL = "redirect_uri"
		case state
		case scope
	}

	/// Available response types.
	public enum ResponseType: String, Codable { case code }

	/// REQUIRED.  Value MUST be set to "code".
	public var responseType: ResponseType

	/// REQUIRED.  The client identifier as described in Section 2.2.
	public var clientID: String

	/// OPTIONAL.  As described in Section 3.1.2.
	public var redirectURL: URL?

	/// OPTIONAL.  The scope of the access request as described by Section 3.3.
	public var scope: String?

	/// RECOMMENDED.  An opaque value used by the client to maintain
	/// state between the request and callback.
	///
	/// The authorization server includes this value when redirecting the user-agent back
	/// to the client.  The parameter SHOULD be used for preventing
	/// cross-site request forgery as described in Section 10.12.
	public var state: String?

	/// Creates a new `AuthRequest`.
	///
	/// - Parameter responseType: The type of the response.
	/// - Parameter clientID: The client identifier.
	/// - Parameter redirectURL: The URL that the response should be redirected to.
	/// - Parameter state: A state property that the response should include.
	/// - Parameter scope: The scope of the access request.
	public init(
		responseType: ResponseType = .code,
		clientID: String,
		redirectURL: URL,
		state: String?,
		scope: String?
	) {
		self.responseType = responseType
		self.clientID = clientID
		self.redirectURL = redirectURL
		self.state = state
		self.scope = scope
	}

	/// Creates a new `AuthRequest` without a redirect URL.
	///
	/// - Parameter responseType: The type of the response.
	/// - Parameter clientID: The client identifier.
	/// - Parameter state: A state property that the response should include.
	/// - Parameter scope: The scope of the access request.
	public init(
		responseType: ResponseType = .code,
		clientID: String,
		state: String?,
		scope: String?
	) {
		self.responseType = responseType
		self.clientID = clientID
		self.redirectURL = nil
		self.state = state
		self.scope = scope
	}
}

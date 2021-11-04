import Foundation

/// Error Response for all error codes in use by RFC 6749.
/// This covers [4.1.2.1 Authorization Code Grant](https://tools.ietf.org/html/rfc6749#section-4.1.2.1),
/// [4.2.2.1 Implicit Grant](https://tools.ietf.org/html/rfc6749#section-4.2.2.1) and [5.2 for other uses](https://tools.ietf.org/html/rfc6749#section-5.2).
///
/// The authorization server responds with an HTTP 400 (Bad Request)
/// status code (unless specified otherwise).
///
/// See [4.1.2.1](https://tools.ietf.org/html/rfc6749#section-4.1.2.1) for the error response in use for Authorization Code Grant.
///
/// See [4.2.2.1](https://tools.ietf.org/html/rfc6749#section-4.2.2.1) for the error response in use for Implicit Grant.
///
/// See [5.2](https://tools.ietf.org/html/rfc6749#section-5.2) for the generic Error Response used for unspecified types.
public struct ErrorResponse: Error, Codable, Equatable {
	public enum CodingKeys: String, CodingKey {
		case code = "error"
		case description = "error_description"
		case url = "error_uri"
		case state
	}

	/// The available error codes.
	public enum ErrorCode: String, Codable {
		/// The codes that are valid according to section [5.2 Error Response](https://tools.ietf.org/html/rfc6749#section-5.2)
		public var valid5_2Codes: [ErrorCode] {
			[
				.invalidRequest,
				.invalidClient,
				.invalidGrant,
				.unauthorizedClient,
				.unsupportedGrantType,
				.invalidScope,
			]
		}
		/// The codes that are valid according to section [4.1.2.1 Authorization Code Grant Error Response](https://tools.ietf.org/html/rfc6749#section-4.1.2.1)
		public var valid4_1_2_1Codes: [ErrorCode] {
			[
				.invalidRequest,
				.unauthorizedClient,
				.accessDenied,
				.unsupportedResponseType,
				.invalidScope,
				.serverError,
				.temporarilyUnavailable,
			]
		}
		/// The codes that are valid according to section [4.2.2.1 Implicit Grant Error Response](https://tools.ietf.org/html/rfc6749#section-4.2.2.1)
		public var valid4_2_2_1Codes: [ErrorCode] {
			[
				.invalidRequest,
				.unauthorizedClient,
				.accessDenied,
				.unsupportedResponseType,
				.invalidScope,
				.serverError,
				.temporarilyUnavailable,
			]
		}

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
		/// client attempted to authenticate via the `Authorization`
		/// request header field, the authorization server MUST
		/// respond with an HTTP 401 (Unauthorized) status code and
		/// include the `WWW-Authenticate` response header field
		/// matching the authentication scheme used by the client.
		case invalidClient = "invalid_client"

		/// The provided authorization grant (e.g., authorization
		/// code, resource owner credentials) or refresh token is
		/// invalid, expired, revoked, does not match the redirection
		/// URI used in the authorization request, or was issued to
		/// another client.
		case invalidGrant = "invalid_grant"

		/// The client is not authorized to request an authorization
		/// code using this method.
		case unauthorizedClient = "unauthorized_client"

		/// The authorization grant type is not supported by the
		/// authorization server.
		case unsupportedGrantType = "unsupported_grant_type"

		/// The resource owner or authorization server denied the request.
		case accessDenied = "access_denied"

		/// The authorization server does not support obtaining an
		/// authorization code using this method.
		case unsupportedResponseType = "unsupported_response_type"

		/// The requested scope is invalid, unknown, or malformed, or
		/// exceeds the scope granted by the resource owner.
		case invalidScope = "invalid_scope"

		/// The authorization server encountered an unexpected
		/// condition that prevented it from fulfilling the request.
		/// (This error code is needed because a 500 Internal Server
		/// Error HTTP status code cannot be returned to the client
		/// via an HTTP redirect.)
		case serverError = "server_error"

		/// The authorization server is currently unable to handle
		/// the request due to a temporary overloading or maintenance
		/// of the server.  (This error code is needed because a 503
		/// Service Unavailable HTTP status code cannot be returned
		/// to the client via an HTTP redirect.)
		case temporarilyUnavailable = "temporarily_unavailable"
	}

	/// REQUIRED.  A single ASCII [USASCII] error code
	public var code: ErrorCode

	/// OPTIONAL.  Human-readable ASCII [USASCII] text providing
	/// additional information, used to assist the client developer in
	/// understanding the error that occurred.
	/// Values for the ``description`` parameter MUST NOT include
	/// characters outside the set %x20-21 / %x23-5B / %x5D-7E.
	public var description: String?

	/// OPTIONAL.  A URI identifying a human-readable web page with
	/// information about the error, used to provide the client
	/// developer with additional information about the error.
	/// Values for the ``url`` parameter MUST conform to the
	/// URI-reference syntax and thus MUST NOT include characters
	/// outside the set %x21 / %x23-5B / %x5D-7E.
	public var url: URL?

	/// REQUIRED if a ``state`` parameter was present in the client
	/// authorization request.  The exact value received from the
	/// client.
	public var state: String?

	/// Creates a new ``ErrorResponse``.
	///
	/// - Parameter code: A machine-readable error code.
	/// - Parameter state: The exact value received from the client.
	/// - Parameter description: A human-readable description.
	/// - Parameter url: A URL to a human-readable web page.
	public init(
		code: ErrorCode,
		description: ErrorDescription?,
		url: ErrorURL? = nil,
		state: String? = nil
	) {
		self.code = code
		self.description = description?.value
		self.url = url?.value
		self.state = state
	}

	/// Creates a new ``ErrorResponse``.
	///
	/// - Parameter code: A machine-readable error code.
	/// - Parameter request: The ``AuthRequest`` that spawned the error.
	/// - Parameter description: A human-readable description.
	/// - Parameter url: A URL to a human-readable web page.
	public init(
		code: ErrorCode,
		request: AuthRequest,
		description: ErrorDescription?,
		url: ErrorURL? = nil
	) {
		self.code = code
		self.description = description?.value
		self.url = url?.value
		self.state = request.state
	}
}

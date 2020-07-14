import Foundation

/// [4.1.2.1.](https://tools.ietf.org/html/rfc6749#section-4.1.2.1)  Error Response
///
/// If the request fails due to a missing, invalid, or mismatching
/// redirection URI, or if the client identifier is missing or invalid,
/// the authorization server SHOULD inform the resource owner of the
/// error and MUST NOT automatically redirect the user-agent to the
/// invalid redirection URI.
///
/// If the resource owner denies the access request or if the request
/// fails for reasons other than a missing or invalid redirection URI,
/// the authorization server informs the client by adding the following
/// parameters to the query component of the redirection URI using the
/// "application/x-www-form-urlencoded" format, per Appendix B.
public struct ErrorResponse: Codable, Equatable {
	public enum CodingKeys: String, CodingKey {
		case code = "error"
		case description = "error_description"
		case url = "error_uri"
		case state
	}

	/// The available error codes.
	public enum ErrorCode: String, Codable {
		/// The request is missing a required parameter, includes an
		/// invalid parameter value, includes a parameter more than
		/// once, or is otherwise malformed.
		case invalidRequest = "invalid_request"

		/// The client is not authorized to request an authorization
		/// code using this method.
		case unauthorizedClient = "unauthorized_client"

		/// The resource owner or authorization server denied the request.
		case accessDenied = "access_denied"

		/// The authorization server does not support obtaining an
		/// authorization code using this method.
		case unsupportedResponseType = "unsupported_response_type"

		/// The requested scope is invalid, unknown, or malformed.
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

	/// REQUIRED if a "state" parameter was present in the client
	/// authorization request.  The exact value received from the
	/// client.
	public var state: String?

	/// Creates a new `ErrorResponse`.
	///
	/// - Parameter code: A machine-readable error code.
	/// - Parameter request: The `AuthRequest` that spawned the error.
	/// - Parameter description: A human-readable description.
	/// - Parameter url: A URL to a human-readable web page.
	public init(
		code: ErrorCode,
		request: AuthRequest,
		description: ErrorDescription?,
		url: ErrorURL?
	) {
		self.code = code
		self.description = description?.value
		self.url = url?.value
		self.state = request.state
	}
}

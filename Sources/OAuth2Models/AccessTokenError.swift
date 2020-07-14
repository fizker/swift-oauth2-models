import Foundation

/// [5.2.](https://tools.ietf.org/html/rfc6749#section-5.2) Error Response
public struct AccessTokenError: Codable {
	/// Error thrown during the init function
	public enum CharacterSetError: Swift.Error {
		/// Thrown when the description contains invalid characters.
		case invalidCharacterInDescription
		/// Thrown when the URL contains invalid characters.
		case invalidCharacterInURL
	}

	public enum CodingKeys: String, CodingKey {
		case code = "error"
		case description = "error_description"
		case url = "error_uri"
	}

	/// The available error codes.
	public enum ErrorCode: String, Codable {
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
		/// client attempted to authenticate via the "Authorization"
		/// request header field, the authorization server MUST
		/// respond with an HTTP 401 (Unauthorized) status code and
		/// include the "WWW-Authenticate" response header field
		/// matching the authentication scheme used by the client.
		case invalidClient = "invalid_client"

		/// The provided authorization grant (e.g., authorization
		/// code, resource owner credentials) or refresh token is
		/// invalid, expired, revoked, does not match the redirection
		/// URI used in the authorization request, or was issued to another client.
		case invalidGrant = "invalid_grant"

		/// The authenticated client is not authorized to use this authorization grant type.
		case unauthorizedClient = "unauthorized_client"

		/// The authorization grant type is not supported by the authorization server.
		case unsupportedGrantType = "unsupported_grant_type"

		/// The requested scope is invalid, unknown, malformed,
		/// or exceeds the scope granted by the resource owner.
		case invalidScope = "invalid_scope"
	}

	/// REQUIRED.  A single ASCII [USASCII] error code.
	/// Values for the "error" parameter MUST NOT include characters
	/// outside the set %x20-21 / %x23-5B / %x5D-7E.
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

	/// Creates a new AccessTokenError.
	///
	/// - Parameter code: Machine-readable error code.
	/// - Parameter description: Human-readable description of the error.
	/// - Parameter url: URL for human-readable error page.
	public init(code: ErrorCode, description: ErrorDescription?, url: ErrorURL?) {
		self.code = code
		self.description = description?.value
		self.url = url?.value
	}
}

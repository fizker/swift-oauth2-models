import Foundation
import OAuth2Models

extension ErrorResponse {
	init(code: ErrorCode, description: String?, state: String?) {
		let r = AuthRequest(clientID: "", state: state, scope: Scope())
		self = r.error(code: code, description: try! description.map(ErrorDescription.init(_:)), url: nil)
	}

	init(code: ErrorCode, description: String?, url: URL, state: String?) {
		let r = AuthRequest(clientID: "", state: state, scope: Scope())
		self = r.error(code: code, description: try! description.map(ErrorDescription.init(_:)), url: try! ErrorURL(url))
	}
}

extension AuthCodeAuthResponse {
	init(code: String, state: String?) {
		let r = AuthRequest(clientID: "", state: state, scope: Scope())
		self = r.response(code: code)
	}
}

extension ErrorDescription: ExpressibleByStringLiteral {
	public init(stringLiteral value: StringLiteralType) {
		try! self.init(value)
	}
}
extension ErrorURL: ExpressibleByStringLiteral {
	public init(stringLiteral value: StringLiteralType) {
		let url = URL(string: value)!
		try! self.init(url)
	}
}

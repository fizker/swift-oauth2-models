import Foundation
import OAuth2Models

extension AuthCodeAuthResponse {
	init(code: String, state: String?) {
		let r = AuthRequest(responseType: .code, clientID: "", state: state, scope: Scope())
		self = r.response(code: code)
	}
}

extension ErrorURL: ExpressibleByStringLiteral {
	public init(stringLiteral value: StringLiteralType) {
		let url = URL(string: value)!
		try! self.init(url)
	}
}

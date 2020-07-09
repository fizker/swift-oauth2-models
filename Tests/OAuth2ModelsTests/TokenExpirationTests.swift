import XCTest
import OAuth2Models

final class TokenExpirationTests: XCTestCase {
	let comparisonTests: [( lhs: TokenExpiration, rhs: TokenExpiration, expectedEquals: Bool, expectedLessThan: Bool )] = [
		(.oneHour, .oneHour, expectedEquals: true, expectedLessThan: false),
		(.oneHour, .hours(1), expectedEquals: true, expectedLessThan: false),
		(.oneHour, .hours(2), expectedEquals: false, expectedLessThan: true),
		(.oneHour, .minutes(59), expectedEquals: false, expectedLessThan: false),
		(.oneHour, .minutes(60), expectedEquals: true, expectedLessThan: false),
		(.oneHour, .minutes(61), expectedEquals: false, expectedLessThan: true),
		(.oneHour, .seconds(3599), expectedEquals: false, expectedLessThan: false),
		(.oneHour, .seconds(3600), expectedEquals: true, expectedLessThan: false),
		(.oneHour, .seconds(3601), expectedEquals: false, expectedLessThan: true),
		(.minutes(1), .seconds(60), expectedEquals: true, expectedLessThan: false),
		(.hours(24), .days(1), expectedEquals: true, expectedLessThan: false),
		(.hours(23), .days(1), expectedEquals: false, expectedLessThan: true),
		(.hours(25), .days(1), expectedEquals: false, expectedLessThan: false),
	]

	func test__lessThanOperator__returnsExpectedValue() {
		for test in comparisonTests {
			XCTAssertEqual(test.lhs < test.rhs, test.expectedLessThan, "\(test.lhs) < \(test.rhs)")
		}
	}

	func test__equalsOperator__returnsExpectedValue() {
		for test in comparisonTests {
			XCTAssertEqual(test.lhs == test.rhs, test.expectedEquals, "\(test.lhs) == \(test.rhs)")
		}
	}

	let convertToSecondsTests: [( item: TokenExpiration, seconds: Int )] = [
		(.seconds(100), 100),
		(.minutes(100), 6000),
		(.oneHour, 3600),
		(.hours(1), 3600),
		(.hours(10), 36_000),
		(.oneDay, 86_400),
		(.days(1), 86_400),
		(.days(2), 172_800),
	]

	func test__inSeconds__returnsExpectedValue() {
		for (item, seconds) in convertToSecondsTests {
			XCTAssertEqual(item.inSeconds, seconds, "inSeconds")
		}
	}

	func test__asTimeInterval__returnsExpectedValue() {
		for (item, seconds) in convertToSecondsTests {
			XCTAssertEqual(item.asTimeInterval, TimeInterval(seconds), "asTimeInterval")
		}
	}

	func test__date_in__thePast__returnsExpectedValue() {
		for (item, seconds) in convertToSecondsTests {
			let date = item.date(in: .thePast)
			XCTAssertEqual(date.timeIntervalSinceNow, TimeInterval(-seconds), accuracy: 0.01)
		}
	}

	func test__date_in__theFuture__returnsExpectedValue() {
		for (item, seconds) in convertToSecondsTests {
			let date = item.date(in: .theFuture)
			XCTAssertEqual(date.timeIntervalSinceNow, TimeInterval(seconds), accuracy: 0.01)
		}
	}

	var codingTests: [( item: TokenExpiration, json: String )] {
		convertToSecondsTests.map { (item, seconds) in
			(item, "\(seconds)")
		}
	}

	func test__encodable__JSONEncoder__encodesAsExpected() throws {
		let encoder = JSONEncoder()
		for (item, json) in codingTests {
			let data = try encoder.encode(item)
			let actual = String(data: data, encoding: .utf8)!
			XCTAssertEqual(actual, json)
		}
	}

	func test__decodable__JSONDecoder__decodesAsExpected() throws {
		let decoder = JSONDecoder()
		for (item, json) in codingTests {
			let data = json.data(using: .utf8)!
			let actual = try decoder.decode(TokenExpiration.self, from: data)
			XCTAssertEqual(actual, item)
		}
	}

	func test__decodable__JSONDecoder_decimalExpiration__floorsNumber() throws {
		let item: TokenExpiration = .seconds(100)
		let json = "100.5"

		let decoder = JSONDecoder()

		let data = json.data(using: .utf8)!
		let actual = try decoder.decode(TokenExpiration.self, from: data)
		XCTAssertEqual(actual, item)
	}
}

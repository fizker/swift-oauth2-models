import Foundation

public struct TokenExpiration: Codable, Equatable, Comparable {
	var seconds: Int

	public init(seconds: Int) {
		self.seconds = seconds
	}
	public init(minutes: Int) {
		self = .init(seconds: minutes * 60)
	}
	public init(hours: Int) {
		self = .init(minutes: hours * 60)
	}
	public init(days: Int) {
		self = .init(hours: days * 24)
	}

	public static func seconds(_ seconds: Int) -> TokenExpiration {
		.init(seconds: seconds)
	}
	public static func minutes(_ minutes: Int) -> TokenExpiration {
		.init(minutes: minutes)
	}
	public static func hours(_ hours: Int) -> TokenExpiration {
		.init(hours: hours)
	}
	public static func days(_ days: Int) -> TokenExpiration {
		.init(days: days)
	}

	public static let oneHour: TokenExpiration = .hours(1)
	public static let oneDay: TokenExpiration = .days(1)

	public enum RelativeDateDirection {
		case thePast
		case theFuture
	}

	public func date(in direction: RelativeDateDirection) -> Date {
		switch direction {
		case .thePast:
			return Date(timeIntervalSinceNow: -asTimeInterval)
		case .theFuture:
			return Date(timeIntervalSinceNow: asTimeInterval)
		}
	}

	public var inSeconds: Int { seconds }
	public var asTimeInterval: TimeInterval {
		return TimeInterval(inSeconds)
	}
}

extension TokenExpiration {
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		let timeInterval = try container.decode(TimeInterval.self)
		self = .seconds(Int(timeInterval))
	}
	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(inSeconds)
	}
}

extension TokenExpiration {
	public static func ==(lhs: Self, rhs: Self) -> Bool {
		return lhs.inSeconds == rhs.inSeconds
	}

	public static func <(lhs: Self, rhs: Self) -> Bool {
		return lhs.inSeconds < rhs.inSeconds
	}
}

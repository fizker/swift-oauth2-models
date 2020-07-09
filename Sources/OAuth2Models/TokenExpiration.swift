import Foundation

public enum TokenExpiration: Codable, Equatable, Comparable {
	case seconds(Int)
	case minutes(Int)
	case hours(Int)
	case days(Int)

	public static let oneHour: Self = .hours(1)
	public static let oneDay: Self = .days(1)

	public enum DateGeneration {
		case thePast, theFuture
	}
	public func date(in direction: DateGeneration) -> Date {
		switch direction {
		case .thePast:
			return Date(timeIntervalSinceNow: -asTimeInterval)
		case .theFuture:
			return Date(timeIntervalSinceNow: asTimeInterval)
		}
	}

	public var inSeconds: Int {
		switch self {
		case let .seconds(s):
			return s
		case let .minutes(min):
			return Self.seconds(min * 60).inSeconds
		case let .hours(h):
			return Self.minutes(h * 60).inSeconds
		case let .days(d):
			return Self.hours(24 * d).inSeconds
		}
	}
	public var asTimeInterval: TimeInterval {
		return TimeInterval(inSeconds)
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		let timeInterval = try container.decode(TimeInterval.self)
		self = .seconds(Int(timeInterval))
	}
	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(inSeconds)
	}

	public static func ==(lhs: Self, rhs: Self) -> Bool {
		return lhs.inSeconds == rhs.inSeconds
	}

	public static func <(lhs: Self, rhs: Self) -> Bool {
		return lhs.inSeconds < rhs.inSeconds
	}
}

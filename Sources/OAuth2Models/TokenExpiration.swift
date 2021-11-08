import Foundation

/// The duration that a token is valid.
public struct TokenExpiration: Codable, Equatable, Comparable {
	/// The seconds until the token expires.
	var seconds: Int

	/// Creates a ``TokenExpiration`` in seconds.
	/// - Parameter seconds: The number of seconds.
	public init(seconds: Int) {
		self.seconds = seconds
	}
}

// Convenience init
extension TokenExpiration {
	/// Creates a ``TokenExpiration`` in minutes.
	/// - Parameter minutes: The number of minutes.
	public init(minutes: Int) {
		self = .init(seconds: minutes * 60)
	}

	/// Creates a ``TokenExpiration`` in hours.
	/// - Parameter hours: The number of hours.
	public init(hours: Int) {
		self = .init(minutes: hours * 60)
	}

	/// Creates a ``TokenExpiration`` in days.
	/// - Parameter days: The number of days.
	public init(days: Int) {
		self = .init(hours: days * 24)
	}

	/// Creates a ``TokenExpiration`` based on a `Date`, relative to now.
	/// - Parameter date: The expiration date.
	public init(date: Date) {
		self.init(seconds: Int(date.timeIntervalSinceNow))
	}

	/// Creates a ``TokenExpiration`` in seconds.
	/// - Parameter seconds: The number of seconds.
	public static func seconds(_ seconds: Int) -> TokenExpiration {
		.init(seconds: seconds)
	}

	/// Creates a ``TokenExpiration`` in minutes.
	/// - Parameter minutes: The number of minutes.
	public static func minutes(_ minutes: Int) -> TokenExpiration {
		.init(minutes: minutes)
	}

	/// Creates a ``TokenExpiration`` in hours.
	/// - Parameter hours: The number of hours.
	public static func hours(_ hours: Int) -> TokenExpiration {
		.init(hours: hours)
	}

	/// Creates a ``TokenExpiration`` in days.
	/// - Parameter days: The number of days.
	public static func days(_ days: Int) -> TokenExpiration {
		.init(days: days)
	}

	/// Convenience instance for a ``TokenExpiration`` of a single hour.
	public static let oneHour: TokenExpiration = .hours(1)
	/// Convenience instance for an ``TokenExpiration`` of a single day.
	public static let oneDay: TokenExpiration = .days(1)
}

// Extracting data
extension TokenExpiration {
	/// Represents a direction that a date can be in.
	public enum RelativeDateDirection {
		/// Represents a date in the past.
		case thePast
		/// Represents a date in the future.
		case theFuture
	}

	///  Returns the date relative to now that the token would expire.
	///
	/// - Parameter direction: Whether the date should be in the future or in the past.
	///
	/// To check if a token with a registered creation date is expired, compare to a date in the past:
	/// ```
	/// let createDate = // Some date created previously, when the token was created
	/// let expiration = TokenExpiration.oneHour
	/// let isExpired = createDate < expiration.date(in: .thePast)
	/// ```
	///
	/// To register a date that a token would expire, create a date in the future instead:
	/// ```
	/// let expiration = TokenExpiration.oneHour
	/// let token = Token(expiresAt: expiration.date(in: .theFuture, payload: payload)
	/// ```
	public func date(in direction: RelativeDateDirection) -> Date {
		switch direction {
		case .thePast:
			return Date(timeIntervalSinceNow: -asTimeInterval)
		case .theFuture:
			return Date(timeIntervalSinceNow: asTimeInterval)
		}
	}

	/// Returns the expiration in full seconds.
	public var inSeconds: Int { seconds }

	/// Returns the expiration as a `TimeInterval`.
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

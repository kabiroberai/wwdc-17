import CoreGraphics

/// A representation of a two dimensional point
public struct Point {
	
	public var x: Double
	public var y: Double
	
	/// A `Point` with its x and y values set to 0
	public static let zero = Point(x: 0, y: 0)
	
	var cgPoint: CGPoint {
		return CGPoint(x: x, y: y)
	}
	
	var cgVector: CGVector {
		return CGVector(dx: x, dy: y)
	}
	
	public init(x: Double, y: Double) {
		self.x = x
		self.y = y
	}
	
	public init(x: Int, y: Int) {
		self.init(x: Double(x), y: Double(y))
	}
	
	/// Create a Point of `length` = 1, with the given angle
	public init(angle: Double) {
		self.init(x: cos(angle), y: sin(angle))
	}
	
	init(_ cgPoint: CGPoint) {
		self.init(x: Double(cgPoint.x), y: Double(cgPoint.y))
	}
	
	init(_ cgVector: CGVector) {
		self.init(x: Double(cgVector.dx), y: Double(cgVector.dy))
	}
	
	/// The length of the Point from (0, 0)
	public var length: Double {
		return sqrt((x * x) + (y * y))
	}
	
	/// The angle formed between the point and the X axis
	public var angle: Double {
		return atan2(y, x)
	}
	
	/// A point with the same angle as the receiver, but unit length
	public var normalized: Point {
		return self / length
	}
	
}

public extension Point {
	
	/// Returns the center of a rect with the receiver as the origin and the size as the passed in argument
	func centered(in size: Size) -> Point {
		return Point(x: x + size.width / 2, y: y + size.height / 2)
	}
	
	/// Returns the origin of a rect with the receiver as the center and the size as the passed in argument
	func origin(in size: Size) -> Point {
		return Point(x: x - size.width / 2, y: y - size.height / 2)
	}
	
}

public extension CGPoint {
	
	/// Returns the center of a rect with the receiver as the origin and the size as the passed in argument
	func centered(in size: CGSize) -> CGPoint {
		return Point(self).centered(in: Size(size)).cgPoint
	}
	
	/// Returns the origin of a rect with the receiver as the center and the size as the passed in argument
	func origin(in size: CGSize) -> CGPoint {
		return Point(self).origin(in: Size(size)).cgPoint
	}
	
}

public func + (lhs: Point, rhs: Point) -> Point {
	return Point(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

public func += (lhs: inout Point, rhs: Point) {
	lhs = lhs + rhs
}


public func - (lhs: Point, rhs: Point) -> Point {
	return Point(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}

public func -= (lhs: inout Point, rhs: Point) {
	lhs = lhs - rhs
}


public func * (lhs: Point, rhs: Point) -> Point {
	return Point(x: lhs.x * rhs.x, y: lhs.y * rhs.y)
}

public func * (lhs: Point, rhs: Double) -> Point {
	return Point(x: lhs.x * rhs, y: lhs.y * rhs)
}

public func *= (lhs: inout Point, rhs: Point) {
	lhs = lhs * rhs
}

public func *= (lhs: inout Point, rhs: Double) {
	lhs = lhs * rhs
}


public func / (lhs: Point, rhs: Point) -> Point {
	return Point(x: lhs.x / rhs.x, y: lhs.y / rhs.y)
}

public func / (lhs: Point, rhs: Double) -> Point {
	return Point(x: lhs.x / rhs, y: lhs.y / rhs)
}

public func /= (lhs: inout Point, rhs: Point) {
	lhs = lhs / rhs
}

public func /= (lhs: inout Point, rhs: Double) {
	lhs = lhs / rhs
}


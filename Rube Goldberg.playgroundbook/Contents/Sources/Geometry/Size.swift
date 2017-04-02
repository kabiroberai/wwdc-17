import CoreGraphics

/// A representation of a two dimensional size
public struct Size {
	
	public var width: Double
	public var height: Double
	
	/// A `Size` with its width and height set to 0
	public static let zero = Size(width: 0, height: 0)
	
	var cgSize: CGSize {
		return CGSize(width: width, height: height)
	}
	
	public init(width: Double, height: Double) {
		self.width = width
		self.height = height
	}
	
	public init(width: Int, height: Int) {
		self.init(width: Double(width), height: Double(height))
	}
	
	init(_ cgSize: CGSize) {
		self.init(width: Double(cgSize.width), height: Double(cgSize.height))
	}
	
}

public extension Size {
	
	/// Aspect scales the receiver to `other`'s size, filling or fitting depending on the value of `fill`
	///
	/// - Parameter other: The bounding rectangle in which the receiver should be scaled
	///
	/// - Parameter fill: Determines whether the receiver should fill or fit the bounding rectangle
	func aspectScaled(to other: Size, fill: Bool) -> Size {
		let aspectRatio = width / height
		let otherAspectRatio = other.width / other.height
		let greaterWidth = (aspectRatio > otherAspectRatio)
		if greaterWidth == fill { // true if (greater width and fill), or (greater height and fit)
			return Size(width: other.height * aspectRatio,
			            height: other.height)
		} else {
			return Size(width: other.width,
			            height: other.width / aspectRatio)
		}
	}
	
	mutating func aspectScale(to other: Size, fill: Bool) {
		self = aspectScaled(to: other, fill: fill)
	}
	
}

extension CGSize {
	
	func aspectScaled(to other: CGSize, fill: Bool) -> CGSize {
		return Size(self).aspectScaled(to: Size(other), fill: fill).cgSize
	}
	
}

public func / (lhs: Size, rhs: Double) -> Size {
	return Size(width: lhs.width / rhs, height: lhs.height / rhs)
}

public func /= (lhs: inout Size, rhs: Double) {
	lhs = lhs / rhs
}


public func * (lhs: Size, rhs: Double) -> Size {
	return Size(width: lhs.width * rhs, height: lhs.height * rhs)
}

public func *= (lhs: inout Size, rhs: Double) {
	lhs = lhs * rhs
}

func * (lhs: CGSize, rhs: CGFloat) -> CGSize {
	return CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
}

import CoreGraphics

/// A rectangle with a particular size and origin
public struct Rect {
	
	public var origin: Point
	
	public var x: Double {
		get { return origin.x }
		set { origin.x = newValue }
	}
	
	public var y: Double {
		get { return origin.y }
		set { origin.y = newValue }
	}
	
	
	public var size: Size
	
	public var width: Double {
		get { return size.width }
		set { size.width = newValue }
	}
	
	public var height: Double {
		get { return size.height }
		set { size.height = newValue }
	}
	
	/// A rectangle with its origin at (0, 0) and size set to zero
	public static let zero = Rect(origin: .zero, size: .zero)
	
	
	var cgRect: CGRect {
		return CGRect(origin: origin.cgPoint, size: size.cgSize)
	}
	
	public var minX: Double { return Double(cgRect.minX) }
	public var midX: Double { return Double(cgRect.midX) }
	public var maxX: Double { return Double(cgRect.maxX) }
	
	public var minY: Double { return Double(cgRect.minY) }
	public var midY: Double { return Double(cgRect.midY) }
	public var maxY: Double { return Double(cgRect.maxY) }
	
	public var center: Point { return Point(x: midX, y: midY) }
	
	public init(origin: Point, size: Size) {
		self.origin = origin
		self.size = size
	}
	
	public init(x: Double, y: Double, width: Double, height: Double) {
		self.init(origin: Point(x: x, y: y), size: Size(width: width, height: height))
	}
	
	public init(x: Int, y: Int, width: Int, height: Int) {
		self.init(x: Double(x), y: Double(y), width: Double(width), height: Double(height))
	}
	
	init(_ cgRect: CGRect) {
		self.init(origin: Point(cgRect.origin), size: Size(cgRect.size))
	}
	
}

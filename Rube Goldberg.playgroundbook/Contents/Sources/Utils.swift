import SpriteKit

public extension Double {
	/// Converts the receiver's value (in degrees) to radians
	var radians: Double { return self * .pi / 180 }
	/// Converts the receiver's value (in radians) to degrees
	var degrees: Double { return self * 180 / .pi }
}

public extension CGFloat {
	/// Converts the receiver's value (in degrees) to radians
	var radians: CGFloat { return self * .pi / 180 }
	/// Converts the receiver's value (in radians) to degrees
	var degrees: CGFloat { return self * 180 / .pi }
}

/// Run an action after a fixed amount of time
///
/// - Parameter seconds: The time (in seconds) after which the action should execute
///
/// - Parameter execute: The action to execute
public func delay(seconds: TimeInterval, execute: @escaping () -> Void) {
	DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: execute)
}

public extension UIImage {
	
	/// Create a `UIImage` gradient with the specified values
	///
	/// - Parameter size: The size of the image/gradient
	///
	/// - Parameter colors: The array of colors to use in the gradient
	///
	/// - Parameter locations: An optional array of numbers defining the location of each gradient stop, increasing from 0 to 1. The default value is `nil`
	///
	/// - Parameter start: The start point of the gradient. Defaults to (0.5, 0)
	///
	/// - Parameter end: The end point of the gradient. Defaults to (0.5, 1)
	static func gradient(of size: Size,
	                     colors: [UIColor],
	                     locations: [Double]? = nil,
	                     start: Point = Point(x: 0.5, y: 0),
	                     end: Point = Point(x: 0.5, y: 1)) -> UIImage {
		let layer = CAGradientLayer()
		layer.frame.size = size.cgSize
		layer.colors = colors.map { $0.cgColor }
		layer.locations = locations?.map(NSNumber.init(value:))
		layer.startPoint = start.cgPoint
		layer.endPoint = end.cgPoint
		
		UIGraphicsBeginImageContext(size.cgSize)
		layer.render(in: UIGraphicsGetCurrentContext()!)
		let image = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		return image
	}
	
}

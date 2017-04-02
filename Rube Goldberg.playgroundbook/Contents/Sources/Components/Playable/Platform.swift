import SpriteKit

/// A thin, rectangular component with a specified `start` and `end`
public class Platform: Shape {
	
	/// An enumeration which defines the various modes with which the corners of the platform may be rounded
	public enum RoundingMode {
		/// Do not round the platform at all
		case none
		/// Round the platform's corners, with the rounded portion _inside_ its bounds
		case inside
		/// Round the platform's corners, with the rounded portion _outside_ its bounds
		case outside
		/// True if the platform's corners are rounded
		var isRounded: Bool { return self != .none }
	}
	
	/// An enumeration which defines the various modes with which the platform may be pinned
	public enum PinningMode {
		/// Do not pin the platform at all
		case none
		/// Pin the platform at the center
		case center
		/// Pin the platform at the start point
		case start
		/// True if the platform is pinned
		var isPinned: Bool { return self != .none }
	}
	
	public override var position: Point {
		get { return frame.center }
		set {
			let change = newValue - super.position
			start += change
			end += change
			nails.forEach { $0.position += change }
			super.position = newValue
		}
	}
	
	public override var frame: Rect {
		let size = super.frame.size
		let origin = Point(x: start.x, y: start.y - size.height / 2)
		return Rect(origin: origin, size: size)
	}
	
	let change: Point
	let cornerRadius: CGFloat
	let startCenter: CGPoint
	let endCenter: CGPoint
	
	var nails: [Sprite] = []
	
	/// The calculated start point of the platform
	///
	/// - Note: This may not be the same as the `start` value specified in `init` if the `position` property has been changed or if `roundingMode` was set to `.outside`
	public var start: Point
	
	/// The calculated end point of the platform
	///
	/// - Note: This may not be the same as the `end` value specified in `init` if the `position` property has been changed or if `roundingMode` was set to `.outside`
	public var end: Point
	
	/// The thickness of the platform, as specified in `init`
	public let thickness: Double
	
	/// The mode with which to round the Platorm's corners
	public let roundingMode: RoundingMode
	
	/// The platform's pinning mode
	public let pinningMode: PinningMode
	
	/// Create a new platform
	///
	/// - Parameter start: The start point of the platform. If `roundingMode` is set to `.outside`, this specifies the start point of the platform's non-rounded portion
	///
	/// - Parameter end: The end point of the platform. If `roundingMode` is set to `.outside`, this specifies the end point of the platform's non-rounded portion
	///
	/// - Parameter thickness: The thickness of the platform (i.e. its height). The default value is 10
	///
	/// - Parameter roundingMode: The mode with which to round the Platorm's corners. The default value is `.inside`
	///
	/// - Parameter pinningMode: The platform's pinning mode. The default value is `.none`
	public init(start: Point, end: Point, thickness: Double = 10, roundingMode: RoundingMode = .inside, pinningMode: PinningMode = .none) {
		self.thickness = thickness
		self.roundingMode = roundingMode
		self.pinningMode = pinningMode
		cornerRadius = roundingMode.isRounded ? CGFloat(thickness / 2) : 0
		var finalStart = start
		var finalEnd = end
		if roundingMode == .outside {
			let adjusted = Platform.inset(start: start, end: end, by: Double(cornerRadius))
			finalStart = adjusted.start
			finalEnd = adjusted.end
		}
		self.start = finalStart
		self.end = finalEnd
		change = finalEnd - finalStart
		let length = change.length
		let angle = change.angle
		let rect = Rect(x: 0, y: -thickness / 2, width: length, height: thickness)
		let cornerDiameter = cornerRadius * 2
		let rectPath = CGPath(roundedRect: rect.cgRect, cornerWidth: cornerRadius, cornerHeight: cornerRadius, transform: nil)
		let shapeNode = SKShapeNode(path: rectPath, centered: pinningMode != .start)
		let size = Size(width: rect.size.width - Double(cornerDiameter), height: rect.size.height).cgSize
		let startOffset = pinningMode == .start ? rect.size.cgSize.width / 2 - cornerRadius : 0
		let mainPhysicsBody = SKPhysicsBody(rectangleOf: size, center: CGPoint(x: startOffset, y: 0))
		
		var bodies = [mainPhysicsBody]
		
		startCenter = CGPoint(x: startOffset - CGFloat(length) / 2 + cornerRadius, y: 0)
		endCenter = CGPoint(x: startOffset + CGFloat(length) / 2 - cornerRadius, y: 0)
		if roundingMode.isRounded {
			let startCircle = SKPhysicsBody(circleOfRadius: cornerRadius, center: startCenter)
			let endCircle = SKPhysicsBody(circleOfRadius: cornerRadius, center: endCenter)
			
			bodies.append(startCircle)
			bodies.append(endCircle)
		}
		
		let physicsBody = SKPhysicsBody(bodies: bodies)
		super.init(node: shapeNode, physicsBody: physicsBody)
		rotation = angle
	}
	
	static func inset(start: Point, end: Point, by inset: Double) -> (start: Point, end: Point) {
		let change = end - start
		let unitChange = change.normalized
		let adjustment = unitChange * inset
		return (start: start - adjustment, end: end + adjustment)
	}
	
	override func configureNode() {
		super.configureNode()
		texture = .gradient(of: frame.size, colors: [#colorLiteral(red: 0.2431372549, green: 0.3647058824, blue: 0.6549019608, alpha: 1), #colorLiteral(red: 0.2274509804, green: 0.2941176471, blue: 0.6117647059, alpha: 1)])
		
		if pinningMode == .start {
			node.position = start.cgPoint
			shapeNode.position.x -= cornerRadius
			spriteNode.position.x += CGFloat(change.length) / 2 - cornerRadius
		} else {
			node.position = start.centered(in: Size(width: change.x, height: change.y)).cgPoint
		}
		
		let image = UIImage(named: "Nail.png")!
		let diameter = thickness + 2.5
		let size = Size(width: diameter, height: diameter)
		if pinningMode.isPinned {
			let nail = Sprite(image: image, size: size)
			nail.position = Point(node.position)
			nails = [nail]
		} else {
			let insetAmount: Double = -30
			let totalInset = roundingMode == .outside ? insetAmount : (Double(cornerRadius) + insetAmount)
			let adjusted = Platform.inset(start: start, end: end, by: totalInset)
			
			let startNail = Sprite(image: image, size: size)
			startNail.position = adjusted.start
			
			let endNail = Sprite(image: image, size: size)
			endNail.position = adjusted.end
			
			nails = [startNail, endNail]
		}
	}
	
	override func configurePhysicsBody() {
		super.configurePhysicsBody()
		isDynamic = pinningMode.isPinned
		physicsBody?.category = .ground
		if pinningMode.isPinned {
			physicsBody?.category.insert(.movingPlatform)
		}
		physicsBody?.pinned = pinningMode.isPinned
	}
	
}

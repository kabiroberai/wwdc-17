import SpriteKit

/// Any part of the Rube Goldberg machine
///
/// - Warning: Do not use this class directly, instead use one of its subclasses
public class Component {
	
	let node: SKNode
	
	var physicsBody: SKPhysicsBody? {
		didSet {
			node.physicsBody = physicsBody
			configurePhysicsBody()
		}
	}
	
	/// Controls whether the component can be moved
	public var isDynamic: Bool {
		get { return node.physicsBody?.isDynamic ?? false }
		set { node.physicsBody?.isDynamic = newValue }
	}
	
	/// The bounding box of the component in the scene's coordinate system
	public var frame: Rect {
		return Rect(node.frame)
	}
	
	/// The position of the component's center in the scene
	public var position: Point {
		get { return Point(node.position) }
		set { node.position = newValue.cgPoint }
	}
	
	/// The component's rotation (in radians)
	public var rotation: Double {
		get { return Double(node.zRotation) }
		set { node.zRotation = CGFloat(newValue) }
	}
	
	/// The component's rotation (in degrees)
	public var rotationDegrees: Double {
		get { return rotation.degrees }
		set { rotation = newValue.radians }
	}
	
	/// Controls whether the component takes part in the simulation. If false, it will be ignored entirely
	public var isInteractive: Bool {
		get { return node.physicsBody != nil }
		set { node.physicsBody = newValue ? physicsBody : nil }
	}
	
	/// Sets the component's X and Y scales to `scale`
	///
	/// - Parameter scale: The scale to set
	public func setScale(_ scale: Double) {
		node.setScale(CGFloat(scale))
	}
	
	init(node: SKNode, physicsBody: SKPhysicsBody?) {
		self.node = node
		node.position = Game.current.frame.center.cgPoint
		addToGame()
		self.physicsBody = physicsBody
		node.physicsBody = physicsBody
		configurePhysicsBody()
		
		configureNode()
	}
	
	func configureNode() {}
	
	func configurePhysicsBody() {
		node.physicsBody?.contactTestCategory = .all
		node.physicsBody?.category = .component
	}
	
	
	func didBegin(_ contact: SKPhysicsContact, with otherBody: SKPhysicsBody) {}
	
	func didEnd(_ contact: SKPhysicsContact, with otherBody: SKPhysicsBody) {}
	
	func update(_ currentTime: TimeInterval) {}
	
	public func addToGame() {
		guard node.scene == nil else { return }
		Game.current.scene.addChild(node)
		Game.current.components.append(self)
	}
	
	public func remove() {
		node.removeFromParent()
		Game.current.components = Game.current.components.filter { $0 !== self }
	}
	
}

extension SKNode {
	
	var component: Component? {
		return Game.current.components.filter { $0.node == self }.first
	}
	
}

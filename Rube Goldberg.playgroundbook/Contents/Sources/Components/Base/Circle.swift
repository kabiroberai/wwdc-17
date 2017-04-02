import SpriteKit

/// A circular component with a fixed radius
///
/// - Warning: Do not use this class directly. Rather, use one of its various `ball` subclasses
public class Circle: Shape {
	
	let soundEffect = SoundEffect(fileNamed: "Thud.mp3")
	let soundThreshold: CGFloat = 8
	
	public init(radius: Double) {
		let radius = CGFloat(radius)
		let node = SKShapeNode(circleOfRadius: radius)
		let physicsBody = SKPhysicsBody(circleOfRadius: radius)
		super.init(node: node, physicsBody: physicsBody)
	}
	
	override func configureNode() {
		super.configureNode()
		color = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
	}
	
	override func didBegin(_ contact: SKPhysicsContact, with otherBody: SKPhysicsBody) {
		super.didBegin(contact, with: otherBody)
		if contact.collisionImpulse >= soundThreshold {
			soundEffect.play()
		}
	}
	
}

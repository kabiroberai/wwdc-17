import SpriteKit

/// A hollow jar that shatters on impact
public class Jar: Sprite, GoalSettable, ActionHandling {
	
	public var isGoal = false
	var actionHandler: ActionHandler?
	
	let collisionThreshold: CGFloat = 0.7
	let soundEffect = SoundEffect(fileNamed: "Shatter.mp3")
	
	let scale: CGFloat = 1/25
	
	public init() {
		let texture = SKTexture(imageNamed: "Jar.png")
		let size = texture.size() * scale
		let node = SKSpriteNode(texture: texture, size: size)
		let bodyTexture = SKTexture(imageNamed: "Jar Shape.png")
		let physicsBody = SKPhysicsBody(texture: bodyTexture, size: size)
		super.init(node: node, physicsBody: physicsBody)
	}
	
	override func didBegin(_ contact: SKPhysicsContact, with otherBody: SKPhysicsBody) {
		super.didBegin(contact, with: otherBody)
		if contact.collisionImpulse >= collisionThreshold {
			isInteractive = false
			let texture = SKTexture(imageNamed: "Jar Shatter.png")
			spriteNode.texture = texture
			spriteNode.size = texture.size() * scale
			soundEffect.play()
			node.run(.sequence([
				.group([
					.scale(to: 1.2, duration: 0.5),
					.fadeOut(withDuration: 0.5)
				]),
				.run(self.remove)
			]))
			finishIfGoal()
			actionHandler?()
		}
	}
	
}

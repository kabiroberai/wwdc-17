import SpriteKit

/// An abstract class with the attribute of bounciness
///
/// - Warning: Do not use this class directly, instead use one of its subclasses (`Spring` or `Trampoline`)
public class Bouncy: Sprite {
	
	var absorption: Double = 1
	var compressionAmount: CGFloat = 0
	var soundEffect = SoundEffect(fileNamed: "Boing.mp3")
	
	let soundThreshold: CGFloat = 5
	
	override func didBegin(_ contact: SKPhysicsContact, with otherBody: SKPhysicsBody) {
		super.didBegin(contact, with: otherBody)
		guard !otherBody.category.contains(.ground) else { return }
		let angle = -rotation + 90.radians
		let unitVector = Point(angle: angle)
		let vector = unitVector * Double(contact.collisionImpulse) / absorption
		otherBody.applyImpulse(vector.cgVector)
		
		let compressed: CGFloat = 1 - compressionAmount
		let totalDuration: TimeInterval = 0.2
		
		let scaleDownAction: SKAction = .scaleX(to: 1, y: compressed, duration: totalDuration / 2)
		let scaleUpAction: SKAction = .scaleX(to: 1, y: 1, duration: totalDuration / 2)
		
		let directionVector = Point(angle: -angle)
		let lengthVector = directionVector * (size.height)
		let movementVector = lengthVector * Double(1 - compressed) / 2
		
		let moveDownAction: SKAction = .move(by: movementVector.cgVector, duration: totalDuration / 2)
		let moveUpAction = moveDownAction.reversed()
		
		let downAction: SKAction = .group([scaleDownAction, moveDownAction])
		let upAction: SKAction = .group([scaleUpAction, moveUpAction])
		
		node.run(.sequence([downAction, upAction]))
		
		if contact.collisionImpulse > soundThreshold {
			soundEffect.play()
		}
	}
	
}

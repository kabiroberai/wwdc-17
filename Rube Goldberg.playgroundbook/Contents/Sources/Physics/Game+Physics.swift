import SpriteKit

extension Game: SKPhysicsContactDelegate {
	
	public func didBegin(_ contact: SKPhysicsContact) {
		let bodyA = contact.bodyA
		let bodyB = contact.bodyB
		
		bodyA.node?.component?.didBegin(contact, with: bodyB)
		bodyB.node?.component?.didBegin(contact, with: bodyA)
	}
	
	public func didEnd(_ contact: SKPhysicsContact) {
		let bodyA = contact.bodyA
		let bodyB = contact.bodyB
		
		bodyA.node?.component?.didEnd(contact, with: bodyB)
		bodyB.node?.component?.didEnd(contact, with: bodyA)
	}
	
}

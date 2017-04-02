import SpriteKit

class GameScene: SKScene {
		
	override func update(_ currentTime: TimeInterval) {
		super.update(currentTime)
		Game.current.components.forEach { $0.update(currentTime) }
	}
	
}

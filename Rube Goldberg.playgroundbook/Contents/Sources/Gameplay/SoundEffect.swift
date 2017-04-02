import SpriteKit

struct SoundEffect {
	
	private let action: SKAction
	
	init(fileNamed filename: String) {
		action = .playSoundFileNamed(filename, waitForCompletion: false)
	}
	
	func play() {
		Game.current.scene.run(action)
	}
	
}

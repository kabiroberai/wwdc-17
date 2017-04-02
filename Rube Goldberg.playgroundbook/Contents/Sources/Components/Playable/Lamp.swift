import SpriteKit

/// A lamp which turns on when it collides with another (non-ground) component
public class Lamp: Sprite, GoalSettable, ActionHandling {
	
	public var isGoal = false
	var actionHandler: ActionHandler?
	
	public private(set) var isOn = false
	
	let pingEffect = SoundEffect(fileNamed: "Glass Ping.mp3") // Preload the sound effect
	
	let scale: CGFloat = 1/5
	
	let direction: Direction
	
	public init(facing direction: Direction) {
		self.direction = direction
		let texture = SKTexture(imageNamed: "Lamp Off.png")
		let size = texture.size() * scale
		let node = SKSpriteNode(texture: texture, size: size)
		let body = SKPhysicsBody(texture: SKTexture(imageNamed: "Lamp Shape.png"), size: size)
		super.init(node: node, physicsBody: body)
	}
	
	override func configureNode() {
		super.configureNode()
		if direction == .left {
			node.xScale = -1
		}
	}
	
	override func configurePhysicsBody() {
		super.configurePhysicsBody()
		isDynamic = false
	}
	
	override func didBegin(_ contact: SKPhysicsContact, with otherBody: SKPhysicsBody) {
		super.didBegin(contact, with: otherBody)
		turnOn()
	}
	
	func turnOn() {
		guard !isOn else { return }
		isOn = true
		let textures = ["Lamp Burst.png", "Lamp On.png"].map(SKTexture.init)
		node.run(.animate(with: textures, timePerFrame: 0.2))
		pingEffect.play()
		finishIfGoal()
		actionHandler?()
	}
	
}

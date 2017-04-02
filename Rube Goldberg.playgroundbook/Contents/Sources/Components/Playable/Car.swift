import SpriteKit

public enum Direction: CGFloat {
	
	case left = -1
	case right = 1
	
	internal var modifier: String {
		return self == .left ? " Flipped" : ""
	}
	
}

/// A car which moves in the specifieed direction when hit
public class Car: Sprite, GoalSettable, ActionHandling {
	
	public var isGoal = false
	var actionHandler: ActionHandler?
	
	let moveThreshold: CGFloat = 0.2
	let speed: CGFloat = 100
	
	var direction: Direction
	var shouldMove = false
	var isMoving = false
	
	let smokeEmitter: SKEmitterNode
	let initialParticleBirthRate: CGFloat
	
	let soundEffect = SoundEffect(fileNamed: "Car Start.mp3")
	
	/// An enumeration which defines the available colors for the Car component
	public enum Color: String {
		case red = "Red"
		case blue = "Blue"
	}
	
	/// The color of this car, randomly selected from the `Color` enumeration
	public let carColor: Color
	
	/// Initialise a new Car
	///
	/// - Parameter direction: The direction which the car should face and drive in. This cannot be changed after initialization
	public init(facing direction: Direction) {
		self.direction = direction
		carColor = arc4random_uniform(2) == 0 ? .red : .blue
		
		let scale: CGFloat = 1/3
		let texture = SKTexture(imageNamed: "Car \(carColor.rawValue).png")
		let size = texture.size() * scale
		let node = SKSpriteNode(texture: texture, size: size)
		node.xScale = direction.rawValue
		
		let bodyTexture = SKTexture(imageNamed: "Car Shape.png")
		let mainPhysicsBody = SKPhysicsBody(texture: bodyTexture, size: size)
		
		let r: CGFloat = 24 * scale
		let xOffset: CGFloat = -size.width / 2 + r
		let yOffset: CGFloat = -size.height / 2 + r
		
		let pos1rel: CGFloat = 28 * scale
		let pos2rel: CGFloat = 219 * scale
		
		var pos1 = CGPoint(x: xOffset + pos1rel, y: yOffset)
		var pos2 = CGPoint(x: xOffset + pos2rel, y: yOffset)
		
		if direction == .left {
			let oldPos1 = pos1.x
			pos1.x = pos2.x + 8 * scale
			pos2.x = oldPos1 + 8 * scale
		}
		
		let wheel1 = SKPhysicsBody(circleOfRadius: r, center: pos1)
		let wheel2 = SKPhysicsBody(circleOfRadius: r, center: pos2)
		
		let physicsBody = SKPhysicsBody(bodies: [mainPhysicsBody, wheel1, wheel2])
		
		smokeEmitter = SKEmitterNode(fileNamed: "Smoke")!
		smokeEmitter.position = CGPoint(x: -size.width / 2, y: 0)
		
		initialParticleBirthRate = smokeEmitter.particleBirthRate
		
		super.init(node: node, physicsBody: physicsBody)
	}
	
	/// Manually start the car's state of rest or motion
	public func toggleMovement() {
		shouldMove = !shouldMove
		if shouldMove {
			finishIfGoal()
		}
	}
	
	override func configurePhysicsBody() {
		super.configurePhysicsBody()
		physicsBody?.density = 1
		physicsBody?.allowsRotation = false
	}
	
	override func configureNode() {
		super.configureNode()
		node.addChild(smokeEmitter)
	}
	
	override func didBegin(_ contact: SKPhysicsContact, with otherBody: SKPhysicsBody) {
		super.didBegin(contact, with: otherBody)
		if contact.collisionImpulse >= moveThreshold && otherBody.category != .ground {
			toggleMovement()
			actionHandler?()
		}
	}
	
	override func update(_ currentTime: TimeInterval) {
		super.update(currentTime)
		defer { isMoving = shouldMove }
		if shouldMove {
			if !isMoving { // Just started moving
				soundEffect.play()
			}
			physicsBody?.velocity.dx = speed * direction.rawValue
			smokeEmitter.particleBirthRate = initialParticleBirthRate
		} else {
			smokeEmitter.particleBirthRate = 0
		}
	}
	
}

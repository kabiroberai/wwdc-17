import SpriteKit

/// A mouse which follows the `Cheese` nearest to it
public class Mouse: Sprite {
	
	let speed: CGFloat = 150
	
	let bodySize: CGSize
	
	var lastDirection: Direction = .right
	
	let chompSoundEffect = SoundEffect(fileNamed: "Chomp.mp3")
	let squeakSoundEffect = SoundEffect(fileNamed: "Squeak.mp3")
	
	var lastUpdateTime: TimeInterval = 0
	var timeSinceLastSqueak: TimeInterval = 0.5
	let squeakTime: TimeInterval = 1
	
	let textures: [SKTexture]
	let frameTime: TimeInterval = 0.5
	
	public init() {
		let scale: CGFloat = 1/15
		textures = (1...2).map { SKTexture(imageNamed: "Mouse \($0).png") }
		let texture = textures[0]
		let size = texture.size() * scale
		let node = SKSpriteNode(texture: texture, size: size)
		bodySize = CGSize(width: 1150, height: 750) * scale
		super.init(node: node, physicsBody: nil)
		physicsBody = makePhysicsBody(facing: lastDirection)
	}
	
	override func configureNode() {
		super.configureNode()
		let rotationLimit: CGFloat = 45
		let rotationConstraint: SKConstraint = .zRotation(SKRange(lowerLimit: -rotationLimit.radians, upperLimit: rotationLimit.radians))
		node.constraints = [rotationConstraint]
		
		node.run(.repeatForever(.animate(with: textures, timePerFrame: frameTime)))
	}
	
	func makePhysicsBody(facing direction: Direction) -> SKPhysicsBody {
		let xOffset = size.cgSize.width / 2 - bodySize.width / 2
		let yOffset = bodySize.height / 2 - size.cgSize.height / 2
		let center = CGPoint(x: xOffset * direction.rawValue, y: yOffset)
		return SKPhysicsBody(rectangleOf: bodySize, center: center)
	}
	
	override func update(_ currentTime: TimeInterval) {
		super.update(currentTime)
		
		let dt: TimeInterval
		if lastUpdateTime == 0 {
			dt = 0
		} else {
			dt = currentTime - lastUpdateTime
		}
		lastUpdateTime = currentTime
		
		func absDistance(to point: Point) -> Double {
			return abs((point - position).length)
		}
		
		// Get the nearest cheese
		let nearestCheese = Game.current.components
			.flatMap { $0 as? Cheese }
			.min { absDistance(to: $0.position) < absDistance(to: $1.position) }
		
		let contactBodies = physicsBody?.allContactedBodies()
		
		node.speed = 0
		
		guard let cheese = nearestCheese else { return }
		
		if contactBodies?.isEmpty == false {
			node.speed = 1 // Enable the animation
			physicsBody?.velocity.dx = (cheese.position.x > position.x) ? speed : -speed
			timeSinceLastSqueak += dt
			if timeSinceLastSqueak > squeakTime {
				timeSinceLastSqueak = 0
				squeakSoundEffect.play()
			}
		} else {
			physicsBody?.velocity.dx = 0
		}
		
		let direction: Direction = (cheese.position.x < position.x) ? .left : .right
		if lastDirection != direction {
			lastDirection = direction
			node.xScale = direction.rawValue
			physicsBody = makePhysicsBody(facing: direction)
		}
	}
	
	override func didBegin(_ contact: SKPhysicsContact, with otherBody: SKPhysicsBody) {
		super.didBegin(contact, with: otherBody)
		guard let cheese = otherBody.node?.component as? Cheese, !cheese.hasBeenEaten else { return }
		cheese.hasBeenEaten = true
		cheese.node.run(.sequence([
			.scale(to: 0, duration: 0.1),
			.run(cheese.remove)
		]))
		chompSoundEffect.play()
	}
	
}

/// A piece of cheese which may be followed and eaten by a `Mouse`
public class Cheese: Sprite {
	
	var hasBeenEaten = false
	
	let direction: Direction
	
	/// Create a new `Cheese`
	///
	/// - Parameter direction: The direction which the cheese should face. Only for visual effect
	public init(facing direction: Direction) {
		self.direction = direction
		let scale: CGFloat = 1/10
		let texture = SKTexture(imageNamed: "Cheese.png")
		let size = texture.size() * scale
		let node = SKSpriteNode(texture: texture, size: size)
		let physicsBody = SKPhysicsBody(rectangleOf: size)
		super.init(node: node, physicsBody: physicsBody)
	}
	
	override func configureNode() {
		super.configureNode()
		if direction == .left {
			node.xScale = -1
		}
	}
	
}

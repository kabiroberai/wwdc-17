import SpriteKit

/// A single randomly/procedurally generated domino, pinned at the bottom
public class Domino: Shape, GoalSettable, ActionHandling {
	
	public var isGoal = false
	var actionHandler: ActionHandler?
	
	let side: CGFloat = 20
	let cornerRadius: CGFloat = 5
	let dotRadius: CGFloat = 2
	let positionMultiplier: Double = 5
	let offset: CGFloat = 10
	
	let adjustment: CGFloat
	
	var joint: SKPhysicsJointPin?
	
	let soundEffect = SoundEffect(fileNamed: "Domino.mp3")
	
	public override var position: Point {
		get { return Point(x: super.position.x, y: super.position.y + Double(adjustment)) }
		set {
			super.position = Point(x: newValue.x, y: newValue.y - Double(adjustment))
			createPinJoint()
		}
	}
	
	public init() {
		adjustment = side + offset
		let rect = CGRect(x: -side / 2, y: offset, width: side, height: side * 2)
		let path = CGPath(roundedRect: rect, cornerWidth: cornerRadius, cornerHeight: cornerRadius, transform: nil)
		let node = SKShapeNode(path: path)
		let physicsBody = SKPhysicsBody(rectangleOf: rect.size, center: CGPoint(x: 0, y: adjustment))
		super.init(node: node, physicsBody: physicsBody)
	}
	
	override func configureNode() {
		super.configureNode()
		
		node.zPosition = -1
		
		spriteNode.position.y = adjustment
		
		let lineWidth: CGFloat = 1
		let borderWidth: CGFloat = 2
		
		shapeNode.lineWidth = borderWidth
		shapeNode.strokeColor = .black
		// shapeNode doesn't render its texture since it's a mask, so create a copy that does
		let borderNode = shapeNode.copy() as! SKShapeNode
		borderNode.fillColor = .clear
		node.addChild(borderNode)
		
		let lineRect = CGRect(x: 0, y: 0, width: side - 4, height: lineWidth)
		let linePath = CGPath(rect: lineRect, transform: nil)
		let lineNode = SKShapeNode(path: linePath, centered: true)
		lineNode.fillColor = .black
		spriteNode.addChild(lineNode)
		
		// No images :)
		let dotPositions: [UInt32: [Point]] = [
			0: [],
			
			1: [.zero],
			
			2: [Point(x: -1, y: 1), Point(x: 1, y: -1)],
			
			3: [Point(x: -1, y: 1),
			    .zero,
			    Point(x: 1, y: -1)],
			
			4: [Point(x: -1, y: 1), Point(x: 1, y: 1),
				Point(x: -1, y: -1), Point(x: 1, y: -1)],
			
			5: [Point(x: 1, y: 1), Point(x: -1, y: 1),
				.zero,
				Point(x: -1, y: -1), Point(x: 1, y: -1)],
			
			6: [Point(x: -1, y: 1), Point(x: 1, y: 1),
			    Point(x: -1, y: 0), Point(x: 1, y: 0),
				Point(x: -1, y: -1), Point(x: 1, y: -1)]
		]
		
		var top: UInt32
		var bottom: UInt32
		
		repeat {
			top = arc4random_uniform(7)
			bottom = arc4random_uniform(7)
		} while top == 0 && bottom == 0 // We don't want both tiles to be blank
		
		let topDots = dotPositions[top]!
		let bottomDots = dotPositions[bottom]!
		
		let topDotsHandler = makeCircleHandler(yOffset: side / 2)
		let bottomDotsHandler = makeCircleHandler(yOffset: -side / 2)
		
		topDots.forEach(topDotsHandler)
		bottomDots.forEach(bottomDotsHandler)
	}
	
	override func didBegin(_ contact: SKPhysicsContact, with otherBody: SKPhysicsBody) {
		super.didBegin(contact, with: otherBody)
		if otherBody.category != .ground {
			soundEffect.play()
			finishIfGoal()
			actionHandler?()
		}
	}
	
	override func configurePhysicsBody() {
		super.configurePhysicsBody()
		physicsBody?.density = 0.1
		physicsBody?.collisionCategory.remove(.ground)
		createPinJoint()
	}
	
	func createPinJoint() {
		let scene = Game.current.scene
		if let joint = joint {
			// Remove the joint from the scene if it already exists
			scene.physicsWorld.remove(joint)
		}
		guard let body = physicsBody, let sceneBody = scene.physicsBody else { return }
		
		joint = .joint(withBodyA: sceneBody, bodyB: body, anchor: node.position)
		
		let limit: CGFloat = 45
		joint?.shouldEnableLimits = true
		joint?.lowerAngleLimit = -limit.radians
		joint?.upperAngleLimit = limit.radians
		joint?.frictionTorque = 0.0001 // So that it doesn't topple over automatically
		
		scene.physicsWorld.add(joint!)
	}
	
	func makeCircleHandler(yOffset: CGFloat) -> (Point) -> () { // Higher order function
		return { position in
			let circle = SKShapeNode(circleOfRadius: self.dotRadius)
			circle.position = (position * self.positionMultiplier).cgPoint
			circle.position.y += yOffset
			circle.strokeColor = .clear
			circle.fillColor = .black
			self.spriteNode.addChild(circle)
		}
	}
	
}

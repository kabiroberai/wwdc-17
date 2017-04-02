import SpriteKit

/// A Jack in the Box component which opens when hit
public class JackInTheBox: Sprite, GoalSettable, ActionHandling {
	
	public var isGoal = false
	var actionHandler: ActionHandler?
	
	public private(set) var isOpen = false
	
	let boxSize: CGSize
	
	let actionDuration = 0.25
	
	let initialJackScale: CGFloat = 0.5
	let jackNode: SKSpriteNode
	let jackBody: SKPhysicsBody
	
	let soundEffect = SoundEffect(fileNamed: "Ding.mp3")
	
	public init() {
		let scale: CGFloat = 1/4
		let texture = SKTexture(imageNamed: "Box.png")
		boxSize = texture.size() * scale
		
		let node = SKSpriteNode(texture: texture, size: boxSize)
		
		let physicsBody = SKPhysicsBody(rectangleOf: boxSize, center: .zero)
		
		let jackTexture = SKTexture(imageNamed: "Jack.png")
		let jackSize = jackTexture.size() * scale
		jackBody = SKPhysicsBody(rectangleOf: jackSize, center: .zero)
		jackNode = SKSpriteNode(texture: jackTexture, size: jackSize)
		
		super.init(node: node, physicsBody: physicsBody)
	}
	
	override func configureNode() {
		super.configureNode()
		jackNode.zPosition = -1
		jackNode.physicsBody = jackBody
		jackNode.physicsBody?.category = .jack
		jackNode.physicsBody?.isDynamic = false
		jackNode.setScale(initialJackScale)
		
		node.addChild(jackNode)
	}
	
	override func configurePhysicsBody() {
		super.configurePhysicsBody()
		physicsBody?.isDynamic = false
		physicsBody?.collisionCategory.remove(.jack)
		physicsBody?.contactTestCategory.remove(.jack)
	}
	
	/// Manually open the box
	public func open() {
		guard !isOpen else { return }
		isOpen = true
		
		jackNode.run(.group([
				.scale(to: 1, duration: actionDuration),
				.moveBy(x: 0, y: jackNode.size.height + jackNode.size.height * (1 - initialJackScale), duration: actionDuration)
		]))
		
		soundEffect.play()
		finishIfGoal()
		actionHandler?()
	}
	
	override func didBegin(_ contact: SKPhysicsContact, with otherBody: SKPhysicsBody) {
		super.didBegin(contact, with: otherBody)
		guard !otherBody.category.contains(.ground) else { return }
		open()
	}
	
}

import SpriteKit

public class Spring: Bouncy {
	
	var capSize: CGFloat = 3
	let sidesBody: SKPhysicsBody
	
	public init() {
		let scale: CGFloat = 1/5
		let texture = SKTexture(imageNamed: "Spring.png")
		let size = texture.size() * scale
		let node = SKSpriteNode(texture: texture, size: size)
		
		let bodySize = CGSize(width: size.width - capSize * 2, height: size.height)
		let body = SKPhysicsBody(rectangleOf: bodySize)
		
		let smallBodyOffset = size.width / 2 - capSize / 2
		let smallBodySize = CGSize(width: capSize, height: size.height)
		let leftBody = SKPhysicsBody(rectangleOf: smallBodySize, center: CGPoint(x: smallBodyOffset, y: 0))
		let rightBody = SKPhysicsBody(rectangleOf: smallBodySize, center: CGPoint(x: -smallBodyOffset, y: 0))
		sidesBody = SKPhysicsBody(bodies: [leftBody, rightBody])
		
		super.init(node: node, physicsBody: body)
		
		absorption = 1
		compressionAmount = 0.3
	}
	
	override func configureNode() {
		super.configureNode()
		node.zPosition = -1
		
		let sidesNode = SKNode()
		sidesNode.physicsBody = sidesBody
		sidesBody.isDynamic = false
		node.addChild(sidesNode)
	}
	
	override func configurePhysicsBody() {
		super.configurePhysicsBody()
		physicsBody?.isDynamic = false
	}
	
}

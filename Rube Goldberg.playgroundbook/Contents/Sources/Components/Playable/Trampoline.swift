import SpriteKit

public class Trampoline: Bouncy {
	
	let capSize: CGFloat = 3
	let offset: CGFloat = 265
	
	let sidesBody: SKPhysicsBody
	
	public init() {
		let scale: CGFloat = 1/5
		let texture = SKTexture(imageNamed: "Trampoline.png")
		let size = texture.size() * scale
		let node = SKSpriteNode(texture: texture, size: size)
		let mainBodySize = CGSize(width: size.width - capSize * 2, height: offset * scale)
		let mainBodyCenter = CGPoint(x: 0, y: mainBodySize.height / 2 - size.height / 2)
		let physicsBody = SKPhysicsBody(rectangleOf: mainBodySize, center: mainBodyCenter)
		
		let smallBodyOffset = size.width / 2 - capSize / 2
		let smallBodySize = CGSize(width: capSize, height: mainBodySize.height)
		let leftBody = SKPhysicsBody(rectangleOf: smallBodySize, center: CGPoint(x: smallBodyOffset, y: mainBodyCenter.y))
		let rightBody = SKPhysicsBody(rectangleOf: smallBodySize, center: CGPoint(x: -smallBodyOffset, y: mainBodyCenter.y))
		sidesBody = SKPhysicsBody(bodies: [leftBody, rightBody])
		
		super.init(node: node, physicsBody: physicsBody)
		
		absorption = 2
		compressionAmount = 0.03
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

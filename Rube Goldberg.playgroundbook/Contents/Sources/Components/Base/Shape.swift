import SpriteKit

/// An abstract class that represents a shape with a texture
///
/// - Warning: Do not use this class directly, instead use one of its subclasses
public class Shape: Component, Customizable {
	
	let shapeNode: SKShapeNode
	private(set) var spriteNode: SKSpriteNode
	
	public override var frame: Rect {
		return Rect(shapeNode.frame)
	}
	
	init(node: SKShapeNode, physicsBody: SKPhysicsBody?) {
		
		let cropNode = SKCropNode()
		cropNode.maskNode = node
		cropNode.position = node.position
		
		shapeNode = node
		shapeNode.position = .zero
		shapeNode.fillColor = .white
		
		spriteNode = SKSpriteNode(color: .white, size: shapeNode.frame.size)
		cropNode.addChild(spriteNode)
		
		super.init(node: cropNode, physicsBody: physicsBody)
		shapeNode.strokeColor = .clear
	}
	
}

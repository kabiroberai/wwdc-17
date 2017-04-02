import SpriteKit

/// An abstract class that represents a sprite that can be rendered on screen
///
/// - Warning: Do not use this class directly, instead use one of its subclasses
public class Sprite: Component, Customizable {
	
	var spriteNode: SKSpriteNode { return node as! SKSpriteNode }
	
	init(node: SKSpriteNode, physicsBody: SKPhysicsBody?) {
		super.init(node: node, physicsBody: physicsBody)
	}
	
	public convenience init(image: UIImage) {
		self.init(node: SKSpriteNode(texture: SKTexture(image: image)), physicsBody: nil)
	}
	
	public convenience init(image: UIImage, size: Size) {
		self.init(node: SKSpriteNode(texture: SKTexture(image: image), size: size.cgSize), physicsBody: nil)
	}

	public convenience init(color: UIColor, size: Size) {
		self.init(node: SKSpriteNode(color: color, size: size.cgSize), physicsBody: nil)
	}
	
	public convenience init(image: UIImage, color: UIColor, size: Size) {
		self.init(node: SKSpriteNode(texture: SKTexture(image: image), color: color, size: size.cgSize), physicsBody: nil)
	}
	
}

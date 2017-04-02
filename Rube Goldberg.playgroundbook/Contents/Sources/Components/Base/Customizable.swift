import SpriteKit

protocol Customizable: class {
	var spriteNode: SKSpriteNode { get }
}

extension Customizable {
	
	/// The dimensions of the component
	public internal(set) var size: Size {
		get { return Size(spriteNode.size) }
		set { spriteNode.size = newValue.cgSize }
	}
	
	/// The component's color
	public internal(set) var color: UIColor {
		get { return spriteNode.color }
		set { spriteNode.color = newValue }
	}
	
	/// The component's texture
	///
	/// - Note: This value is blended with `color`, so for it to take effect `color` must have a non-zero alpha
	public internal(set) var texture: UIImage? {
		get {
			guard let cgImage = spriteNode.texture?.cgImage() else { return nil }
			return UIImage(cgImage: cgImage)
		}
		set {
			if let image = newValue {
				spriteNode.texture = SKTexture(image: image)
			} else {
				spriteNode.texture = nil
			}
		}
	}
	
}

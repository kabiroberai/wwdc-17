import SpriteKit

struct PhysicsCategory: OptionSet {
	var rawValue: UInt32
	fileprivate static var current: UInt32 = 1
	static let all = PhysicsCategory(rawValue: .max)
}

fileprivate extension PhysicsCategory {
	static func next() -> PhysicsCategory {
		defer { PhysicsCategory.current *= 2 }
		return PhysicsCategory(rawValue: PhysicsCategory.current)
	}
}

extension PhysicsCategory {
	static let component = PhysicsCategory.next()
	static let ground = PhysicsCategory.next()
	static let movingPlatform = PhysicsCategory.next()
	static let jack = PhysicsCategory.next()
}

extension SKPhysicsBody {
	var fieldCategory: PhysicsCategory {
		get { return PhysicsCategory(rawValue: fieldBitMask) }
		set { fieldBitMask = newValue.rawValue }
	}
	
	var category: PhysicsCategory {
		get { return PhysicsCategory(rawValue: categoryBitMask) }
		set { categoryBitMask = newValue.rawValue }
	}
	
	var collisionCategory: PhysicsCategory {
		get { return PhysicsCategory(rawValue: collisionBitMask) }
		set { collisionBitMask = newValue.rawValue }
	}
	
	var contactTestCategory: PhysicsCategory {
		get { return PhysicsCategory(rawValue: contactTestBitMask) }
		set { contactTestBitMask = newValue.rawValue }
	}
}

import SpriteKit

public typealias Ball = Circle

public class TennisBall: Ball {
	
	public init() {
		super.init(radius: 11)
	}
	
	override func configureNode() {
		super.configureNode()
		texture = UIImage(named: "Tennis Ball.png")
	}
	
	override func configurePhysicsBody() {
		super.configurePhysicsBody()
		physicsBody?.density = 0.4
		physicsBody?.restitution = 0.6
	}
	
}

public class BowlingBall: Ball {
	
	public init() {
		super.init(radius: 18)
	}
	
	override func configureNode() {
		super.configureNode()
		texture = UIImage(named: "Bowling Ball.png")
	}
	
	override func configurePhysicsBody() {
		super.configurePhysicsBody()
		physicsBody?.density = 0.6
		physicsBody?.restitution = 0.2
	}
	
}

public class Basketball: Ball {
	
	public init() {
		super.init(radius: 18)
	}
	
	override func configureNode() {
		super.configureNode()
		texture = UIImage(named: "Basketball.png")
	}
	
	override func configurePhysicsBody() {
		super.configurePhysicsBody()
		physicsBody?.density = 0.3
		physicsBody?.restitution = 0.5
	}
	
}

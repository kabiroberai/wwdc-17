//#-hidden-code
_setup()
Game.current.finishMessage = "Awesome! Go to the [next page](@next) to have a look at a few components to help you build your own Rube Goldberg machine."

let platform1 = Platform(
	start: Point(
		x: 50,
		y: frame.maxY - 90
	),
	end: Point(
		x: 370,
		y: frame.maxY - 100
	)
)

let platform2 = Platform(
	start: Point(
		x: platform1.frame.maxX,
		y: platform1.end.y
	),
	end: Point(
		x: frame.maxX - 10,
		y: platform1.end.y
	),
	pinningMode: .center
)

let bowlingBall = BowlingBall()
bowlingBall.position = Point(
	x: platform1.frame.minX + bowlingBall.size.width / 2,
	y: platform1.frame.maxY + bowlingBall.size.height / 2
)

let platform3 = Platform(
	start: Point(
		x: frame.midX - 50,
		y: platform2.frame.minY - 100
	),
	end: Point(
		x: frame.midX + 180,
		y: platform2.frame.minY - 100
	)
)

let catchingPlatform = Platform(
	start: platform3.start,
	end: Point(x: platform3.start.x - 80, y: platform3.start.y + 50)
)

let ball1 = Basketball()
ball1.position = Point(x: platform3.frame.maxX - ball1.size.width / 2 - 5, y: platform3.frame.maxY + ball1.size.height / 2)

let platform4 = Platform(
	start: Point(x: frame.width - 10, y: platform3.frame.minY - 50),
	end: Point(x: frame.width - 100, y: platform3.frame.minY - 100)
)

let platform5 = Platform(
	start: platform4.end,
	end: Point(x: 50, y: platform4.end.y)
)

let dominoStart = Point(x: platform4.end.x - 20, y: platform5.frame.maxY + 20)

for i in 0..<14 {
	let domino = Domino()
	domino.position = dominoStart
	domino.position.x -= Double(i) * 30
}

let ball2 = TennisBall()
ball2.position = Point(x: platform5.end.x + 15, y: platform5.frame.maxY + ball2.size.height / 2)

let spring = Spring()
spring.position = Point(x: 23, y: spring.size.height / 2)

let platform6 = Platform(
	start: Point(x: platform5.end.x - 10, y: platform3.start.y),
	end: Point(x: platform5.end.x + 120, y: platform3.start.y)
)

let jack = JackInTheBox()
jack.position = Point(x: platform6.start.x + 20, y: platform6.frame.maxY + jack.size.height / 2)
jack.isGoal = true
//#-end-hidden-code
/*:
A **Rube Goldberg machine** is a complex contraption built to achieve a simple task.

This Playground enables you to build your own Rube Goldberg machines using many pre-defined components.

Here is a demo Rube Goldberg machine. To start, type in `play()` and tap **Run My Code**. It is recommended that you view the Playground in full screen for the best experience.
*/
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, play())
//#-editable-code

//#-end-editable-code

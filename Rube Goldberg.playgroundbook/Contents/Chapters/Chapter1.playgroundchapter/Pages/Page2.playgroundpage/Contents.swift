//#-hidden-code
_setup()
Game.current.finishMessage = "Amazing! Now that you know how platforms work, move on to the [next page](@next) to learn about the types of balls."
//#-end-hidden-code
/*:
The `Platform` class is one of the most important components, because most other components rest on either the floor or a platform.

Platforms are initialized by providing two `Point`s with **X** and **Y** coordinates, along with the optional `RoundingMode` and `PinningMode` enumerations. These let you round the platform's corners and pin it to a point respectively.

Set `platform1`'s end position to the center of the screen (`frame.center`) to let the tennis ball roll down and turn on the lamp.
*/
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, frame, ., center)
play()

let platform1 = Platform(
	start: Point(x: frame.width - 30, y: frame.midY),
	end: /*#-editable-code*/<#T##Point##Point#>/*#-end-editable-code*/,
	pinningMode: .center
)

let platform2 = Platform(
	start: Point(x: 220, y: frame.height - 100),
	end: Point(x: 320, y: frame.height - 100)
)

let platform3 = Platform(
	start: Point(x: frame.width - 250, y: frame.midY - 80),
	end: Point(x: frame.width - 400, y: frame.midY - 100)
)

let platform4 = Platform(
	start: Point(x: platform3.end.x - 5, y: platform3.end.y),
	end: Point(x: platform3.end.x - 5, y: platform3.end.y + 60),
	pinningMode: .start
)

let platform5 = Platform(
	start: Point(x: 0, y: platform2.frame.minY - 50),
	end: platform2.start
)

let mouse = Mouse()
mouse.position = Point(x: 30, y: platform5.start.y + 50)
//#-hidden-code
let ball = TennisBall()
ball.position = Point(x: platform2.start.x + 70, y: platform2.frame.maxY + ball.size.height / 2)

let cheese = Cheese(facing: .left)
cheese.position = Point(x: ball.position.x - ball.size.width / 2 - cheese.size.width / 2, y: platform2.frame.maxY + cheese.size.height / 2)

let lamp = Lamp(facing: .right)
lamp.position = Point(x: 60, y: lamp.size.height / 2)
lamp.isGoal = true
//#-end-hidden-code

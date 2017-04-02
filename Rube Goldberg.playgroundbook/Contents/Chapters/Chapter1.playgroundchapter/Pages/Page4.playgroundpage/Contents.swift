//#-hidden-code
_setup()
Game.current.finishMessage = "Great! Your final lesson is on goals, which let you finish the game. See the [next page](@next) to learn about them."
//#-end-hidden-code
/*:
There are two `Bouncy` components, `Spring` and `Trampoline`. The `Spring` is bouncier than the `Trampoline`.

See how the contraption works with a `Trampoline`, and then change it to a `Spring` to make the ball hit the car.
*/
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, Trampoline, Spring)
play()

let bouncyComponent = /*#-editable-code*/Trampoline/*#-end-editable-code*/()
bouncyComponent.position = Point(x: frame.midX, y: bouncyComponent.size.height / 2)

let ball = BowlingBall()
ball.position = Point(x: frame.midX, y: 170)

let platform2 = Platform(
	start: Point(x: 10, y: frame.midY - 45),
	end: Point(x: frame.midX - 30, y: frame.midY - 45)
)

let car = Car(facing: .left)
car.position = Point(x: platform2.end.x - 36, y: platform2.frame.maxY + car.size.height / 2)

let lamp = Lamp(facing: .right)
lamp.position = Point(x: platform2.start.x + 40, y: platform2.start.y + lamp.size.height / 2)
lamp.isGoal = true

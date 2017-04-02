//#-hidden-code
_setup()
Game.current.finishMessage = "Fantastic! We shall now have a look at the `Bouncy` components. Go to the [next page](@next) for more on those."
//#-end-hidden-code
/*:
There are three kinds of ball classes. Arranged in ascending order of mass, these are `TennisBall`, `Basketball`, and `BowlingBall`.

Add all three to the `balls` array to see how they work.
*/
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, TennisBall, Basketball, BowlingBall)
play()

let balls: [Ball] = [
	/*#-editable-code*/<#T##Ball 1##Ball#>/*#-end-editable-code*/(),
	/*#-editable-code*/<#T##Ball 2##Ball#>/*#-end-editable-code*/(),
	/*#-editable-code*/<#T##Ball 3##Ball#>/*#-end-editable-code*/()
]

let spacing: Double = 200
for (index, ball) in balls.enumerated() {
	let offset = Double(index) * spacing
	
	ball.position = Point(x: 85 + offset, y: 350)
	
	let startY = ball.position.y - ball.size.height / 2 - 3
	let platform = Platform(
		start: Point(x: ball.position.x - 49, y: startY),
		end: Point(x: ball.position.x + 50, y: startY),
		pinningMode: .center
	)
	
	ball.isDynamic = false
	delay(seconds: 2 * Double(index)) {
		ball.isDynamic = true
	}
}
//#-hidden-code
if balls.count == 3
	&& balls.contains(where: { $0 is TennisBall })
	&& balls.contains(where: { $0 is Basketball })
	&& balls.contains(where: { $0 is BowlingBall }) {
	delay(seconds: 8, execute: Game.current.finish)
}
//#-end-hidden-code

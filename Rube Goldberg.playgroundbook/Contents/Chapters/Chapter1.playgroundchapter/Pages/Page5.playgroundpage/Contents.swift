//#-hidden-code
_setup()
Game.current.finishMessage = "I hope you enjoyed my Playground! Feel free to view the auxillary source files to see all the features I haven't mentioned. If you wish to build your own Rube Goldberg machine, go to the [next page](@next)."
//#-end-hidden-code
/*:
The last step in building Rube Goldberg machines is defining a **goal**. The goal should be something that could normally be done in a way easier manner, but since we're building a Rube Goldberg machine we don't do _easy_.

Any component with an `isGoal` property may be set as the end goal, by setting this property to `true`. The game is considered finished when a goal has its action executed.

Your challenge is to change the Jar's `isGoal` property to `true`, so that the game finishes when the jar is broken.

This page also has a few components that I haven't explicitly described before, so check those out if you want to see how they have been implemented.
*/
//#-code-completion(everything, hide)
//#-code-completion(literal, show, boolean)
play()

let jar = Jar()
jar.position = Point(x: 250, y: 25)
jar.isGoal = /*#-editable-code*/false/*#-end-editable-code*/

let car = Car(facing: .right)
car.position = Point(x: car.size.width / 2 + 50, y: car.size.height / 2)

let platform1 = Platform(
	start: Point(x: 10, y: car.frame.maxY + 70),
	end: Point(x: 200, y: car.frame.maxY + 70),
	pinningMode: .center
)

let platform2 = Platform(
	start: Point(x: 100, y: platform1.frame.maxY + 90),
	end: Point(x: 330, y: platform1.frame.maxY + 90)
)

let tennisBall = TennisBall()
tennisBall.position = Point(x: platform2.start.x + 15, y: platform2.frame.maxY + tennisBall.size.height / 2)

let dominoStart = Point(x: platform2.start.x + 41, y: platform2.frame.maxY + 20)

for i in 0..<7 {
	let domino = Domino()
	domino.position = dominoStart
	domino.position.x += Double(i) * 30
}

let platform3 = Platform(
	start: Point(x: platform2.end.x - 10, y: platform2.frame.minY - 50),
	end: Point(x: platform2.end.x + 100, y: platform2.frame.minY - 50)
)

let jack = JackInTheBox()
jack.position = Point(x: platform3.start.x + 30, y: platform3.frame.maxY + jack.size.height / 2)

let platform4 = Platform(
	start: Point(x: platform3.end.x, y: platform3.frame.maxY + 10),
	end: Point(x: frame.width - 20, y: platform3.frame.maxY + 150)
)

let platform5 = Platform(
	start: Point(x: 300, y: frame.height - 110),
	end: Point(x: 500, y: frame.height - 130)
)

let platform6 = Platform(
	start: Point(x: 30, y: platform5.start.y),
	end: platform5.start
)

let bowlingBall = BowlingBall()
bowlingBall.position = Point(x: platform6.end.x - 25, y: platform6.frame.maxY + bowlingBall.size.height / 2)

let cheese = Cheese(facing: .left)
cheese.position = Point(x: platform6.end.x - 70, y: platform6.frame.maxY + cheese.size.height / 2)

let mouse = Mouse()
mouse.position = Point(x: 60, y: platform6.frame.maxY + mouse.size.height / 2)

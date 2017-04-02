import UIKit
import PlaygroundSupport

public let frame = Game.current.frame

public func _setup() {
	PlaygroundPage.current.liveView = Game.current.view
	Game.current.backgroundImage = UIImage(named: "Background.png")
}

public func play() {
	delay(seconds: 1) {
		Game.current.resume()
		Game.current.playBackgroundMusic(named: "Pixelland.mp3")
	}
}

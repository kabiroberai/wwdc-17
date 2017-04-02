import SpriteKit
import AVFoundation
import PlaygroundSupport

/// A non-tangible class that manages the simulation
public class Game: NSObject {
	
	/// The message shown when the light bulb is turned on
	public var finishMessage = "[Next page](@next)"
	
	public struct ViewSettings {
		public var showsFPS: Bool
		public var showsNodeCount: Bool
		public var showsPhysics: Bool
		public var showsDrawCount: Bool
		public var showsQuadCount: Bool
		public var showsFields: Bool
		
		fileprivate init(view: SKView) {
			showsFPS = view.showsFPS
			showsNodeCount = view.showsNodeCount
			showsPhysics = view.showsPhysics
			showsDrawCount = view.showsDrawCount
			showsQuadCount = view.showsQuadCount
			showsFields = view.showsFields
		}
		
		fileprivate func update(view: SKView) {
			view.showsFPS = showsFPS
			view.showsNodeCount = showsNodeCount
			view.showsPhysics = showsPhysics
			view.showsDrawCount = showsDrawCount
			view.showsQuadCount = showsQuadCount
			view.showsFields = showsFields
		}
	}
	
	/// The current game
	public static let current = Game()
	
	static let defaultSize = CGSize(width: 600, height: 450)
	
	let view = SKView(frame: CGRect(origin: .zero, size: defaultSize))
	let scene = GameScene(size: defaultSize)
	
	/// The list of currently loaded components
	public var components: [Component] = []
	
	var backgroundMusicPlayer: AVAudioPlayer?
	
	var background: Sprite?
	
	var oldSpeed: Double?
	
	var boundary: SKPhysicsBody {
		let boundary = SKPhysicsBody(edgeLoopFrom: scene.frame)
		boundary.category = .ground
		return boundary
	}
	
	/// The (mutable) size of the scene. Defaults to 600 x 450
	public var size: Size {
		get { return Size(scene.size) }
		set {
			scene.size = newValue.cgSize
			if let image = backgroundImage {
				backgroundImage = image
			}
			if hasBoundary {
				hasBoundary = true // Force-update the boundary size
			}
		}
	}
	
	/// The scene's frame
	public var frame: Rect {
		return Rect(scene.frame)
	}
	
	/// Determines whether components can collide with the scene's edges
	public var hasBoundary: Bool {
		get { return scene.physicsBody != nil }
		set { scene.physicsBody = newValue ? boundary : nil }
	}
	
	/// The gravitational acceleration applied on all dynamic objects in the scene, in meters per second. Defaults to 9.8
	public var gravity: Double {
		get { return Double(-scene.physicsWorld.gravity.dy) }
		set { scene.physicsWorld.gravity.dy = -CGFloat(newValue) }
	}
	
	/// The rate at which the simulation executes
	public var speed: Double {
		get { return Double(scene.physicsWorld.speed) }
		set { scene.physicsWorld.speed = CGFloat(newValue) }
	}
	
	/// The scene's background color
	public var backgroundColor: UIColor {
		get { return scene.backgroundColor }
		set { scene.backgroundColor = newValue }
	}
	
	/// The image displayed as the scene's background
	public var backgroundImage: UIImage? {
		get {
			return background?.texture
		}
		set {
			background?.remove()
			background = nil
			guard let image = newValue else { return }
			background = Sprite(image: image)
			background!.node.zPosition = -100
			background!.size.aspectScale(to: size, fill: true)
		}
	}
	
	let bottomOffset: CGFloat = 0
	
	/// Change the view's debug settings
	///
	/// - Parameter handler: The closure in which the modifications take place
	///
	/// - Parameter settings: The `ViewSettings` object which can be modified inside the closure
	public func changeViewSettings(handler: (_ settings: inout ViewSettings) -> Void) {
		var debugSettings = ViewSettings(view: view)
		handler(&debugSettings)
		debugSettings.update(view: view)
	}
	
	/// Pause the simulation. Effectively the same as setting `speed = 0`, but also allows the previous speed to be restored in `resume`
	public func pause() {
		oldSpeed = speed
		speed = 0
	}
	
	/// Resumes the simulation if paused. Effectively the same as setting `speed` back to the value it was at before the simulation was paused
	public func resume() {
		guard let oldSpeed = oldSpeed else { return }
		speed = oldSpeed
		self.oldSpeed = nil
	}
	
	/// Play background music
	///
	/// - Parameter name: The music's filename
	public func playBackgroundMusic(named name: String) {
		if backgroundMusicPlayer != nil {
			stopBackgroundMusic()
		}
		guard let url = Bundle.main.url(forResource: name, withExtension: nil) else { return }
		backgroundMusicPlayer = try? AVAudioPlayer(contentsOf: url)
		backgroundMusicPlayer?.numberOfLoops = -1
		backgroundMusicPlayer?.volume = 0.3
		backgroundMusicPlayer?.prepareToPlay()
		backgroundMusicPlayer?.play()
	}
	
	/// Stop the background music
	public func stopBackgroundMusic() {
		guard let player = backgroundMusicPlayer else { return }
		let fadeDuration: TimeInterval = 0.5
		player.setVolume(0, fadeDuration: fadeDuration)
		delay(seconds: fadeDuration, execute: player.stop)
		backgroundMusicPlayer = nil
	}
	
	/// Finish the game
	public func finish() {
		stopBackgroundMusic()
		delay(seconds: 0.5) {
			self.pause()
			PlaygroundPage.current.assessmentStatus = .pass(message: self.finishMessage)
		}
	}
	
	func add(component: Component) {
		scene.addChild(component.node)
		components.append(component)
	}
	
	private override init() {
		super.init()
		configureView()
		configureScene()
		view.presentScene(scene)
	}
	
	func configureView() {
		view.ignoresSiblingOrder = false
	}
	
	func configureScene() {
		scene.scaleMode = .aspectFit
		backgroundColor = .white
		hasBoundary = true
		scene.physicsWorld.contactDelegate = self
		scene.anchorPoint = CGPoint(x: 0, y: 1 / scene.size.height * bottomOffset)
		pause()
	}
	
}

protocol GoalSettable {
	/// Determines whether the component's activation finishes the game
	var isGoal: Bool { get set }
}

extension GoalSettable {
	
	func finishIfGoal() {
		if isGoal {
			Game.current.finish()
		}
	}
	
}

typealias ActionHandler = () -> ()
protocol ActionHandling: class {
	var actionHandler: ActionHandler? { get set }
}

extension ActionHandling {
	
	/// Perform a custom behavior when the Component's specialized action takes place
	///
	/// - Parameter handler: The behavior to perform
	public func onAction(handler: @escaping ActionHandler) {
		actionHandler = handler
	}
	
}

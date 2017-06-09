//This playground was created to rapidly test how various variables would effect the gameplay of this game
import UIKit
import SpriteKit
import XCPlayground

//Set size of simulator window
let w:CGFloat = 550 * 0.41
let h:CGFloat = 950 * 0.4

//** setup stuff here

let sceneView = SKView(frame: CGRect(x: 0, y: 0, width: w, height: h))
let scene = GameScene()
scene.scaleMode = .aspectFill
scene.size = CGSize(width: w, height: h)
sceneView.presentScene(scene)
scene.width = w
scene.height = h
scene.initializer()
XCPlaygroundPage.currentPage.liveView = sceneView


//**Variables

//Speed of elevator
scene.editSpeed = 0.9
//Drag of elevator (Must be greater than 0)
scene.editDrag = 1.02
//Edit speed of time (larger = faster = harder)
scene.editTime = 1.2


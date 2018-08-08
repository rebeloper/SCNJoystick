//
//  ViewController.swift
//  SCNJoystick
//
//  Created by Alex Nagy on 08/08/2018.
//  Copyright © 2018 Alex Nagy. All rights reserved.
//

import UIKit
import SceneKit
import SpriteKit

class ViewController: UIViewController {
  
  // MARK: - Properties
  
  let scnView: SCNView = {
    let view = SCNView()
    return view
  }()
  
  lazy var skView: SKView = {
    let view = SKView()
    view.isMultipleTouchEnabled = true
    view.backgroundColor = .clear
    return view
  }()
  
  var hero: SCNNode!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print("view did load")
    setupSCNView()
    setupSKView()
    initSceneView()
    initScene()
    setupSCNViewSubviews()
    setupSKViewScene()
    startGame()
    
    NotificationCenter.default.addObserver(forName: joystickNotificationName, object: nil, queue: OperationQueue.main) { (notification) in
      guard let userInfo = notification.userInfo else { return }
      let data = userInfo["data"] as! AnalogJoystickData
      
      //      print(data.description)
      
      self.hero.position = SCNVector3(self.hero.position.x + Float(data.velocity.x * joystickVelocityMultiplier), self.hero.position.y, self.hero.position.z - Float(data.velocity.y * joystickVelocityMultiplier))
      
      self.hero.eulerAngles.y = Float(data.angular) + Float(180.0.degreesToRadians)
      
    }
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Release any cached data, images, etc that aren't in use.
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  func setupSCNView() {
    view.addSubview(scnView)
    scnView.fillSuperview()
  }
  
  func setupSCNViewSubviews() {
    
  }
  
  func setupSKView() {
    view.addSubview(skView)
    skView.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 180)
  }
  
  func setupSKViewScene() {
    let scene = SCNJoystickSKScene(size: CGSize(width: view.bounds.size.width, height: 180))
    scene.scaleMode = .resizeFill
    skView.presentScene(scene)
    skView.ignoresSiblingOrder = true
    //    skView.showsFPS = true
    //    skView.showsNodeCount = true
    //    skView.showsPhysics = true
  }
  
  // MARK: - Initialization
  
  func initSceneView() {
    scnView.autoenablesDefaultLighting = true
  }
  
  func initScene() {
    let scene = SCNScene(named: "art.scnassets/Models/Floor.scn")!
    scene.isPaused = false
    scnView.scene = scene
    
    // allows the user to manipulate the camera
    scnView.allowsCameraControl = true
    
    // show statistics such as fps and timing information
//    scnView.showsStatistics = true
    
    // configure the view
    scnView.backgroundColor = UIColor.black
  }
  
  // MARK: - Game Logic
  
  @objc func startGame() {
    DispatchQueue.main.async {
      self.createGameWorld()
    }
  }
  
  func createGameWorld() {
    linkHero()
  }
  
  func linkHero() {
    hero = scnView.scene?.rootNode.childNode(withName: Constants.heroNodeName, recursively: true)!
  }
  
}



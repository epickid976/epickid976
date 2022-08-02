//
//  GameViewController.swift
//  Project 29
//
//  Created by Jose Blanco on 7/21/22.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    @IBOutlet var angleSlider: UISlider!
    @IBOutlet var angleLabel: UILabel!
    @IBOutlet var velocitySlider: UISlider!
    @IBOutlet var velocityLabel: UILabel!
    @IBOutlet var launchButton: UIButton!
    @IBOutlet var playerNumber: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    var currentGame: GameScene?
    
    var playerOneScore = 0 {
        didSet {
            scoreLabel.text = """
                            Player 1: \(playerOneScore)
                            Player 2: \(playerTwoScore)
                            Wind: \(windDirection)
                            """
        }
    }
    var playerTwoScore = 0 {
        didSet {
            scoreLabel.text = """
                            Player 1: \(playerOneScore)
                            Player 2: \(playerTwoScore)
                            Wind: \(windDirection)
                            """
        }
    }
    
    var windDirection = "Normal" {
        didSet {
            scoreLabel.text = """
                            Player 1: \(playerOneScore)
                            Player 2: \(playerTwoScore)
                            Wind: \(windDirection)
                            """
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                
                currentGame = scene as? GameScene
                currentGame?.viewController = self
                
                
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
        
        scoreLabel.text = """
                            Player 1: 0
                            Player 2: 0
                            Wind: \(windDirection)
                            """
        
        angleChanged(self)
        velocityChanged(self)
        
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func angleChanged(_ sender: Any) {
        angleLabel.text = "Angle: \(Int(angleSlider.value))°"
    }
    @IBAction func velocityChanged(_ sender: Any) {
        velocityLabel.text = "Velocity: \(Int(velocitySlider.value))"
    }
    @IBAction func launch(_ sender: Any) {
        angleSlider.isHidden = true
        angleLabel.isHidden = true
        
        velocitySlider.isHidden = true
        velocityLabel.isHidden = true
        
        launchButton.isHidden = true
        
        currentGame?.launch(angle: Int(angleSlider.value), velocity: Int(velocitySlider.value))
    }
    
    func activatePlayer(number: Int) {
        if number == 1 {
            playerNumber.text = "<<< PLAYER ONE"
            
        } else {
            playerNumber.text = "<<< PLAYER TWO"
            
        }
        
        
        
        angleSlider.isHidden = false
        angleLabel.isHidden = false
        
        velocitySlider.isHidden = false
        velocityLabel.isHidden = false
        
        launchButton.isHidden = false
    }
    
    func changeWind(wind: String) {
        scoreLabel.text = """
                        Player 1: \(playerOneScore)
                        Player 2: \(playerTwoScore)
                        Wind: \(wind)
                        """
    }
}

//
//  GameScene.swift
//  Project 11
//
//  Created by Jose Blanco on 5/30/22.
//

import SpriteKit
import UIKit
import Foundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    var balls = [String]()
    var scoreLabel: SKLabelNode!
    var numberOfBallsLabel: SKLabelNode!
    
    var boxNumber = 0
    var numberOfBalls = 5 {
        didSet {
            numberOfBallsLabel.text = "Balls Left: \(numberOfBalls)"
        }
    }
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var editLabel: SKLabelNode!
    
    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
        
        numberOfBallsLabel = SKLabelNode(fontNamed: "ChalkDuster")
        numberOfBallsLabel.text = "Balls Left: \(numberOfBalls)"
        numberOfBallsLabel.position = CGPoint(x:512, y:700)
        addChild(numberOfBallsLabel)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
        
        balls.append("ballBlue")
        balls.append("ballCyan")
        balls.append("ballGreen")
        balls.append("ballGrey")
        balls.append("ballPurple")
        balls.append("ballRed")
        balls.append("ballYellow")
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let objects = nodes(at: location)
        
        if objects.contains(editLabel) {
            editingMode.toggle()
        } else {
            if editingMode {
                let size = CGSize(width: Int.random(in: 16...128), height: 16)
                let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
                box.zRotation = CGFloat.random(in: 0...3)
                box.position = location
                
                box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                box.physicsBody?.isDynamic = false
                boxNumber += 1
                numberOfBalls = 5
                box.name = "box"
                addChild(box)
                
            } else {
                if numberOfBalls != 0 {
                let ball = SKSpriteNode(imageNamed: balls.randomElement()!)
                ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                ball.physicsBody?.restitution = 0.4
                ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
                ball.position = location
                ball.position.y = 740
                ball.name = "ball"
                addChild(ball)
                    numberOfBalls -= 1
                }
        }
    }
    }
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
    
    func collision(between ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball: ball)
            score += 1
        } else if object.name == "bad" {
            destroy(ball:ball)
            score -= 1
        }
    }
    
    func collision2(between box: SKNode, object: SKNode){
    
        destroy(ball: box)
            boxNumber -= 1
    }
    
    func destroy(ball: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        
        ball.removeFromParent()
        if boxNumber == 0 {
            let ac = UIAlertController(title: "Congratulations", message: "Congratulations! You hit all the obstacles with \(numberOfBalls) balls left. Would you like to try again?" , preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Cancel", style: .default))
            ac.addAction(UIAlertAction(title: "Try again", style: .default, handler: { [weak self] _ in
                self?.numberOfBalls = 5
                self?.score = 0
            }))
            
            view?.window?.rootViewController?.present(ac, animated: true)
        } else if numberOfBalls == 0 && boxNumber != 0 {
            let ac = UIAlertController(title: "No Balls Left. Please try again.", message: nil , preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Cancel", style: .default))
            ac.addAction(UIAlertAction(title: "Try again", style: .default, handler: { [weak self] _ in
                self?.numberOfBalls = 5
                self?.score = 0
                
            }))
            
            view?.window?.rootViewController?.present(ac, animated: true)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        
        if nodeB.name == "box" {
            collision2(between: nodeB, object: nodeA)
        } else if nodeA.name == "box" {
            collision2(between: nodeA, object: nodeB)
        } else if nodeA.name == "ball" {
            collision(between: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collision(between: nodeB, object: nodeA)
        }
    }
}

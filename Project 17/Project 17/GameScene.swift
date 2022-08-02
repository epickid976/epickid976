//
//  GameScene.swift
//  Project 17
//
//  Created by Jose Blanco on 6/17/22.
//

import SpriteKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    var starfield: SKEmitterNode!
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var gameScore: SKLabelNode!
    var finalScore: SKLabelNode!
    var enemyCount = 0
    var touchesEnded1 = 0
    
    var possibleEnemies = ["ball", "hammer", "tv"]
    var gameTimer: Timer?
    var isGameOver = false
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        starfield = SKEmitterNode(fileNamed: "starfield")!
        starfield.position = CGPoint(x: 1024, y: 384)
        starfield.advanceSimulationTime(10)
        addChild(starfield)
        starfield.zPosition = -1
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.contactTestBitMask = 1
        addChild(player)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        score = 0
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        
        
        
        }
    @objc func createEnemy() {
        guard let enemy = possibleEnemies.randomElement() else { return }
        
        let sprite = SKSpriteNode(imageNamed: enemy)
        sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
        addChild(sprite)
        enemyCount += 1
        print(enemyCount)
        if enemyCount == 10 {
            gameTimer?.invalidate()
            gameTimer = Timer.scheduledTimer(timeInterval: 0.9, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        } else if enemyCount == 20 {
            gameTimer?.invalidate()
            gameTimer = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        } else if enemyCount == 30 {
            gameTimer?.invalidate()
            gameTimer = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        } else if enemyCount == 40 {
            gameTimer?.invalidate()
            gameTimer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        }else if enemyCount == 50 {
            gameTimer?.invalidate()
            gameTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        }else if enemyCount == 60 {
            gameTimer?.invalidate()
            gameTimer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        }else if enemyCount == 70 {
            gameTimer?.invalidate()
            gameTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        }else if enemyCount == 80 {
            gameTimer?.invalidate()
            gameTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        }else if enemyCount == 90 {
            gameTimer?.invalidate()
            gameTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        }
        
        
        
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        sprite.physicsBody?.angularVelocity = 5
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
        }
        
        if !isGameOver {
            score += 1
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        var location = touch.location(in: self)
        
        if location.y < 100 {
            location.y = 100
        } else if location.y > 668 {
            location.y = 668
        }
        
        player.position = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        touchesEnded1 += 1
        if touchesEnded1 == 1 {
        
        let gameOver = SKSpriteNode(imageNamed: "gameOver")
        gameOver.position = CGPoint(x: 512, y: 384)
        gameOver.zPosition = 1
        addChild(gameOver)
        
        finalScore = SKLabelNode(fontNamed: "Chalkduster")
        finalScore.text = "Final Score: \(score)"
        finalScore.position = CGPoint(x: 512, y:315)
        finalScore.horizontalAlignmentMode = .center
        finalScore.fontSize = 48
        finalScore.zPosition = 1
        addChild(finalScore)
        run(SKAction.playSoundFileNamed("failure-drum-sound-effect-2-7184.mp3", waitForCompletion: false))
            let explosion = SKEmitterNode(fileNamed: "explosion")!
            explosion.position = player.position
            addChild(explosion)
            
            player.removeFromParent()
            isGameOver = true
            gameTimer?.invalidate()
        } else {
            return
        }

        
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position
        addChild(explosion)
        
        player.removeFromParent()
        isGameOver = true
        gameTimer?.invalidate()
    }
}

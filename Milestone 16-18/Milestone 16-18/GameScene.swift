//
//  GameScene.swift
//  Milestone 16-18
//
//  Created by nikita on 26.02.2023.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
 
    let allEnemys = ["bear", "squirrel"]
    var gameOverLabel: SKLabelNode!
    
    let lineWidth: CGFloat = 2.0
    let lineLength: CGFloat = 1024.0
    let lineHeight: CGFloat = 1.0
    let lineColor = SKColor.black
    
    
    var shootPole: SKSpriteNode!
    var isGameOver = false
    
    var gameTimer: Timer?
    var timerTick = 60
    
    var timerInterval: Double = 1

    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score - \(score)"
        }
    }
    
        
    override func didMove(to view: SKView) {
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: -lineLength, y: 0))
        path.addLine(to: CGPoint(x: lineLength, y: 0))
        
        let lineNode = SKShapeNode(path: path, centered: false)
        lineNode.lineWidth = lineWidth
        lineNode.strokeColor = lineColor
        lineNode.position = CGPoint(x: 200, y: 250)
        lineNode.zPosition = 1
        addChild(lineNode)
        
        let lineNode2 = SKShapeNode(path: path, centered: false)
        lineNode2.lineWidth = lineWidth
        lineNode2.strokeColor = lineColor
        lineNode2.position = CGPoint(x: 200, y: 500)
        lineNode2.zPosition = 1
        addChild(lineNode2)
      
        shootPole = SKSpriteNode(imageNamed: "background")
        shootPole.xScale = 2.0
        shootPole.yScale = 2.0
        shootPole.position = CGPoint(x: 512, y: 384)
        shootPole.zPosition = -1
        addChild(shootPole)
                
        scoreLabel = SKLabelNode(fontNamed: "Chulkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        score = 0
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        newGame()
        
    }
    
    func newGame() {
        guard isGameOver else { return }

        score = 0
        timerTick = 60
        timerInterval = 1

        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        isGameOver = false

        for node in children {
            if node.name == "Enemy" {
                node.removeFromParent()
            }
        }

        shootPole.isHidden = false
        gameTimer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        
    }
   
    @objc func createEnemy() {
        timerTick -= 1
      
        let bigSprite1 = SKSpriteNode(imageNamed: "bear")
        bigSprite1.position = CGPoint(x: 500, y: 600)
        addChild(bigSprite1)
        
        bigSprite1.physicsBody = SKPhysicsBody(texture: bigSprite1.texture!, size: bigSprite1.size)
        bigSprite1.physicsBody?.categoryBitMask = 1
        bigSprite1.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        bigSprite1.physicsBody?.angularVelocity = 5
        bigSprite1.physicsBody?.linearDamping = 0
        bigSprite1.physicsBody?.angularDamping = 0
        bigSprite1.physicsBody?.collisionBitMask = 1
        bigSprite1.physicsBody?.contactTestBitMask = 1
        bigSprite1.zPosition = 0.1
        
        let bigSprite2 = SKSpriteNode(imageNamed: "bear")
        bigSprite2.position = CGPoint(x: 1024, y: 125)
        addChild(bigSprite2)
        
        bigSprite2.physicsBody = SKPhysicsBody(texture: bigSprite2.texture!, size: bigSprite2.size)
        bigSprite2.physicsBody?.categoryBitMask = 1
        bigSprite2.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        bigSprite2.physicsBody?.angularVelocity = 5
        bigSprite2.physicsBody?.linearDamping = 0
        bigSprite2.physicsBody?.angularDamping = 0
        bigSprite2.zPosition = 2
        
        if timerTick == 0 {
                timerTick = 60

        if timerInterval >= 0.2 {
                timerInterval -= 0.1
            }
        
        gameTimer?.invalidate()
        gameTimer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
                if node.position.x < -300 {
                    node.removeFromParent()
                }
            }
    }
    
    func gameOver() {
        gameTimer?.invalidate()
        isGameOver = true

    }
}

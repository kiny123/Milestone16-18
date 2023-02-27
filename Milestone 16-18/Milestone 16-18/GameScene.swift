//
//  GameScene.swift
//  Milestone 16-18
//
//  Created by nikita on 26.02.2023.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
 
    let allEnemys = ["good_1", "good_2", "bad"]
    let scoresDict = ["GoodBig": 5, "GoodSmall": 10, "Bad": -10]
    var gameOverLabel: SKLabelNode!
    var newGameLabel: SKLabelNode!
    
    let lineWidth: CGFloat = 2.0
    let lineLength: CGFloat = 1024.0
    let lineHeight: CGFloat = 1.0
    let lineColor = SKColor.black
    
    
    var shootPole: SKSpriteNode!
    var isGameOver = false
    var bullets: BulletNode!
    
    var gameTimer: Timer?
    var spawnTimer: Timer?
    var timerLabel: SKLabelNode!
    var timer = 30 {
        didSet {
            timerLabel.text = "\(timer)s"
        }
    }
    

    
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
                
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        timerLabel = SKLabelNode(fontNamed: "Chalkduster")
        timerLabel.text = "30s"
        timerLabel.position = CGPoint(x: 552, y: 700)
        timerLabel.horizontalAlignmentMode = .right
        timerLabel.fontSize = 48
        timerLabel.zPosition = 1
        addChild(timerLabel)
        
        bullets = BulletNode()
        bullets.configure(at: CGPoint(x: 875, y: 700))
        bullets.name = "bullets"
        addChild(bullets)
        
        gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameOverLabel.text = "Game over!"
        gameOverLabel.position = CGPoint(x: 512, y: 384)
        gameOverLabel.horizontalAlignmentMode = .center
        gameOverLabel.fontSize = 68
        gameOverLabel.zPosition = 1
        
        newGameLabel = SKLabelNode(fontNamed: "Chalkduster")
        newGameLabel.text = "New game?"
        newGameLabel.position = CGPoint(x: 512, y: 324)
        newGameLabel.horizontalAlignmentMode = .center
        newGameLabel.name = "newGame"
        newGameLabel.fontSize = 38
        newGameLabel.zPosition = 1
        
        score = 0
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        newGame()
        
    }
    
    func newGame() {
        score = 0
        timer = 30
        bullets.reload()
        gameOverLabel.removeFromParent()
        newGameLabel.removeFromParent()
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(decreaseTimer), userInfo: nil, repeats: true)
        spawnTimer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
}
    
    @objc func decreaseTimer() {
        timer -= 1
        
        if timer <= 0 {
          gameOver()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
             
             guard let touch = touches.first else { return }
             let location = touch.location(in: self)
             let tappedNodes = nodes(at: location)

            
             var nodeTapped = false

             for node in tappedNodes {
                 if node.name == "newGame" {
                     newGame()
                     return
                 }

                 if timer > 0 {
                     for (key, value) in scoresDict {
                         if node.name == key {
                             nodeTapped = true

                             if !bullets.remains() {
                                 showReload()
                                 return
                             }
                             bullets.decrease()

                             score += value

                             node.removeFromParent()
                             break
                         }
                     }

                     if node.name == "bullets" {
                         bullets.reload()

                         return
                     }
                 }
             }
        
        if timer > 0 && !nodeTapped {
                if !bullets.remains() {
                    showReload()
                    return
        }
                bullets.decrease()
                score -= 5
            }
    }
   
    @objc func createEnemy() {
        
        guard let enemy = allEnemys.randomElement() else { return }
        
        let sprite = SKSpriteNode(imageNamed: enemy)

        let yPosition = Int.random(in: 0...1024)
        let scaler = Int.random(in: 1...3)

        if yPosition > 250 && yPosition < 500 {
            sprite.position = CGPoint(x: -200, y: 375)

        } else if yPosition > 500 && yPosition < 1024 {
                sprite.position = CGPoint(x: 1200, y: 625)
        } else if yPosition > 0 && yPosition < 250 {
            sprite.position = CGPoint(x: -200, y: 125)
        }
        
        if enemy.starts(with: "bad") {
                sprite.name = "Bad"
            } else if enemy.starts(with: "good") && scaler == 3 {
                sprite.name = "GoodBig"
            } else if enemy.starts(with: "good") && scaler == 1 {
                sprite.name = "GoodSmall"
            }

        
   
        
        sprite.zPosition = 0.2
        addChild(sprite)

        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 0
        
        if yPosition > 250 && yPosition < 500 {
            sprite.physicsBody?.velocity = CGVector(dx: 600/scaler, dy: 0)

        } else {
            sprite.physicsBody?.velocity = CGVector(dx: -600/scaler, dy: 0)
        }
        
        sprite.xScale = 0.2 * CGFloat(scaler)
        sprite.yScale = 0.2 * CGFloat(scaler)
        sprite.physicsBody?.angularVelocity = 0.5
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
        
    }
    
        
        func showReload() {
                 let reloadLabel = SKLabelNode(fontNamed: "Chalkduster")
                 reloadLabel.text = "Out of ammo!"
                 reloadLabel.position = CGPoint(x: 512, y: 384)
                 reloadLabel.horizontalAlignmentMode = .center
                 reloadLabel.fontSize = 80
                 reloadLabel.fontColor = UIColor.red
                 reloadLabel.zPosition = 1
                 addChild(reloadLabel)
            
            let fadeOut = SKAction.fadeOut(withDuration: 0.5)
                     let removeAction = SKAction.customAction(withDuration: 0) { (reloadLabel, _) in
                         reloadLabel.removeFromParent()
                     }
                     let sequence = SKAction.sequence([fadeOut, removeAction])
                     reloadLabel.run(sequence)
             }
    
   func gameOver() {
    gameTimer?.invalidate()
    spawnTimer?.invalidate()
    addChild(gameOverLabel)
    addChild(newGameLabel)
    }
}

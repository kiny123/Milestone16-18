//
//  BulletNode.swift
//  Milestone 16-18
//
//  Created by nikita on 27.02.2023.
//

import SpriteKit

class BulletNode: SKNode {

     var bullets = [SKSpriteNode]()
        var bulletsCount = 6
        let full = SKTexture(imageNamed: "bulletShell")
        let empty = SKTexture(imageNamed: "emptyBulletShell")
    
    func configure(at position: CGPoint) {
             self.position = position
        
        

             bullets.append(addBullet(x: 0))
             bullets.append(addBullet(x: 25))
             bullets.append(addBullet(x: 50))
             bullets.append(addBullet(x: 75))
             bullets.append(addBullet(x: 100))
             bullets.append(addBullet(x: 125))

             let transparency = SKSpriteNode()
             transparency.size = CGSize(width: 200, height: 150)
             transparency.position = CGPoint(x: -100, y: -75)
             addChild(transparency)
         }

         func addBullet(x: Int) -> SKSpriteNode {
            let bullet = SKSpriteNode(imageNamed: "bulletShell")
            bullet.zPosition = 3
            bullet.position = CGPoint(x: x, y: 0)
            bullet.xScale = 0.2
            bullet.yScale = 0.2
            addChild(bullet)
            return bullet
         }

         func decrease() {
             if bulletsCount <= 0 {
                 return
             }

             bulletsCount -= 1
             bullets[bulletsCount].texture = SKTexture(imageNamed: "emptyBulletShell")
         }

         func remains() -> Bool {
             return bulletsCount > 0
         }

         func reload() {
            bulletsCount = 6
            
            for bullet in bullets {
                 bullet.texture = SKTexture(imageNamed: "bulletShell")
             }
         }
}

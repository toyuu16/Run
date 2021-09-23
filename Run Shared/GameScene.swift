//
//  GameScene.swift
//  Run Shared
//
import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    
    var mainCharNode:SKSpriteNode = SKSpriteNode(imageNamed: "saru.png")
    let gameOverLabel = SKLabelNode()
    
    override func didMove(to view: SKView) {
        //このシーンが表示されるタイミングで処理が行われる
        //主に初期化
        print("[debug] didMove")
        
        //SkSpriteNode
        self.mainCharNode.position = CGPoint(x: -150, y: view.frame.height / -2 + 250)
        self.mainCharNode.size = CGSize(width: 300, height: 300)
        self.addChild(self.mainCharNode)
        self.backgroundColor = UIColor.white
        
        
        self.gameOverLabel.text = "GameOver"
        self.gameOverLabel.fontColor = UIColor.black
        self.gameOverLabel.fontSize = 94
        self.gameOverLabel.alpha = 0 //透明
        self.addChild(self.gameOverLabel)
        
        self.addFish()
        self.addCactus()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //画面をタッチ開始した時に呼ばれる
        let movePos = CGPoint(x: self.mainCharNode.position.x, y: self.mainCharNode.position.y + 250)
        let jumpUpAction = SKAction.move(to: movePos, duration: 0.3)
        jumpUpAction.timingMode = .easeInEaseOut
        let jumpDownAction = SKAction.move(to: self.mainCharNode.position, duration: 0.7)
        
        
        let jumpAction = SKAction.sequence([jumpUpAction, jumpDownAction])
        self.mainCharNode.run(jumpAction)
        
        //gameover check
        if self.isGameOver() == true {
            self.gameOverLabel.alpha = 1
        }
    }
    
    // Game Over Check
    // true:gameover
    // flase: stil ok
    func isGameOver() -> Bool{
        //screen pos 80% > char pos
//        self.view!.frame.height //画面のサイズ　（高さ）
        if self.mainCharNode.position.y > self.view!.frame.height / 2 - 150 {
            return true
        }
        
        return false
    
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //タッチしている指が移動した時に呼ばれる
        print("[debug] touchesMoved")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //画面から指が離れた時に呼ばれる
        print("[debug] touchesEnded")
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        //タッチ処理が継続できずに終了した時に呼び出される
        //基本的に touchesEndedと同様の処理
    }
    override func update(_ currentTime: TimeInterval ){
        // ゲームが60fpsで動作しているときに1秒間に60回呼び出される
        // 負荷などの理由により必ず同じタイミングで呼び出されるわけではないのでcurrentTimeの差分だけ処理をする
        
        //当たり判定 魚
        guard let fishNode = self.childNode(withName: "fish") else { return }
        let fishNodes = self.nodes(at: fishNode.position)
        //魚がいるかキャラと重なっているか
        if fishNodes.count > 1{
            self.gameOverLabel.alpha = 1
        }
        
        //サボテン
        guard let cactusNode = self.childNode(withName: "cactus") else { return }
        let cactusNodes = self.nodes(at: cactusNode.position)
        
        if cactusNodes.count > 1 {
            self.gameOverLabel.alpha = 1
        }
        
        
    }
    
    func addFish(){
        
        let fish = SKSpriteNode(imageNamed: "sakana.png")
        let yPos = CGFloat(Int.random(in: 0 ..< Int(self.view!.frame.height))) - self.view!.frame.height / 2
        
        fish.name = "fish"
        fish.position = CGPoint(
            x: self.view!.frame.width / 2 + 80,
            y: yPos
        )
        self.addChild(fish)
        let moveActionFish = SKAction.moveTo(x: self.view!.frame.width * -1, duration: 4)
        fish.run(
            SKAction.sequence([moveActionFish, SKAction.removeFromParent()])
        )
        
        
        let fishAttack = SKAction.run{
            self.addFish()
        }
        let newFishAction = SKAction.sequence([SKAction.wait(forDuration: 4), fishAttack])
        self.run(newFishAction)
        
    }
    
    func addCactus(){
        
        let cactus = SKSpriteNode(imageNamed: "sabo.png")
        
        cactus.name = "cactus"
        cactus.position = CGPoint(
            x: self.view!.frame.width / 2 + 80,
            y: self.view!.frame.height / -2 + 190
        )
        self.addChild(cactus)
        let moveActionCactus = SKAction.moveTo(x: self.view!.frame.width * -1, duration: 3)
        cactus.run(
            SKAction.sequence([moveActionCactus, SKAction.removeFromParent()])
        )
        
        let cactusAttack = SKAction.run{
            self.addCactus()
        }
        let newCactusAction = SKAction.sequence([SKAction.wait(forDuration: 3), cactusAttack])
        self.run(newCactusAction)
    }
}


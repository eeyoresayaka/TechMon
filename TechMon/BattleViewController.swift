//
//  BattleViewController.swift
//  TechMon
//
//  Created by 大島彩也夏 on 2023/05/12.
//

import UIKit

class BattleViewController: UIViewController {
    
    @IBOutlet var playerNameLabel: UILabel!
    @IBOutlet var playerImageView: UIImageView!
    @IBOutlet var playerHPBar: UIProgressView!
    
    @IBOutlet var enemyNameLabel: UILabel!
    @IBOutlet var enemyImageView: UIImageView!
    @IBOutlet var enemyHPBar: UIProgressView!
    
    var player: Player!
    var enemy: Enemy!
    
    var enemyAttackTimer: Timer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerHPBar.transform = CGAffineTransform(scaleX: 1.0, y: 4.0)
        enemyHPBar.transform = CGAffineTransform(scaleX: 1.0, y: 4.0)
        
        player = Player(name: "勇者", imageName: "yusya.png", attackPoint: 20, maxHP: 100)
        enemy = Enemy(name: "ドラゴン", imageName: "monster.png", attackPoint: 10, maxHP: 300)

        playerNameLabel.text = player.name
        playerImageView.image = player.image
        enemyNameLabel.text = enemy.name
        enemyImageView.image = enemy.image
        
        updataUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TechMonManager.playBGM(fileName: "BGM_battle001")
        
        enemyAttackTimer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(enemyAttack), userInfo: nil, repeats: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        TechMonManager.stopBGM()
    }
    
    func updataUI(){
        playerHPBar.progress = player.currentHP / player.maxHP
        enemyHPBar.progress = enemy.currentHP / enemy.maxHP
    }
    
    @IBAction func attackAction(){
        TechMonManager.damageAnimation(imageView: enemyImageView)
        TechMonManager.playSE(fileName: "SE_attack")
        
        enemy.currentHP -= player.attackPoint
        
        updataUI()
        
        if enemy.currentHP <= 0{
            finishBattle(vanishImageView: enemyImageView, isPlayerWin: true)
        }
    }
    
    @objc func enemyAttack(){
        TechMonManager.damageAnimation(imageView: playerImageView)
        TechMonManager.playSE(fileName: "SE_attack")
        
        player.currentHP -= enemy.attackPoint
        
        updataUI()
        if player.currentHP <= 0 {
            finishBattle(vanishImageView: playerImageView, isPlayerWin: false)
        }
    }
    
    func finishBattle(vanishImageView: UIImageView, isPlayerWin: Bool){
        TechMonManager.vanishAnimation(imageView: vanishImageView)
        TechMonManager.stopBGM()
        enemyAttackTimer.invalidate()
        
        var finishMessage: String = ""
        if isPlayerWin{
            TechMonManager.playSE(fileName: "SE_fanfare")
            finishMessage = "勇者の勝利！"
        } else {
            TechMonManager.playSE(fileName: "SE_gameover")
            finishMessage = "勇者の敗北..."
        }
        
        let alert = UIAlertController(
            title: "バトル終了", message: finishMessage, preferredStyle:  .alert)
        alert.addAction(UIAlertAction(title:"OK", style: .default, handler: { _ in self.dismiss(animated: true)}))
        present(alert, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

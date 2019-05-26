//
//  ViewController.swift
//  Nano Challenge
//
//  Created by Evan Christian on 19/05/19.
//  Copyright © 2019 Evan Christian. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

class ViewController: UIViewController {
   
    @IBOutlet weak var timeUpgradeImageViewShopView: UIImageView!
    @IBOutlet weak var timeUpgradeLabelShopView: UILabel!
    @IBOutlet weak var moneyUpgradeImageViewShopView: UIImageView!
    @IBOutlet weak var moneyUpgradeLabelShopView: UILabel!
    @IBOutlet weak var chevronImageViewShopView: UIImageView!
    @IBOutlet weak var shopImageViewShopView: UIImageView!
    @IBOutlet weak var totalUsableMoneyLabelShopView: UILabel!
    @IBOutlet weak var shopView: UIView!
    @IBOutlet weak var shopImageView: UIImageView!
    @IBOutlet weak var totalMoneyView: UIView!
    
    @IBOutlet weak var timerProgressView: UIProgressView!
    @IBOutlet weak var highScoreNumberLabel: UILabel!
    @IBOutlet weak var draggableView: UIView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var dollarSignLabel: UILabel!
    @IBOutlet weak var totalMoneyLabel: UILabel!
    @IBOutlet weak var swipeDownImageView: UIImageView!
    @IBOutlet weak var replayImageView: UIImageView!
    
    
    //iboutlet tutorialView
    @IBOutlet weak var tutorialView: UIView!
    @IBOutlet weak var draggableViewGreenTutorialView: UIView!
    @IBOutlet weak var innetViewGreenTutorialView: UIView!
    @IBOutlet weak var circleViewGreenTutorialView: UIView!
    @IBOutlet weak var swipeDownImageViewTutorialView: UIImageView!
    
    @IBOutlet weak var draggableViewRedTutorialView: UIView!
    @IBOutlet weak var innerViewRedTutorialView: UIView!
    @IBOutlet weak var circleViewRedTutorialView: UIView!
    @IBOutlet weak var swipeUpImageViewTutorialView: UIImageView!
    
    @IBOutlet weak var swipeRightImageViewTutorialView: UIImageView!
    //    var panGesture = UIPanGestureRecognizer()
    var totalMoney: Int = 0
    var money: Int = 2000
    var timer:Timer?
    var timeLeft: Float = 1
    var timeDecrease: Float = 0.04
    var player = AVAudioPlayer()
    
    var recordData: String!
    var tempCurrentMoney = 0
    var totalUsableMoney: Int = 0
    
    var redColorValue:Float = 0
    var greenColorValue:Float = 1
    var blueColorValue:Float = 0
    
    var timeUpgradeCost = 20000
    var moneyUpgradeCost = 20000
    
    var tempRandom = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
        shopView.isUserInteractionEnabled = false
        replayImageView.isUserInteractionEnabled = false
        replayImageView.isHidden = true
        replayImageView.alpha = 0
        
        view.backgroundColor = UIColor(red: CGFloat(redColorValue), green: CGFloat(greenColorValue), blue: CGFloat(blueColorValue), alpha: 1)
        totalMoneyView.backgroundColor = UIColor(red: CGFloat(redColorValue), green: CGFloat(greenColorValue), blue: CGFloat(blueColorValue), alpha: 1)
        
        let userTimeUpgradeDefaults = Foundation.UserDefaults.standard
        let valueTimeUpgrade = userTimeUpgradeDefaults.float(forKey: "Time Upgrade")
        if valueTimeUpgrade > 0{
            timeDecrease = valueTimeUpgrade
        }
        let userMoneyUpgradeDefaults = Foundation.UserDefaults.standard
        let valueMoneyUpgrade = userMoneyUpgradeDefaults.integer(forKey: "Money Upgrade")
        if valueMoneyUpgrade > 0{
            money = valueMoneyUpgrade
        }
        
        let userTimeUpgradeCostDefaults = Foundation.UserDefaults.standard
        let valueTimeUpgradeCost = userTimeUpgradeCostDefaults.integer(forKey: "Time Upgrade Cost")
        if valueTimeUpgradeCost > 0{
            timeUpgradeCost = valueTimeUpgradeCost
        }
        timeUpgradeLabelShopView.text = "\(timeUpgradeCost)"
        
        let userMoneyUpgradeCostDefaults = Foundation.UserDefaults.standard
        let valueMoneyUpgradeCost = userMoneyUpgradeCostDefaults.integer(forKey: "Money Upgrade Cost")
        if valueMoneyUpgradeCost > 0{
            moneyUpgradeCost = valueMoneyUpgradeCost
        }
        moneyUpgradeLabelShopView.text = "\(moneyUpgradeCost)"
        
        dollarSignLabel.text = "\(money)"
        totalMoneyLabel.text = "0"
        innerView.backgroundColor = UIColor(red: 133/255, green: 187/255, blue: 101/255, alpha: 1)
        draggableView.backgroundColor = UIColor(red: 232/255, green: 233/255, blue: 201/255, alpha: 1)
        circleView.backgroundColor = UIColor(red: 232/255, green: 233/255, blue: 201/255, alpha: 1)
        dollarSignLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        circleView.layer.cornerRadius = circleView.frame.size.width/2
        circleView.clipsToBounds = true
        let bottomSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        bottomSwipe.direction = .down
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        rightSwipe.direction = .right
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        leftSwipe.direction = .left
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        upSwipe.direction = .up
        draggableView.addGestureRecognizer(bottomSwipe)
        draggableView.addGestureRecognizer(rightSwipe)
        draggableView.addGestureRecognizer(leftSwipe)
        draggableView.addGestureRecognizer(upSwipe)
        
        let tapShop = UITapGestureRecognizer(target: self, action: #selector(tappedShop(_:)))
        shopImageView.addGestureRecognizer(tapShop)
        shopImageView.isUserInteractionEnabled = true
        
        shopView.isUserInteractionEnabled = true
        let tapBack = UITapGestureRecognizer(target: self, action: #selector(tappedBack(_:)))
        chevronImageViewShopView.addGestureRecognizer(tapBack)
        chevronImageViewShopView.isUserInteractionEnabled = true
        
        let userDefaults = Foundation.UserDefaults.standard
        let value = userDefaults.string(forKey: "Key")
        highScoreNumberLabel.text = value
        recordData = value
        
        
        let userUsableMoneyDefaults = Foundation.UserDefaults.standard
        let valueUsableMoney = userUsableMoneyDefaults.integer(forKey: "Usable Money")
        totalUsableMoney = valueUsableMoney
        totalUsableMoneyLabelShopView.text = "\(totalUsableMoney)"
        
        
        
//        let savedTimeUpgrade = self.timeDecrease
//        let userSavedTimeUpgradeDefaults = Foundation.UserDefaults.standard
//        userSavedTimeUpgradeDefaults.set(savedTimeUpgrade, forKey: "Time Upgrade")
//
//        let savedMoneyUpgrade = self.money
//        let userSavedMoneyUpgradeDefaults = Foundation.UserDefaults.standard
//        userSavedTimeUpgradeDefaults.set(savedMoneyUpgrade, forKey: "Money Upgrade")
//
//        let myNewView = UIView(frame: CGRect(x: 100, y: 200, width: 50, height: 50))
//        myNewView.backgroundColor = UIColor.black
//        view.addSubview(myNewView)
//        panGesture = UIPanGestureRecognizer(target: self, action: #selector(ViewController.draggedView(_:)))
//        draggableView.isUserInteractionEnabled = true
//        draggableView.addGestureRecognizer(panGesture)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        let userDefaults = Foundation.UserDefaults.standard
//        let value = userDefaults.string(forKey: "Key")
//        highScoreNumberLabel.text = value
//        recordData = value
//    }
    
    @objc func onTimerFires()
    {
        timeLeft -= timeDecrease
        timerProgressView.setProgress(Float(timeLeft), animated: true)
        
        redColorValue += timeDecrease
        greenColorValue -= timeDecrease
        
        view.backgroundColor = UIColor(red: CGFloat(redColorValue), green: CGFloat(greenColorValue), blue: CGFloat(blueColorValue), alpha: 1)
        totalMoneyView.backgroundColor = UIColor(red: CGFloat(redColorValue), green: CGFloat(greenColorValue), blue: CGFloat(blueColorValue), alpha: 1)
        
        if timeLeft <= 0 {
            timer?.invalidate()
            timer = nil
            let viewPosition = CGPoint(x: totalMoneyView.frame.origin.x, y: totalMoneyView.frame.origin.y - 400)
            UIView.animate(withDuration: 1){
                
                //vibrate
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.prepare()
                generator.impactOccurred()
                
                
                self.totalMoneyView.frame = CGRect(x: viewPosition.x, y: viewPosition.y, width: self.totalMoneyView.frame.size.width, height: self.totalMoneyView.frame.size.height)
                self.draggableView.alpha = 0
                self.draggableView.isUserInteractionEnabled = false
                
                self.totalUsableMoney += self.tempCurrentMoney
                self.totalUsableMoneyLabelShopView.text = "\(self.totalUsableMoney)"
                
                let savedUsableMoney = self.totalUsableMoney
                let userUsableMoneyDefaults = Foundation.UserDefaults.standard
                userUsableMoneyDefaults.set(savedUsableMoney, forKey: "Usable Money")
                
                self.replayImageView.isHidden = false
                self.replayImageView.isUserInteractionEnabled = true
                self.replayImageView.alpha = 1
                
                let tapReplay = UITapGestureRecognizer(target: self, action: #selector(self.tappedReplay(_:)))
                self.replayImageView.addGestureRecognizer(tapReplay)
                self.replayImageView.isUserInteractionEnabled = true
                
                let tempMoneyLabel = self.totalMoneyLabel.text
                
                //mau high score validasi
                if self.recordData == nil{
                    
                    self.playSound("success")
                    let savedString = self.highScoreNumberLabel.text
                    let userDefaults = Foundation.UserDefaults.standard
                    userDefaults.set(savedString, forKey: "Key")
                    
                    self.highScoreNumberLabel.text = "\(tempMoneyLabel ?? "0")"
                }else{
                    //let currentScore:Int? = Int(self.totalMoneyLabel.text!)
                    let record = Int(self.recordData!)
                    print(record)
                    print(self.tempCurrentMoney)
                    if self.tempCurrentMoney > record!{
                        print("masuk sini")
                        self.playSound("success")
                        self.highScoreNumberLabel.text = "\(tempMoneyLabel ?? "0")"
                        let savedString = self.highScoreNumberLabel.text
                        let userDefaults = Foundation.UserDefaults.standard
                        userDefaults.set(savedString, forKey: "Key")
                    }else{
                        self.playSound("fail")
                    }
                }
//                }
            }
        }
    }
    
    @objc func tappedReplay(_ sender: Any){
        let viewPosition = CGPoint(x: totalMoneyView.frame.origin.x, y: totalMoneyView.frame.origin.y + 400)
        UIView.animate(withDuration: 2){
            self.totalMoneyView.frame = CGRect(x: viewPosition.x, y: viewPosition.y, width: self.totalMoneyView.frame.size.width, height: self.totalMoneyView.frame.size.height)
            self.draggableView.alpha = 1
            self.draggableView.isUserInteractionEnabled = true
            self.replayImageView.isUserInteractionEnabled = false
            self.replayImageView.isHidden = true
            self.replayImageView.alpha = 0
            self.totalMoney = 0
            self.totalMoneyLabel.text = "\(self.totalMoney)"
            self.timerProgressView.progress = 1
            self.timeLeft = 1
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.onTimerFires), userInfo: nil, repeats: true)
            self.tempCurrentMoney = 0
            
            
            self.redColorValue -= 1
            self.greenColorValue += 1
            self.view.backgroundColor = UIColor(red: 1, green: CGFloat(self.greenColorValue), blue: CGFloat(self.blueColorValue), alpha: 1)
            self.totalMoneyView.backgroundColor = UIColor(red: CGFloat(self.redColorValue), green: CGFloat(self.greenColorValue), blue: CGFloat(self.blueColorValue), alpha: 1)
        }
    }
    
    @objc func tappedShop(_ sender: Any)
    {
        shopView.isHidden = false
        draggableView.isUserInteractionEnabled = false
        
        let tapTimeUpgrade = UITapGestureRecognizer(target: self, action: #selector(tappedTimeUpgrade(_ :)))
        timeUpgradeImageViewShopView.addGestureRecognizer(tapTimeUpgrade)
        timeUpgradeImageViewShopView.isUserInteractionEnabled = true
        
        let tapMoneyUpgrade = UITapGestureRecognizer(target: self, action: #selector(tappedMoneyUpgrade(_ :)))
        moneyUpgradeImageViewShopView.addGestureRecognizer(tapMoneyUpgrade)
        moneyUpgradeImageViewShopView.isUserInteractionEnabled = true
//        let generator = UIImpactFeedbackGenerator(style: .medium)
//        generator.prepare()
//        generator.impactOccurred()
    }
    
    @objc func tappedBack(_ sender: Any)
    {
        shopView.isHidden = true
        draggableView.isUserInteractionEnabled = true
    }
    
    @objc func tappedTimeUpgrade(_ sender: Any)
    {
        print("time upgrade")
        if totalUsableMoney >= timeUpgradeCost{
            timeDecrease -= 0.005
            totalUsableMoney -= timeUpgradeCost
            totalUsableMoneyLabelShopView.text = "\(totalUsableMoney)"
            timeUpgradeCost *= 2
            timeUpgradeLabelShopView.text = "\(timeUpgradeCost)"
            
            //save upgrade time
            let savedTimeUpgrade = self.timeDecrease
            let userTimeUpgradeDefaults = Foundation.UserDefaults.standard
            userTimeUpgradeDefaults.set(savedTimeUpgrade, forKey: "Time Upgrade")
            
            //save upgrade time cost
            let savedTimeUpgradeCost = self.timeUpgradeCost
            let userTimeUpgradeCostDefaults = Foundation.UserDefaults.standard
            userTimeUpgradeCostDefaults.set(savedTimeUpgradeCost, forKey: "Time Upgrade Cost")
        }else{
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.prepare()
            generator.impactOccurred()
        }
    }
    
    @objc func tappedMoneyUpgrade(_ sender: Any)
    {
        print("money upgrade")
        if totalUsableMoney >= moneyUpgradeCost{
            money += 1000
            totalUsableMoney -= moneyUpgradeCost
            totalUsableMoneyLabelShopView.text = "\(totalUsableMoney)"
            self.dollarSignLabel.text = "\(self.money)"
            moneyUpgradeCost *= 2
            moneyUpgradeLabelShopView.text = "\(moneyUpgradeCost)"
            
            //save upgrade money
            let savedMoneyUpgrade = self.money
            let userMoneyUpgradeDefaults = Foundation.UserDefaults.standard
            userMoneyUpgradeDefaults.set(savedMoneyUpgrade, forKey: "Money Upgrade")
            
            //save upgrade money cost
            let savedMoneyUpgradeCost = self.moneyUpgradeCost
            let userMoneyUpgradeCostDefaults = Foundation.UserDefaults.standard
            userMoneyUpgradeCostDefaults.set(savedMoneyUpgradeCost, forKey: "Money Upgrade Cost")
        }else{
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.prepare()
            generator.impactOccurred()
        }
    }
//    @IBAction func replayTouched(_ sender: Any) {
//        let viewPosition = CGPoint(x: totalMoneyView.frame.origin.x, y: totalMoneyView.frame.origin.y + 400)
//        UIView.animate(withDuration: 1){
//            self.totalMoneyView.frame = CGRect(x: viewPosition.x, y: viewPosition.y, width: self.totalMoneyView.frame.size.width, height: self.totalMoneyView.frame.size.height)
//            self.draggableView.alpha = 1
//            self.draggableView.isUserInteractionEnabled = true
//            self.replayButton.isEnabled = false
//            self.replayButton.alpha = 0
//            self.totalMoney = 0
//            self.totalMoneyLabel.text = "\(self.totalMoney)"
//            self.timerProgressView.progress = 1
//            self.timeLeft = 1
//            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.onTimerFires), userInfo: nil, repeats: true)
//            self.tempCurrentMoney = 0
//        }
//    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        if (sender.direction == .down) {
            print("Swipe Down")
            let viewPosition = CGPoint(x: draggableView.frame.origin.x, y: draggableView.frame.origin.y + 400)
            UIView.animate(withDuration: 0.2, animations: {
                self.swipeDownImageView.alpha = 0
                self.draggableView.frame = CGRect(x: viewPosition.x, y: viewPosition.y, width: self.draggableView.frame.size.width, height: self.draggableView.frame.size.height)
                self.draggableView.alpha = 0
                if self.tempRandom == 1 {
                    self.playSound("cashSound")
                    self.totalMoney += self.money
                    self.tempCurrentMoney += self.money
                }else if self.tempRandom == 2 {
                    self.totalMoney -= self.money
                    self.tempCurrentMoney -= self.money
                }
                self.totalMoneyLabel.text = "\(self.totalMoney)"
            }) { (isFinished) in
                self.originalPos()
                self.showMoney()
            }
        }else if(sender.direction == .right){
            print("Swipe Right")
            let viewPosition = CGPoint(x: draggableView.frame.origin.x + 400, y: draggableView.frame.origin.y)
            UIView.animate(withDuration: 0.2, animations: {
                self.draggableView.frame = CGRect(x: viewPosition.x, y: viewPosition.y, width: self.draggableView.frame.size.width, height: self.draggableView.frame.size.height)
                self.draggableView.alpha = 0
            }) { (isFinished) in
                self.originalPos()
                self.showMoney()
            }
        }else if(sender.direction == .up){
            print("Swipe Up")
            let viewPosition = CGPoint(x: draggableView.frame.origin.x, y: draggableView.frame.origin.y - 400)
            UIView.animate(withDuration: 0.2, animations: {
                self.draggableView.frame = CGRect(x: viewPosition.x, y: viewPosition.y, width: self.draggableView.frame.size.width, height: self.draggableView.frame.size.height)
                self.draggableView.alpha = 0
            }) { (isFinished) in
                self.originalPos()
                self.showMoney()
            }
        }else if(sender.direction == .left){
            print("Swipe Left")
            let viewPosition = CGPoint(x: draggableView.frame.origin.x - 400, y: draggableView.frame.origin.y)
            UIView.animate(withDuration: 0.2, animations: {
                self.draggableView.frame = CGRect(x: viewPosition.x, y: viewPosition.y, width: self.draggableView.frame.size.width, height: self.draggableView.frame.size.height)
                self.draggableView.alpha = 0
            }) { (isFinished) in
                self.originalPos()
                self.showMoney()
            }
        }
    }
    func originalPos(){
        draggableView.frame = CGRect(x: 85, y: -50, width: self.draggableView.frame.size.width, height: self.draggableView.frame.size.height)
    }
    
    func showMoney(){
        UIView.animate(withDuration: 0.2){
            self.draggableView.frame = CGRect(x: 88, y: 116, width: self.draggableView.frame.size.width, height: self.draggableView.frame.size.height)
            self.draggableView.alpha = 1
            self.tempRandom = self.randomMoney()
            print(self.tempRandom)
            if self.tempRandom == 1{
                self.innerView.backgroundColor = UIColor(red: 133/255, green: 187/255, blue: 101/255, alpha: 1)
                self.draggableView.backgroundColor = UIColor(red: 232/255, green: 233/255, blue: 201/255, alpha: 1)
                self.circleView.backgroundColor = UIColor(red: 232/255, green: 233/255, blue: 201/255, alpha: 1)
            }else if self.tempRandom == 2{
                self.innerView.backgroundColor = UIColor(red: 252/255, green: 42/255, blue: 27/255, alpha: 1)
                self.draggableView.backgroundColor = UIColor(red: 208/255, green: 0/255, blue: 0/255, alpha: 1)
                self.circleView.backgroundColor = UIColor(red: 208/255, green: 0/255, blue: 0/255, alpha: 1)
            }
            self.dollarSignLabel.text = "\(self.money)"
        }
    }
    
    
    func randomMoney() -> Int{
        var randomMoneyValue: [Int] = [1,2]
        let random = Int.random(in: 0...1)
        return randomMoneyValue[random]
    }
    
    func playSound(_ soundName: String){
        let sound = Bundle.main.path(forResource: soundName, ofType: "mp3")
        do{
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
            player.play()
        }
        catch{
            print(error)
        }
    }
    
    
    
//    @objc func draggedView(_ sender:UIPanGestureRecognizer){
//        self.view.bringSubviewToFront(draggableView)
//        let translation = sender.translation(in: self.view)
//        draggableView.center = CGPoint(x: draggableView.center.x + translation.x, y: draggableView.center.y + translation.y)
//        sender.setTranslation(CGPoint.zero, in: self.view)
//        if draggableView.center == CGPoint(x: 30, y: 200) {
//            print("test3")
//            UIView.animate(withDuration: 2){
//                self.draggableView.transform = CGAffineTransform(translationX: 0, y: 20)
//                self.draggableView.alpha = 0
//            }
//
//        }
//    }

}


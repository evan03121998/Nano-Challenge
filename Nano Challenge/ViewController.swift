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
   
    @IBOutlet weak var chevronImageViewShopView: UIImageView!
    @IBOutlet weak var shopImageViewShopView: UIImageView!
    @IBOutlet weak var shopView: UIView!
    @IBOutlet weak var shopImageView: UIImageView!
    @IBOutlet weak var totalMoneyView: UIView!
    @IBOutlet weak var timeLabel: UILabel!

    @IBOutlet weak var highScoreNumberLabel: UILabel!
    @IBOutlet weak var draggableView: UIView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var dollarSignLabel: UILabel!
    @IBOutlet weak var totalMoneyLabel: UILabel!
    @IBOutlet weak var swipeDownLabel: UILabel!
    @IBOutlet weak var replayButton: UIButton!
    //    var panGesture = UIPanGestureRecognizer()
    var totalMoney: Int = 0
    var tempMoney: Int = 2000
    var timer:Timer?
    var timeLeft = 30
    var player = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
        shopView.isUserInteractionEnabled = false
        replayButton.isEnabled = false
        replayButton.alpha = 0
//        tempMoney = randomMoney()
        timeLabel.text = "\(timeLeft) seconds left"
        dollarSignLabel.text = "Rp. \(tempMoney)"
        totalMoneyLabel.text = "Rp. 0"
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
//        let myNewView = UIView(frame: CGRect(x: 100, y: 200, width: 50, height: 50))
//        myNewView.backgroundColor = UIColor.black
//        view.addSubview(myNewView)
//        panGesture = UIPanGestureRecognizer(target: self, action: #selector(ViewController.draggedView(_:)))
//        draggableView.isUserInteractionEnabled = true
//        draggableView.addGestureRecognizer(panGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let userDefaults = Foundation.UserDefaults.standard
        let value = userDefaults.string(forKey: "Key")
        highScoreNumberLabel.text = value
    }
    
    @objc func tappedShop(_ sender: Any)
    {
        shopView.isHidden = false
        draggableView.isUserInteractionEnabled = false
    }
    
    @objc func tappedBack(_ sender: Any)
    {
        print("tap back")
        shopView.isHidden = true
        draggableView.isUserInteractionEnabled = true
    }
    
    @objc func onTimerFires()
    {
        timeLeft -= 1
        timeLabel.text = "\(timeLeft) seconds left"
        
        if timeLeft <= 0 {
            timer?.invalidate()
            timer = nil
            let viewPosition = CGPoint(x: totalMoneyView.frame.origin.x, y: totalMoneyView.frame.origin.y - 400)
            UIView.animate(withDuration: 1){
                self.totalMoneyView.frame = CGRect(x: viewPosition.x, y: viewPosition.y, width: self.totalMoneyView.frame.size.width, height: self.totalMoneyView.frame.size.height)
                self.draggableView.alpha = 0
                self.draggableView.isUserInteractionEnabled = false
                self.replayButton.isEnabled = true
                self.replayButton.alpha = 1
                
                let tempMoneyLabel = self.totalMoneyLabel.text
//                tempMoneyLabel.
//                var intTempMoneyLabel: Int = 0
//                if let temp = Int(tempMoneyLabel ?? "0"){
//                    intTempMoneyLabel = temp
//                }
//                var intHighScoreNumberLabel: Int = 0
//                if let temp = Int(self.highScoreNumberLabel.text ?? "0"){
//                    intHighScoreNumberLabel = temp
//                }
//                if intTempMoneyLabel > intHighScoreNumberLabel{
                self.highScoreNumberLabel.text = "\(tempMoneyLabel ?? "0")"
                
                let savedString = self.highScoreNumberLabel.text
                let userDefaults = Foundation.UserDefaults.standard
                userDefaults.set(savedString, forKey: "Key")
//                }
            }
        }
    }
    @IBAction func replayTouched(_ sender: Any) {
        let viewPosition = CGPoint(x: totalMoneyView.frame.origin.x, y: totalMoneyView.frame.origin.y + 400)
        UIView.animate(withDuration: 1){
            self.totalMoneyView.frame = CGRect(x: viewPosition.x, y: viewPosition.y, width: self.totalMoneyView.frame.size.width, height: self.totalMoneyView.frame.size.height)
            self.draggableView.alpha = 1
            self.draggableView.isUserInteractionEnabled = true
            self.replayButton.isEnabled = false
            self.replayButton.alpha = 0
            self.totalMoney = 0
            self.totalMoneyLabel.text = "\(self.totalMoney)"
            self.timeLeft = 30
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.onTimerFires), userInfo: nil, repeats: true)        }
    }
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        if (sender.direction == .down) {
            print("Swipe Down")
            let viewPosition = CGPoint(x: draggableView.frame.origin.x, y: draggableView.frame.origin.y + 400)
            UIView.animate(withDuration: 0.5, animations: {
                self.swipeDownLabel.alpha = 0
                self.draggableView.frame = CGRect(x: viewPosition.x, y: viewPosition.y, width: self.draggableView.frame.size.width, height: self.draggableView.frame.size.height)
                self.draggableView.alpha = 0
                self.playSound("cashSound")
                self.totalMoney += self.tempMoney
                self.totalMoneyLabel.text = "Rp. \(self.totalMoney)"
            }) { (isFinished) in
                self.originalPos()
                self.showMoney()
            }
        }else if(sender.direction == .right){
            print("Swipe Right")
            let viewPosition = CGPoint(x: draggableView.frame.origin.x + 400, y: draggableView.frame.origin.y)
            UIView.animate(withDuration: 0.5, animations: {
                self.draggableView.frame = CGRect(x: viewPosition.x, y: viewPosition.y, width: self.draggableView.frame.size.width, height: self.draggableView.frame.size.height)
                self.draggableView.alpha = 0
            }) { (isFinished) in
                self.originalPos()
                self.showMoney()
            }
        }else if(sender.direction == .up){
            print("Swipe Up")
            let viewPosition = CGPoint(x: draggableView.frame.origin.x, y: draggableView.frame.origin.y - 400)
            UIView.animate(withDuration: 0.5, animations: {
                self.draggableView.frame = CGRect(x: viewPosition.x, y: viewPosition.y, width: self.draggableView.frame.size.width, height: self.draggableView.frame.size.height)
                self.draggableView.alpha = 0
            }) { (isFinished) in
                self.originalPos()
                self.showMoney()
            }
        }else if(sender.direction == .left){
            print("Swipe Left")
            let viewPosition = CGPoint(x: draggableView.frame.origin.x - 400, y: draggableView.frame.origin.y)
            UIView.animate(withDuration: 0.5, animations: {
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
        UIView.animate(withDuration: 0.5){
            self.draggableView.frame = CGRect(x: 88, y: 116, width: self.draggableView.frame.size.width, height: self.draggableView.frame.size.height)
            self.draggableView.alpha = 1
            self.dollarSignLabel.text = "Rp. \(self.tempMoney)"
        }
    }
//    func randomMoney() -> Int{
//        var randomMoneyValue: [Int] = [1,5,20,50,100]
//        let random = Int.random(in: 0...4)
//        return randomMoneyValue[random]
//    }
    
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


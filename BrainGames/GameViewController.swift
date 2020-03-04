//
//  ViewController.swift
//  BrainGames
//
//  Created by Student Laptop_7/19_1 on 12/9/19.
//  Copyright © 2019 Makeschool. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet var sceneView: UIView!
    @IBOutlet weak var meaningLabel: UILabel!
    
    @IBOutlet weak var colorTextLabelTwo: UILabel!
    @IBOutlet weak var colorTextLabelOne: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var upsideImageView: UIImageView!
    
    @IBOutlet weak var upImageView: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!
    
    
    var score: Int = 0 {
        didSet {
            if self.score > self.highScore{
                self.highScore = self.score
            }
            self.scoreLabel.text = "Score: \(self.score)"
        }
        
    }
    
    var highScore: Int = 0
    
    var timerCount: Int = 60{
        didSet{
            if self.timerCount < 0 {
                endGame()
            }
        }
    }
    var message: String = "Game Over!"
    
    let colors: [String:UIColor] = ["red": .red,
                                    "magenta": .magenta,
                                    "green": .green,
                                    "yellow": .yellow,
                                    "purple": .purple,
                                    "orange": .orange,
                                    "cyan": .cyan,
                                    "black": .black,
                                    "blue": .blue,
                                    "brown": .brown,
                                    "gray": .gray]
    
    
    var currentColor = UIColor()

    var currentText: String = ""
    
    // view will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // hide navbar
        navigationController?.setNavigationBarHidden(true, animated: animated)
        print("made it to gameVC")
        self.highScore = UserDefaults.standard.integer(forKey: "highScore")
    }
    
    
    // loads the view
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
        refreshGame()
        runTimer()
    }
    
    // pass high score to result view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EndViewSegue" {
            if let resultViewController = segue.destination as? EndViewController {
                resultViewController.highScore = self.score
                resultViewController.message = self.message
                
            }
        }
    }
    
    // style for user view
    func setupScene() {
        meaningLabel.layer.masksToBounds = true
        colorTextLabelOne.layer.masksToBounds = true
        meaningLabel.layer.cornerRadius = 20
        colorTextLabelOne.layer.cornerRadius = 20
        yesButton.layer.cornerRadius = 5
        yesButton.addTarget(self, action: #selector(yesButtonTapped), for: .touchUpInside)
        noButton.layer.cornerRadius = 5
        noButton.addTarget(self, action: #selector(noButtonTapped), for: .touchUpInside)
        yesButton.backgroundColor = UIColor.init(displayP3Red: 30, green: 30, blue: 30, alpha: 0.4)
        noButton.backgroundColor = UIColor.init(displayP3Red: 30, green: 30, blue: 30, alpha: 0.4)
        scoreLabel.backgroundColor = UIColor.init(displayP3Red: 0, green: 0, blue: 0, alpha: 0.2)
        scoreLabel.textColor = UIColor(white: 1, alpha: 0.5)
        timerLabel.backgroundColor = UIColor.init(displayP3Red: 0, green: 0, blue: 0, alpha: 0.2)
        timerLabel.textColor = UIColor(white: 1, alpha: 0.5)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "viewBg.jpg")!)
    }
    
    @objc func yesButtonTapped() {
        score += checkAnswer(button: true)
        refreshGame()
    }
    
    @objc func noButtonTapped() {
        score += checkAnswer(button: false)
        refreshGame()
    }
    
    
    func checkAnswer(button: Bool) -> Int{
        var score: Int = 0
        
        let currentTextUIColor = colors[currentText]
        
        switch button {
        case true:
            
            if currentTextUIColor == currentColor {
                score += 10
            }else{
                score -= 10
            }
            break
        case false:
            
            if currentTextUIColor == currentColor {
                score -= 10
            }else{
                score += 10
            }
            break
        }
        
        return score
    }
    
    
    
    
    func runTimer() {
        _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.timerCount -= 1
            self.timerLabel.text = "Time  0:"+String(self.timerCount)+""
            
            if self.timerCount < 0 {
                UserDefaults.standard.set(self.highScore, forKey: "highScore")
                self.message = "Time is Up!"
                self.performSegue(withIdentifier: "EndViewSegue", sender: self)
                
                timer.invalidate()
                
            }
            if self.timerCount < 5 {
                self.scoreLabel.text = ""
                self.scoreLabel.font = UIFont.systemFont(ofSize: 40)
                self.animate(time: "0:"+String(self.timerCount))
                self.scoreLabel.textColor = UIColor.white
            }
        }
    }
    
    
    func animate(time: String, color:UIColor = .white) {
        // Fade out to set the text
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.scoreLabel.alpha = 0.0
        }, completion: {
            (finished: Bool) -> Void in
            
            //Once the label is completely invisible, set the text and fade it back in
            if ((color == .green) || (color == .red)){
                self.scoreLabel.textColor = color
            }
            self.scoreLabel.text = time
            
            // Fade in
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.scoreLabel.alpha = 1.0
            }, completion: nil)
        })
    }
    
   
    
    
    func IncreaseDifficulty() {
        if (score  > 50) && (score <= 100){
            timerCount -= 1
        }
        else if (score > 100) && (score <= 150){
            timerCount -= 2
        }
        else if (score > 150) && (score <= 200){
            timerCount -= 3
        }
        else if (score > 200) && (score < 250){
            timerCount -= 4
        }
        
    }
    
    // controls current game attributes
    func refreshGame(){
        IncreaseDifficulty()
        
        let randomBool = Bool.random() //Create random Boolean
        if randomBool { //if true... select random color for currenttext and currentColor
            currentText = colors.randomElement()!.key
            currentColor = colors.randomElement()!.value
        } else { //if false... show the same random color
            let randomIndex = Int.random(in: 0..<colors.count) // choose a random index from 0 to number of colors in Colors Dictionary
            
            let textColorArray = Array(colors.keys) //create an array of keys, which for colors dictionary, will be the strings of color
            let colorArray = Array(colors.values) //creates an array of UIColors from colors dictionary
            
            currentText = textColorArray[randomIndex] //we are assigning a random textColor by passing a randomIndex to our array of textColors
            currentColor = colorArray[randomIndex] //we pass in randomIndex into our array of colors
        }
            
        
        colorTextLabelOne.text = currentText
//        colorTextLabelOne.textColor = currentColor
        
        colorTextLabelTwo.text = currentText
        colorTextLabelTwo.textColor = currentColor
        
        
        
    }
    
    func endGame(){
        if (score <= -1) {
            score = 0
            scoreLabel.text = "HighScore   "+String(highScore)+""
            self.timerCount = 0
            self.performSegue(withIdentifier: "EndViewSegue", sender: self)
            
        } else {
            scoreLabel.text = "Score  "+String(score)+""
        }
    }
    
    
    // user clicks wrong answer
    func check(winOrLose:Bool) {
        var color:UIColor = .white
        var messageStr:String = ""
        
        if (winOrLose == true) {
            self.score += 10
            self.highScore += 10
            color = .green
            messageStr = "Correct! +10"
        }
        else {
            self.score -= 10
            color = .red
            messageStr = "Wrong! -10"
        }
        
        
        self.animate(time: messageStr, color: color)
    }
    
    
}

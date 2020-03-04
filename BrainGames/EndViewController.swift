//
//  ViewController.swift
//  BrainGames
//
//  Created by Student Laptop_7/19_1 on 12/9/19.
//  Copyright © 2019 Makeschool. All rights reserved.
//

import UIKit

class EndViewController: UIViewController {


    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!
    
    @IBOutlet var finalScoreLabel: UILabel!
    
            
            var highScore: Int = 0
            var message: String = ""
            
            // view will appear
            override func viewWillAppear(_ animated: Bool) {
              super.viewWillAppear(animated)
                // hide navbar
              navigationController?.setNavigationBarHidden(true, animated: animated)
                
            }
            

        //    override func viewWillDisappear(_ animated: Bool) {
        //        super.viewWillDisappear(animated)
        //
        //        // Show the navigation bar on other view controllers
        //        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        //    }

            override func viewDidLoad() {
                super.viewDidLoad()
                // Do any additional setup after loading the view.
                
                setupScene()
            }
            
            func setupScene() {
                playAgainButton.layer.masksToBounds = true
                playAgainButton.layer.cornerRadius = 20
                
                playAgainButton.backgroundColor = UIColor.init(displayP3Red: 30, green: 30, blue: 30, alpha: 0.4)
                
                highScoreLabel.text = "\(UserDefaults.standard.integer(forKey: "highScore"))"
                
                finalScoreLabel.text = String(highScore)+" points"
            }

                    
    
//            @IBAction func playAgain(_ sender: Any) {
//        //        let navigationController = self.presentingViewController as? UINavigationController
//        //
//        //        self.dismiss(animated: false) {
//        //          let _ = navigationController?.popToRootViewController(animated: false)
//        //        }
//        //
//        //
//            }
}


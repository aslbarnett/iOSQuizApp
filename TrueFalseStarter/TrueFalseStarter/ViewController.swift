//
//  ViewController.swift
//  TrueFalseStarter
//
//  Created by Pasan Premaratne on 3/9/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit
import GameKit
import AudioToolbox

class ViewController: UIViewController {
    
    var questionDictionary: Question = Question(question: "", answer: "", options: [])
    
    let questionsPerRound = 4
    var questionsAsked = 0
    var correctQuestions = 0
    var indexOfSelectedQuestion: Int = 0
    
    var gameSound: SystemSoundID = 0
    
    let questionProvider = QuestionProvider()
    
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!
    
    var buttonsArray = [UIButton]()
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadGameStartSound()
        // Start game
        playGameStartSound()
        displayQuestion()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createOptionButton(extra: CGFloat, title: String) -> UIButton {
        var optionButton: UIButton!
        optionButton = UIButton(type: .system)
        
        optionButton.setTitle("Animate Auto Layout", for: .normal)
        optionButton.bounds = CGRect(x: 0, y: 0, width: 300, height: 80)
        optionButton.center = CGPoint(x: view.bounds.width / 2, y: 80 + 80 + 6 + 8 + extra)
        optionButton.backgroundColor = UIColor.yellow
        optionButton.setTitle(title, for: .normal)
        
        optionButton.addTarget(self, action:#selector(checkAnswer(_:)), for: .touchUpInside)
        
        return optionButton
        
//        view.addSubview(optionButton)
    }
    
    func displayQuestion() {
        questionDictionary = questionProvider.randomQuestion()
        questionField.text = questionDictionary.question
        
        for (index, option) in questionDictionary.options.enumerated() {
            let button = createOptionButton(extra: CGFloat(100 * (index + 1)), title: option)
            view.addSubview(button)
            buttonsArray.append(button)
        }
        playAgainButton.isHidden = true
    }
    
    func displayScore() {
        
        // Display play again button
        playAgainButton.isHidden = false
        
        questionField.text = "Way to go!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
        
    }
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        // Increment the questions asked counter
        questionsAsked += 1
        
        let correctAnswer = questionDictionary.answer
        
        print(sender.currentTitle!)
        print(correctAnswer)
        
        if (sender.currentTitle! == correctAnswer) {
            correctQuestions += 1
            questionField.text = "Correct!"
        } else {
            questionField.text =  "Sorry, wrong answer!"
        }
        
        loadNextRoundWithDelay(seconds: 2)
    }
    
    func nextRound() {
        if questionsAsked == questionsPerRound {
            // Game is over
            displayScore()
        } else {
            // Continue game
            displayQuestion()
        }
    }
    
    @IBAction func playAgain() {
        
        questionsAsked = 0
        correctQuestions = 0
        nextRound()
    }
    

    
    // MARK: Helper Methods
    
    func loadNextRoundWithDelay(seconds: Int) {
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)
        
        // Executes the nextRound method at the dispatch time on the main queue
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            for button in self.buttonsArray {
                button.removeFromSuperview()
            }
            self.nextRound()
        }
    }
    
    func loadGameStartSound() {
        let pathToSoundFile = Bundle.main.path(forResource: "GameSound", ofType: "wav")
        let soundURL = URL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &gameSound)
    }
    
    func playGameStartSound() {
        AudioServicesPlaySystemSound(gameSound)
    }
}


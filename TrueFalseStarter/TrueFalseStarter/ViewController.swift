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
    
    /* -+-+-+----------------------------------------+-+-+-
     Class Variables
     -+-+-+----------------------------------------+-+-+- */
    
    var questionDictionary: Question = Question(question: "", answer: "", options: [])
    
    let questionsPerRound = 4
    var questionsAsked = 0
    var correctQuestions = 0
    var indexOfSelectedQuestion: Int = 0
    
    var gameSound: SystemSoundID = 0
    var correctAnswer: SystemSoundID = 1
    var incorrectAnswer: SystemSoundID = 2
    
    let questionProvider = QuestionProvider()
    
    @IBOutlet weak var questionField: UILabel!
    
    var buttonsArray = [UIButton]()
    
    var playAgainButton: UIButton!
    var listToBeFiltered: [Question] = []
    
    var timerLabel: UILabel!
    
    var seconds = 15
    var timer = Timer()
    var isTimeRunning = false
    
    var nextQuestionButton: UIButton!
    
    var resultLabel: UILabel!
    
    var colorArray = [UIColor(red: 239/255, green: 71/255, blue: 111/255, alpha: 1), UIColor(red: 255/255, green: 209/255, blue: 102/255, alpha: 1), UIColor(red: 38/255, green: 84/255, blue: 124/255, alpha: 1), UIColor(red: 6/255, green: 214/255, blue: 160/255, alpha: 1)]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadGameStartSound()
        loadCorrectAnswerSound()
        loadIncorrectAnswerSound()
        // Start game
        playGameStartSound()
        displayQuestion()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* -+-+-+----------------------------------------+-+-+-
     Run Lightning Timer Method
     -+-+-+----------------------------------------+-+-+- */
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    /* -+-+-+----------------------------------------+-+-+-
     Create Lightning Timer Method
     -+-+-+----------------------------------------+-+-+- */
    
    func createTimer() {
        timerLabel = UILabel()
        timerLabel.text = "15"
        timerLabel.textColor = UIColor(red: 38/255, green: 84/255, blue: 124/255, alpha: 1)
        timerLabel.font = timerLabel.font.withSize(60)
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(timerLabel)
        let horConstraint = NSLayoutConstraint(item: timerLabel, attribute: .centerX, relatedBy: .equal,
                                               toItem: view, attribute: .centerX,
                                               multiplier: 1.0, constant: 0.0)
        let bottomButtonEdgeConstraint = NSLayoutConstraint(item: timerLabel, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: -20)
        
        view.addConstraints([horConstraint, bottomButtonEdgeConstraint])
    }
    
    /* -+-+-+----------------------------------------+-+-+-
     Create Answer Option Button Method
     -+-+-+----------------------------------------+-+-+- */
    
    func createOptionButton(extra: CGFloat, title: String) -> UIButton {
        var optionButton: UIButton!
        optionButton = UIButton(type: .system)
        
        optionButton.setTitle("Animate Auto Layout", for: .normal)
        optionButton.bounds = CGRect(x: 0, y: 0, width: 300, height: 80)
        optionButton.setTitle(title, for: .normal)
        optionButton.setTitleColor(UIColor.white, for: .normal)
        optionButton.layer.cornerRadius = 25
        
        optionButton.addTarget(self, action:#selector(checkAnswer(_:)), for: .touchUpInside)
        return optionButton
    }
    
    /* -+-+-+----------------------------------------+-+-+-
     Create Play Again Button Method
     -+-+-+----------------------------------------+-+-+- */
    
    func createPlayAgainButton(extra: CGFloat, title: String) -> UIButton {
        var optionButton: UIButton!
        optionButton = UIButton(type: .system)
        
        optionButton.setTitle("Animate Auto Layout", for: .normal)
        optionButton.bounds = CGRect(x: 0, y: 0, width: 300, height: 80)
        optionButton.backgroundColor = UIColor(red: 77/255, green: 77/255, blue: 77/255, alpha: 1)
        optionButton.setTitleColor(UIColor.white, for: .normal)
        optionButton.setTitle(title, for: .normal)
        optionButton.layer.cornerRadius = 25
        
        optionButton.addTarget(self, action:#selector(playAgain(_:)), for: .touchUpInside)
        return optionButton
    }
    
    /* -+-+-+----------------------------------------+-+-+-
     Create Next Question Button Method
     -+-+-+----------------------------------------+-+-+- */
    
    func createNextQuestionButton(extra: CGFloat, title: String) -> UIButton {
        var optionButton: UIButton!
        optionButton = UIButton(type: .system)
        
        optionButton.setTitle("Animate Auto Layout", for: .normal)
        optionButton.bounds = CGRect(x: 0, y: 0, width: 300, height: 80)
        optionButton.backgroundColor = UIColor(red: 77/255, green: 77/255, blue: 77/255, alpha: 1)
        optionButton.setTitleColor(UIColor.white, for: .normal)
        optionButton.setTitle(title, for: .normal)
        optionButton.layer.cornerRadius = 25
        
        optionButton.addTarget(self, action:#selector(loadNextRoundWithDelay(_:)), for: .touchUpInside)
        return optionButton
    }
    
    /* -+-+-+----------------------------------------+-+-+-
     Create Correct/Incorrect/OutOfTime Message Label Method
     -+-+-+----------------------------------------+-+-+- */
    
    func createResultLabel(text: String) -> UILabel {
        let result = UILabel()
        result.text = text
        return result
    }
    
    /* -+-+-+----------------------------------------+-+-+-
     Update Lightning Timer Method
     -+-+-+----------------------------------------+-+-+- */
    
    func updateTimer() {
        if seconds == 0 {
            playIncorrectAnswerSound()
            timer.invalidate()
            resultLabel = createResultLabel(text: "OUT OF TIME!!")
            resultLabel.textColor = colorArray[0]
            resultLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
            view.addSubview(resultLabel)
            resultLabel.translatesAutoresizingMaskIntoConstraints = false
            
            // --++-->> constraints
            let horConstraint = NSLayoutConstraint(item: resultLabel, attribute: .centerX, relatedBy: .equal,
                                                   toItem: view, attribute: .centerX,
                                                   multiplier: 1.0, constant: 0.0)
            let topButtonEdgeConstraint = NSLayoutConstraint(item: resultLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 120)
            view.addConstraints([topButtonEdgeConstraint, horConstraint])
            for button in buttonsArray {
                if button.currentTitle! == questionDictionary.answer {
                    button.backgroundColor = UIColor(red: 77/255, green: 77/255, blue: 77/255, alpha: 1)
                }
            }
            // --++-->> increase questions asked count by 1
            questionsAsked += 1
            
            // --++-->> remove timer from super view and reset to 15 seconds
            self.timerLabel.removeFromSuperview()
            self.seconds = 15
            
            // --++-->> display next question button
            nextQuestionButton = createNextQuestionButton(extra: 0, title: "Next Question")
            
            view.addSubview(nextQuestionButton)
            
            // --++-->> next question button constraints
            nextQuestionButton.translatesAutoresizingMaskIntoConstraints = false
            let leftButtonEdgeConstraint = NSLayoutConstraint(item: nextQuestionButton, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 20)
            let rightButtonEdgeConstraint = NSLayoutConstraint(item: nextQuestionButton, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: -20)
            let bottomButtonEdgeConstraint = NSLayoutConstraint(item: nextQuestionButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: -20)
            let heightConstraint = NSLayoutConstraint(item: nextQuestionButton, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
            view.addConstraints([leftButtonEdgeConstraint, rightButtonEdgeConstraint, bottomButtonEdgeConstraint, heightConstraint])
            
        } else if seconds <= 10 && seconds >= 5 {
            timerLabel.textColor = UIColor.orange
            seconds -= 1
            timerLabel.text = "\(seconds)"
        } else if seconds <= 4 {
            timerLabel.textColor = UIColor.red
            seconds -= 1
            timerLabel.text = "\(seconds)"
        } else {
            seconds -= 1
            timerLabel.text = "\(seconds)"
        }
    }
    
    /* -+-+-+----------------------------------------+-+-+-
     Display Question Method
     -+-+-+----------------------------------------+-+-+- */
    
    func displayQuestion() {
        // --++-->> create and start timer at beginning of question
        createTimer()
        runTimer()
        
        // --++-->> question chosen
        questionDictionary = questionProvider.randomQuestion(listToBeFiltered: listToBeFiltered)
        listToBeFiltered.append(questionDictionary)
        questionField.text = questionDictionary.question
        
        // --++-->> add answer button for each option available for that question e.g. 2, 3, 4
        for (index, option) in questionDictionary.options.enumerated() {
            let button = createOptionButton(extra: CGFloat(100 * (index + 1)), title: option)
            button.backgroundColor = colorArray[index]
            view.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            // --++-->> answer option button constraints
            let leftButtonEdgeConstraint = NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 20)
            let rightButtonEdgeConstraint = NSLayoutConstraint(item: button, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: -20)
            let topButtonEdgeConstraint = NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: CGFloat(100 + (80 * (index + 1))))
            let heightConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
            view.addConstraints([leftButtonEdgeConstraint, rightButtonEdgeConstraint, topButtonEdgeConstraint, heightConstraint])
            buttonsArray.append(button)
        }
    }
    
    /* -+-+-+----------------------------------------+-+-+-
     Display Score Method
     -+-+-+----------------------------------------+-+-+- */
    
    func displayScore() {
        questionField.text = "Way to go!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
        
        // --++-->> create and display play again button
        playAgainButton = createPlayAgainButton(extra: 1.0, title: "Play Again")
        view.addSubview(playAgainButton)
        
        // --++-->> play again button constraints
        playAgainButton.translatesAutoresizingMaskIntoConstraints = false
        let leftPlayAgainEdgeConstraint = NSLayoutConstraint(item: playAgainButton, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 20)
        let rightPlayAgainEdgeConstraint = NSLayoutConstraint(item: playAgainButton, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: -20)
        let topPlayAgainEdgeConstraint = NSLayoutConstraint(item: playAgainButton, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 180)
        let heightPlayAgainConstraint = NSLayoutConstraint(item: playAgainButton, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
        view.addConstraints([leftPlayAgainEdgeConstraint, rightPlayAgainEdgeConstraint, topPlayAgainEdgeConstraint, heightPlayAgainConstraint])
    }
    
    /* -+-+-+----------------------------------------+-+-+-
     Check Answer Method
     -+-+-+----------------------------------------+-+-+- */
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        timer.invalidate()
        // Increment the questions asked counter
        questionsAsked += 1
        
        let correctAnswer = questionDictionary.answer
        
        if (sender.currentTitle! == correctAnswer) {
            playCorrectAnswerSound()
            correctQuestions += 1
            
            // --++-->> create and add answer result label
            resultLabel = createResultLabel(text: "Correct!")
            resultLabel.textColor = colorArray[3]
            resultLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
            view.addSubview(resultLabel)
            resultLabel.translatesAutoresizingMaskIntoConstraints = false
            
            // --++-->> result label constraints
            let horConstraint = NSLayoutConstraint(item: resultLabel, attribute: .centerX, relatedBy: .equal,
                                                   toItem: view, attribute: .centerX,
                                                   multiplier: 1.0, constant: 0.0)
            let topButtonEdgeConstraint = NSLayoutConstraint(item: resultLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 120)
            view.addConstraints([topButtonEdgeConstraint, horConstraint])
        } else {
            playIncorrectAnswerSound()
            
            // --++-->> create and add answer result label
            resultLabel = createResultLabel(text: "Sorry, that's not it.")
            resultLabel.textColor = colorArray[0]
            resultLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
            view.addSubview(resultLabel)
            resultLabel.translatesAutoresizingMaskIntoConstraints = false
            
            // --++-->> result label constraints
            let horConstraint = NSLayoutConstraint(item: resultLabel, attribute: .centerX, relatedBy: .equal,
                                                   toItem: view, attribute: .centerX,
                                                   multiplier: 1.0, constant: 0.0)
            let topButtonEdgeConstraint = NSLayoutConstraint(item: resultLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 120)
            view.addConstraints([topButtonEdgeConstraint, horConstraint])
            for button in buttonsArray {
                if button.currentTitle! == correctAnswer {
                    button.backgroundColor = UIColor(red: 77/255, green: 77/255, blue: 77/255, alpha: 1)
                }
            }
        }

        // --++-->> remove timer from superview and reset it to 15 seconds
        self.timerLabel.removeFromSuperview()
        self.seconds = 15
        
        // --++-->> create and display next question button
        nextQuestionButton = createNextQuestionButton(extra: 0, title: "Next Question")
        
        view.addSubview(nextQuestionButton)
        
        nextQuestionButton.translatesAutoresizingMaskIntoConstraints = false
        
        // --++-->> next question button constraints
        let leftButtonEdgeConstraint = NSLayoutConstraint(item: nextQuestionButton, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 20)
        let rightButtonEdgeConstraint = NSLayoutConstraint(item: nextQuestionButton, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: -20)
        let bottomButtonEdgeConstraint = NSLayoutConstraint(item: nextQuestionButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: -20)
        let heightConstraint = NSLayoutConstraint(item: nextQuestionButton, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
        view.addConstraints([leftButtonEdgeConstraint, rightButtonEdgeConstraint, bottomButtonEdgeConstraint, heightConstraint])
    }
    
    /* -+-+-+----------------------------------------+-+-+-
     Next Round Method
     -+-+-+----------------------------------------+-+-+- */
    
    func nextRound() {
        if questionsAsked == questionsPerRound {
            // Game is over
            displayScore()
        } else {
            // Continue game
            displayQuestion()
        }
    }
    
    @IBAction func playAgain(_ sender: UIButton) {
        listToBeFiltered.removeAll()
        sender.removeFromSuperview()
        questionsAsked = 0
        correctQuestions = 0
        nextRound()
    }
    

    
    // MARK: Helper Methods
    
    func loadNextRoundWithDelay(_ sender: UIButton) {
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(0))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)
        
        // Executes the nextRound method at the dispatch time on the main queue
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            for button in self.buttonsArray {
                button.removeFromSuperview()
            }
            
            self.nextQuestionButton.removeFromSuperview()
            self.resultLabel.removeFromSuperview()
            self.nextRound()
        }
    }
    
    func loadGameStartSound() {
        let pathToSoundFile = Bundle.main.path(forResource: "GameSound", ofType: "wav")
        let soundURL = URL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &gameSound)
    }
    
    func loadCorrectAnswerSound() {
        let pathToSoundFile = Bundle.main.path(forResource: "CorrectAnswer", ofType: "wav")
        let soundURL = URL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &correctAnswer)
    }
    
    func loadIncorrectAnswerSound() {
        let pathToSoundFile = Bundle.main.path(forResource: "IncorrectAnswer", ofType: "wav")
        let soundURL = URL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &incorrectAnswer)
    }
    
    func playCorrectAnswerSound() {
        AudioServicesPlaySystemSound(correctAnswer)
    }
    
    func playIncorrectAnswerSound() {
        AudioServicesPlaySystemSound(incorrectAnswer)
    }
    
    func playGameStartSound() {
        AudioServicesPlaySystemSound(gameSound)
    }
}


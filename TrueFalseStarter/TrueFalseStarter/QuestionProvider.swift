//
//  QuestionProvider.swift
//  TrueFalseStarter
//
//  Created by Alexandra Barnett on 06/10/2017.
//  Copyright © 2017 Treehouse. All rights reserved.
//

import GameKit

struct QuestionProvider {
    let questions: [Question] = [
        Question(question: "Which decade was Jun Fan Gung Fu created?", answer: "1960s", options: ["1940s", "1950s", "1960s", "1970s"]),
        Question(question: "What is the name of the founder of the art?", answer: "Sijo", options: ["Sifu", "Sihing", "Simo", "Sijo"]),
        Question(question: "What is the name of your instructor of the art?", answer: "Sifu", options: ["Sifu", "Sihing", "Simo", "Sijo"]),
        Question(question: "What is a Vertical Fist in Jun Fan?", answer: "Chung Choy", options: ["Chung Choy", "Gua Choy", "Ping Choy", "Chop Choy"]),
        Question(question: "What is a Horizontal Fist in Jun Fan?", answer: "Ping Choy", options: ["Chung Choy", "Gua Choy", "Ping Choy", "Chop Choy"]),
        Question(question: "What is an Extended Fist in Jun Fan?", answer: "Chop Choy", options: ["Chung Choy", "Gua Choy", "Ping Choy", "Chop Choy"]),
        Question(question: "Pak Sao means ‘Slap Hand’", answer: "Yes", options: ["Yes", "No"]),
        Question(question: "Lau Sing Choy means ‘Cross Punch’", answer: "No", options: ["Yes", "No"]),
        Question(question: "Yut is 10", answer: "No", options: ["Yes", "No"]),
        Question(question: "Yut, Yee, Sahm is ‘One, Two, Three’?", answer: "Yes", options: ["Yes", "No"]),
        Question(question: "Jeet Kune Do means ‘Way of the intercepting leg’?", answer: "No", options: ["Yes", "No"]),
        Question(question: "Gerk means ‘leg’", answer: "Yes", options: ["Yes", "No"]),
        Question(question: "What is Ung Moon?", answer: "5 Gates", options: ["3 Gates", "4 Gates", "5 Gates"]),
        Question(question: "What translates as ‘low’?", answer: "Ha", options: ["Go", "Ha", "Jun"]),
        Question(question: "What is the form that means ‘Little Idea’?", answer: "Si Nim Tao", options: ["Si Gim Tao", "Si Nim Tao", "Si Lim Tao"]),
        Question(question: "What is ABC?", answer: "Attack by Combination", options: ["Attack by Coordination", "Attack by Combination", "Attack by Consequence"])
    ]
    
    func randomQuestion(listToBeFiltered: [Question]) -> Question {
        if listToBeFiltered.count > 0 {
            let questionNamesForFiltering = listToBeFiltered.map { $0.question }
            let filteredList = questions.filter { !questionNamesForFiltering.contains($0.question) }
            let indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextInt(upperBound: filteredList.count)
            return filteredList[indexOfSelectedQuestion]
        } else {
            let indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextInt(upperBound: questions.count)
            return questions[indexOfSelectedQuestion]
        }
        
    }
}

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
        Question(question: "Only female koalas can whistle", answer: "False", options: ["True", "False"]),
        Question(question: "Blue whales are technically whales", answer: "True", options: ["True", "False"]),
        Question(question: "Camels are cannibalistic", answer: "False", options: ["True", "False"]),
        Question(question: "All ducks are birds", answer: "True", options: ["True", "False"]),
        Question(question: "This was the only US President to serve more than two consecutive terms.", answer: "Franklin D. Roosevelt", options: ["George Washington", "Franklin D. Roosevelt", "Woodrow Wilson", "Andrew Jackson"]),
        Question(question: "Which of the following countries has the most residents?", answer: "Nigeria", options: ["Nigeria", "Russia", "Iran", "Vietnam"]),
        Question(question: "In what year was the United Nations founded?", answer: "1945", options: ["1918", "1919", "1945", "1954"]),
        Question(question: "The Titanic departed from the United Kingdom, where was it supposed to arrive?", answer: "New York City", options: ["Paris", "Washington D.C.", "New York City", "Boston"]),
        Question(question: "Which nation produces the most oil?", answer: "Canada", options: ["Iran", "Iraq", "Brazil", "Canada"]),
        Question(question: "Which country has most recently won consecutive World Cups in Soccer?", answer: "Brazil", options: ["Italy", "Brazil", "Argentina", "Spain"]),
        Question(question: "Which of the following rivers is longest?", answer: "Mississippi", options: ["Yangtze", "Mississippi", "Congo", "Mekong"]),
        Question(question: "Which city is the oldest?", answer: "Mexico City", options: ["Mexico City", "Cape Town", "San Juan", "Sydney"]),
        Question(question: "Which country was the first to allow women to vote in national elections?", answer: "Poland", options: ["Poland", "United States", "Sweden", "Senegal"]),
        Question(question: "Which of these countries won the most medals in the 2012 Summer Games?", answer: "Great Britain", options: ["France", "Germany", "Japan", "Great Britain"])
    ]
    
    func randomQuestion() -> Question {
        let indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextInt(upperBound: questions.count)
        return questions[indexOfSelectedQuestion]
    }
}

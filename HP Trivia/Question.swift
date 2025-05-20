//
//  Question.swift
//  HP Trivia
//
//  Created by Collin Schmitt on 4/12/25.
//

import Foundation


struct Question: Codable {
    let id: Int
    let question: String
    var answers: [String: Bool] = [:] //going to put all answers in (righht and wrong)
    let book: Int
    let hint: String
    
    //match these to the json data (not the variables above)
    enum QuestionKeys: String, CodingKey {
        case id
        case question
        case answer
        case wrong
        case book
        case hint
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: QuestionKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.question = try container.decode(String.self, forKey: .question)
        self.book = try container.decode(Int.self, forKey: .book)
        self.hint = try container.decode(String.self, forKey: .hint)
        
        let correctAnswer = try container.decode(String.self, forKey: .answer)
        answers[correctAnswer] = true
        
        let wrongAnswers = try container.decode( [String].self, forKey: .wrong)
        for answer in wrongAnswers{
            answers[answer] = false
            
            /*
             answers:
             {
             "The Boy Who Lived": true,
             "The Kid Who Survived": false,
             "The Baby Who Beat The Dark Lord": false,
             "The Scrawny Teenager": false
             }
             */
        }
        
        
    }
}

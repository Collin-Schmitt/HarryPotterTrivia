//
//  Game.swift
//  HP Trivia
//
//  Created by Collin Schmitt on 4/13/25.
//

import Foundation
import SwiftUI

@MainActor
class Game: ObservableObject {
    @Published var gameScore = 0
    @Published var questionScore = 5
    @Published var recentScores = [0,0,0]
    
    private var allQuestions: [Question] = []
    private var answeredQuestions: [Int] = []
    private let savePath = FileManager.documentsDirectory.appending(path: "SavedScores")
    
    var filteredQuestions: [Question] = []
    var currentQuestion = Constants.previewQuestion
    var answers: [String] = []
    
    var correctAnswer: String {
        currentQuestion.answers.first(where: {$0.value == true})!.key
    }
    
    init() {
        decodeQuestions()
    }
    
    func startGame() {
        gameScore = 0
        questionScore = 5
        answeredQuestions = []
        
    }
    
    func filterQuestions(to books:[Int]) {
        filteredQuestions = allQuestions.filter {books.contains($0.book) }
    }
    
    func newQuestion() {
        //checking if user doesn't select a single book
        if filteredQuestions.isEmpty {
            return
        }
        
        if answeredQuestions.count == filteredQuestions.count {
            answeredQuestions = []
            
        }
        
        var potentialQuestion = filteredQuestions.randomElement()!
        //checking if the question we got is already in our answeredQuestions:
        while answeredQuestions.contains(potentialQuestion.id) {
            //try to get a different question
            potentialQuestion = filteredQuestions.randomElement()!
        }
        currentQuestion = potentialQuestion
        
        answers = []
        
        for answer in currentQuestion.answers.keys {
            answers.append(answer)
        }
        
        answers.shuffle()
        
        questionScore = 5
        
    }
    
    //when user gets correct answer
    func correct() {
        answeredQuestions.append(currentQuestion.id)
        
        withAnimation{
            //update the score
            gameScore += questionScore
        }
        
    }
    
    func endGame() {
        recentScores[2] = recentScores[1]
        recentScores[1] = recentScores[0]
        recentScores[0] = gameScore
        
        saveScores()
    }
    
    func loadScores() {
        do{
            let data = try Data(contentsOf: savePath)
            recentScores = try JSONDecoder().decode([Int].self, from: data)
        } catch{
            //make scores 0 if you can't load any of the recent scores
            recentScores = [0, 0, 0]
        }
    }
    
    private func saveScores() {
        do {
            let data = try JSONEncoder().encode(recentScores)
            try data.write(to: savePath)
        } catch{
            print("Unable to save data \(error)")
        }
    }
    
    //decoding all of the questions
    private func decodeQuestions() {
        if let url = Bundle.main.url(forResource: "trivia", withExtension: "json") {
            do{
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                allQuestions = try decoder.decode([Question].self, from: data)
                filteredQuestions = allQuestions
            } catch{
                print("Error decoding JSON data \(error)")
            }
        }
    }
}

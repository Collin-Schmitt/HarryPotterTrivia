//
//  Instructions.swift
//  HP Trivia
//
//  Created by Collin Schmitt on 4/13/25.
//

import SwiftUI

struct Instructions: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack{
            
            //background image
            InfoBackgroundImage()
            
            VStack {
                Image("appiconwithradius")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                    .padding(.top)
                
                //instructions
                ScrollView {
                    Text("How to Play")
                        .font(.largeTitle)
                        .padding()
                    
                    //need a vstack to align text to leading
                    VStack(alignment: .leading) {
                        Text("Welcome to HP Trivia! In this game, you will be asked random questions from the HP books and you must guess the right answer or you will lose points!😱")
                            .padding([.horizontal, .bottom])
                        
                        Text("Each question is worth 5 points, but if you guess a wrong answer, you lose 1 point.")
                            .padding([.horizontal, .bottom])

                        Text("If you are struggling with a questions, there is an option to reveal a hint or reveal the book that answers the question. But beware! Using these also minuses 1 point each.")
                            .padding([.horizontal, .bottom])

                        Text("When you select the correct answer, you will be rewarded all of the points left for that question and they will be added to your total score.")
                            .padding(.horizontal)
                    }
                    .font(.title3)
                    
                    Text("Goodluck!")
                        .font(.title)
                }
                .foregroundColor(.black)
                
                Button(){
                    dismiss()
                } label: {
                    Text("Done")
                }
                .doneButton()
                
            }
        }
    }
}

#Preview {
    Instructions()
}

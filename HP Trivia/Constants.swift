//
//  Constants.swift
//  HP Trivia
//
//  Created by Collin Schmitt on 4/12/25.
//

import Foundation
import SwiftUI

enum Constants {
    static let hpFont = "PartyLetPlain"
    
    static let previewQuestion = try! JSONDecoder().decode([Question].self, from: Data(contentsOf: Bundle.main.url(forResource: "trivia", withExtension: "json")!))[0]
}
 
//creating a view to store background image (same image for settings and info screen)
struct InfoBackgroundImage: View {
    var body: some View {
        //background image
        Image("parchment")
            .resizable()
            .ignoresSafeArea()
            .background(.brown)
    }
}

//modifiers for the two done buttons we have
extension Button {
    func doneButton() -> some View {
        self
            .font(.largeTitle)
            .padding()
            .buttonStyle(.borderedProminent)
            .tint(.brown)
            .foregroundColor(.white)
    }
}

//from Hacking w/ Swift 
extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

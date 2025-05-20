//
//  ContentView.swift
//  HP Trivia
//
//  Created by Collin Schmitt on 4/12/25.
//

import SwiftUI
import AVKit //framework for audio

struct ContentView: View {
    @EnvironmentObject private var store: Store
    @EnvironmentObject private var game: Game
    
    @State private var audioPlayer: AVAudioPlayer!
    @State private var scalePlayButton = false
    @State private var moveBackgroundImage = false
    @State private var animateViewsIn = false
    @State private var showInstructions = false
    @State private var showSettings = false
    @State private var playGame = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack{
                
                //background image
                Image("hogwarts")
                    .resizable()
                    .frame(width: geo.size.width * 3, height: geo.size.height)
                    .padding(.top, 3)
                    .offset(x: moveBackgroundImage ? geo.size.width/1.1 : -geo.size.width/1.1)
                    .onAppear {
                        withAnimation(.linear(duration: 60).repeatForever(autoreverses: false)) {
                            moveBackgroundImage.toggle()
                        }
                    }
                
                //title, recent score, and buttons
                VStack{
                    VStack{
                        if animateViewsIn {
                            //title
                            VStack{
                                //lightning logo
                                Image(systemName: "bolt.fill")
                                    .font(.largeTitle)
                                    .imageScale(.large)
                                
                                //HP
                                Text("HP")
                                    .font(.custom(Constants.hpFont, size: 70))
                                    .padding(.bottom, -50)
                                //Trivia
                                Text("Trivia")
                                    .font(.custom(Constants.hpFont, size: 60))
                                
                            }//end titleVStack
                            .padding(.top, 70)
                            .transition(.move(edge: .top))
                        }
                    }
                    .animation(.easeOut(duration: 0.7).delay(2), value: animateViewsIn)
                    
                    Spacer()
                    VStack{
                        if animateViewsIn {
                            //Recent Scores
                            VStack{
                                
                                Text("Recent Scores")
                                    .font(.title2)
                                
                                //3 scores for 3 most recently played games
                                Text("\(game.recentScores[0])")
                                Text("\(game.recentScores[1])")
                                Text("\(game.recentScores[2])")
                            }
                            .font(.title3) //title 3 to recent scores (not the "Recent Scores"
                            .padding(.horizontal)
                            .foregroundColor(.white)
                            .background(.black.opacity(0.7))
                            .cornerRadius(15)
                            .transition(.opacity)
                        }
                    }
                    .animation(.linear(duration: 1).delay(4), value: animateViewsIn)
                    Spacer()
                    
                    
                    //buttons
                    HStack{
                        Spacer()
                        
                        VStack {
                            if animateViewsIn{
                                //Show instructions screen
                                Button {
                                    showInstructions.toggle()
                                } label: {
                                    Image(systemName: "info.circle.fill")
                                        .font(.largeTitle)
                                        .foregroundColor(.white)
                                        .shadow(radius: 5)
                                }
                                .transition(.offset(x: -geo.size.width/4))
                                .sheet(isPresented: $showInstructions){
                                    Instructions()
                                }
                            }
                        }
                        .animation(.easeOut(duration: 0.7).delay(2.7), value: animateViewsIn)
                        
                        Spacer()
                        
                        VStack {
                            if animateViewsIn{
                                //Starting a new game Button
                                Button{
                                    filterQuestions()
                                    game.startGame()
                                    playGame.toggle()
                                } label: {
                                    Text("Play")
                                        .font(.largeTitle)
                                        .foregroundColor(.white)
                                        .padding(.vertical, 7)
                                        .padding(.horizontal, 50)
                                        .background(store.books.contains(.active) ? .brown : .gray)
                                        .cornerRadius(7)
                                        .shadow(radius: 5)
                                }
                                .scaleEffect(scalePlayButton ? 1.2 : 1)
                                .onAppear {
                                    //as soon as this button appears
                                    withAnimation(.easeIn(duration: 1.3).repeatForever()) {
                                        scalePlayButton.toggle()
                                    }
                                }
                                .transition(.offset(y: geo.size.height/3))
                                .fullScreenCover(isPresented: $playGame){
                                    Gameplay()
                                        .environmentObject(game)
                                        //fading background audio for title screen as the game starts
                                        .onAppear{
                                            audioPlayer.setVolume(0, fadeDuration: 2)
                                        }
                                        .onDisappear {
                                            //when the gameplay screen disappears and the title screen reappears
                                            audioPlayer.setVolume(1, fadeDuration: 2)
                                        }
                                }
                                .disabled(store.books.contains(.active) ? false : true)
                            }
                        }
                        .animation(.easeOut(duration: 0.7).delay(2), value: animateViewsIn)
                        
                        Spacer()
                        
                        VStack{
                            if animateViewsIn{
                                //Show Settings Button
                                Button{
                                    showSettings.toggle()
                                } label: {
                                    Image(systemName: "gearshape.fill")
                                        .font(.largeTitle)
                                        .foregroundColor(.white)
                                        .shadow(radius: 5)
                                }
                                .transition(.offset(x: geo.size.width/4))
                                .sheet(isPresented: $showSettings){
                                    Settings()
                                        .environmentObject(store)
                                }
                            }
                        }
                        .animation(.easeOut(duration: 0.7).delay(2.7), value: animateViewsIn)
                        Spacer()
                    }
                    .frame(width: geo.size.width)
                    
                    VStack{
                        if animateViewsIn {
                            if store.books.contains(.active) == false{
                                Text("No Questions available. Go to settings. ⬆️")
                                    .multilineTextAlignment(.center)
                                    .transition(.opacity)
                            }
                        }
                    }
                    .animation(.easeInOut.delay(3), value: animateViewsIn)
                    
                    Spacer()
                    
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea(.all)
        .onAppear {
            
            animateViewsIn = true

            playAudio()
            
        }
    }
    
    
    private func playAudio() {
        //get the sound (from the left) and play the audio
        let sound = Bundle.main.path(forResource: "magic-in-the-air", ofType: "mp3")
        
        //now we can use the audioPlayer property we created at the top
        audioPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        
        //Don't want the audio to ever stop
        audioPlayer.numberOfLoops = -1
        
        audioPlayer.play()
    }
    
    private func filterQuestions() {
        var books: [Int] = []
        
        //loop over book statuses and filter by whichever books are active
        for (index, status) in store.books.enumerated() {
            if status == .active{
                books.append(index + 1) //since books are 1-7
            }
        }
        game.filterQuestions(to: books)
        game.newQuestion()
    }
}

#Preview {
    ContentView()
        .environmentObject(Store())
        .environmentObject(Game())
}

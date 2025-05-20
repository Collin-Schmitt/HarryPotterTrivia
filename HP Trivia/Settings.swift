//
//  Settings.swift
//  HP Trivia
//
//  Created by Collin Schmitt on 4/12/25.
//

import SwiftUI



struct Settings: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: Store

    var body: some View {
        ZStack{
            InfoBackgroundImage()
            
            VStack{
                
                Text("Which books would you like to see questions from?")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding(.top)
                
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(), GridItem()]) {
                        
                        ForEach(0..<7){ i in
                            
                            //MARK:  Active book
                            if store.books[i] == .active || (store.books[i] == .locked && store.purchasedIDs.contains("hp\(i+1)")){
                                //need a ZStack for check mark over selected books
                                ZStack(alignment: .bottomTrailing){
                                    //image of the book goes in here
                                    Image("hp\(i+1)")
                                        .resizable()
                                        .scaledToFit()
                                        .shadow(radius: 7)
                                    
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.largeTitle)
                                        .imageScale(.large)
                                        .foregroundColor(.green)
                                        .shadow(radius: 1)
                                        .padding()
                                }
                                .onTapGesture {
                                    store.books[i] = .inactive
                                    store.saveStatus()
                                }
                                .task{
                                    store.books[i] = .active
                                    store.saveStatus()
                                }
                            }
                            
                            //MARK:  Inactive books
                            else if store.books[i] == .inactive {
                                
                                //adding unselected book state
                                ZStack(alignment: .bottomTrailing){
                                    Image("hp\(i+1)")
                                        .resizable()
                                        .scaledToFit()
                                        .shadow(radius: 7)
                                        .overlay(Rectangle().opacity(0.33))
                                    
                                    
                                    Image(systemName: "circle")
                                        .font(.largeTitle)
                                        .imageScale(.large)
                                        .foregroundColor(.green.opacity(0.5))
                                        .shadow(radius: 1)
                                        .padding()
                                }
                                .onTapGesture {
                                    store.books[i] = .active
                                    store.saveStatus()

                                }
                            }
                            else{
                                //MARK:  Locked books
                                ZStack(){
                                    Image("hp\(i+1)")
                                        .resizable()
                                        .scaledToFit()
                                        .shadow(radius: 7)
                                        .overlay(Rectangle().opacity(0.75))
                                    
                                    
                                    Image(systemName: "lock.fill")
                                        .font(.largeTitle)
                                        .imageScale(.large)
                                        .shadow(color: .white.opacity(0.75), radius: 3)
                                }
                                .onTapGesture {
                                    //load up the product
                                    let product = store.products[i-3] //hp4 is at index 0 in the array in Store
                                    
                                    Task{
                                        await store.purchase(product)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
                
                Button(){
                    dismiss()
                } label: {
                    Text("Done")
                }
                .doneButton()
            }
            .foregroundColor(.black)
        }
    }
}

#Preview {
    Settings()
        .environmentObject(Store())
}

//
//  Store.swift
//  HP Trivia
//
//  Created by Collin Schmitt on 4/13/25.
//

import Foundation
import StoreKit

enum BookStatus: Codable {
    case active
    case inactive
    case locked
}

@MainActor
class Store: ObservableObject {
    @Published var books: [BookStatus] = [.active, .active, .inactive, .locked, .locked, .locked, .locked]
    @Published var products: [Product] = []
    @Published var purchasedIDs = Set<String>() //a set is like a collection but everything has to be unique
    
    private var productIDs = ["hp4", "hp5", "hp6", "hp7"]
    private var updates: Task<Void, Never>? = nil
    private let savePath = FileManager.documentsDirectory.appending(path: "SavedBookStatus")

    
    init() {
        updates = watchForUpdates()
    }
    
    func loadProducts() async {
        do{
            products = try await Product.products(for: productIDs)
        } catch{
            print("couldn't fetch those products: \(error)")
        }
    }
    
    //function to purchase a product
    func purchase(_ product: Product) async {
        do {
            let result = try await product.purchase()
            
            switch result {
            //Purchase was successful, but now we have to verify receipt to make sure it was an Valid purchase
            case .success(let verificationResult):
                switch verificationResult {
                case .unverified(let signedType, let verificationError):
                    print("Error on \(signedType): \(verificationError)")
                    
                case .verified(let signedType):
                    //add to purchase id's once the payment is successful AND verified
                    purchasedIDs.insert(signedType.productID)
                }
                
            //User cancelled or parent disapproved child's purchase request
            case .userCancelled:
                break
                
            //Waiting for approval
            case .pending:
                break
                
                // auto filled by swift (satisfy a warning)
            @unknown default:
                break
            }
        } catch {
            print("Couldn't purchase the product: \(error)")
        }
    }
    
    func saveStatus() {
        do{
            let data = try JSONEncoder().encode(books)
            try data.write(to: savePath)
        } catch{
            print("Unable to save Status \(error)")
        }
    }
    
    func loadStatus() {
        do{
            let data = try Data(contentsOf: savePath)
            books = try JSONDecoder().decode([BookStatus].self, from: data)
        } catch{
            print("Unable to load Status \(error)")
        }
    }
    
    func checkPurchased() async {
        for product in products {
            guard let state = await product.currentEntitlement else { return }
            
            switch state {
            case .unverified(let signedType, let verificationError):
                print("Error on \(signedType): \(verificationError)")
                
            case .verified(let signedType):
                if signedType.revocationDate == nil {
                    purchasedIDs.insert(signedType.productID)
                }else{
                    purchasedIDs.remove(signedType.productID)
                }
            }
        }
    }
    
    private func watchForUpdates() -> Task<Void, Never> {
        Task(priority: .background){
            for await _ in Transaction.updates {
                await checkPurchased()
            }
        }
    }
}

# 🧙‍♂️ Harry Potter Trivia

**Harry Potter Trivia** is a SwiftUI app that challenges users with magical trivia questions from all 7 Harry Potter books. It uses Swift Concurrency, matched geometry animations, in-app purchases (StoreKit 2), and persistent data storage with `FileManager` — delivering a polished and immersive gameplay experience.

---

## ✨ Features

- 🧠 **Book-Specific Trivia**: Play questions based on selected books from the Harry Potter series
- 🧩 **Hints and Book Reveal Options**: Reveal hints or the book source at the cost of points
- 🛍 **In-App Purchases**: Unlock later books (Books 4–7) using StoreKit 2
- 🎵 **Dynamic Sound Design**: Page flips, magic sound effects, and background music using `AVAudioPlayer`
- 💾 **Score Saving**: Saves most recent game scores and book unlock statuses with `FileManager` & `Codable`
- 🧪 **Question Logic**:
  - +5 points per question
  - -1 for each wrong answer, hint, or book reveal
- 🔄 **Random, Non-Repeating Questions**
- 🧼 **Animations & UI Polish**:
  - MatchedGeometryEffect on answer transitions
  - Flip animations on hint buttons
  - Fading points animation from question to score
  - Custom fonts, dark mode, and vibrant styling

---

## 🛠 Technologies Used

- **Swift 6 / SwiftUI**
- **StoreKit 2** for in-app purchases
- **AVFoundation** for music and sound effects
- **FileManager** + **Codable** for saving app state
- **Swift Concurrency** (`async/await`)
- **MatchedGeometryEffect** for seamless UI animations
- **Custom JSON Decoding** for question files
- **MVVM-inspired Architecture**

---

## 🧭 How to Run

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Collin-Schmitt/HarryPotterTrivia.git
2. Open the .xcodeproj in Xcode 15 or newer
3. Build & run the app on an iOS 17+ device or simulator
4. For in-app purchase testing:
      - Enable StoreKit testing with a sandbox account on a real device
      - Unlock additional books (Books 4–7)

---

## 📁Project Structure
- ContentView.swift – Launch screen with animations, background music, and recent scores
- Gameplay.swift – Main trivia interface with questions, hints, scoring, and celebration logic
- Store.swift – Handles StoreKit 2 product loading, in-app purchases, and book status saving to disk
- Game.swift – Manages question filtering, scoring, recent scores, and game state persistence
- Constants.swift – App-wide constants, shared modifiers, and file system utilities
- Question.swift – Codable model that decodes the bundled trivia JSON into structured data
- Settings.swift – Lets users select active books and unlock more via in-app purchases
- Instructions.swift – Scrollable view explaining how to play the game
- trivia.json – Local question database with correct/wrong answers, book numbers, and hints
- Audio Files (.mp3) – Background music and sound effects triggered during gameplay

---

## 🧩 JSON Format (Trivia Questions)
Questions are stored locally in a trivia.json file, using this format:
{
  "id": 1,
  "question": "What is Harry Potter known as?",
  "answer": "The Boy Who Lived",
  "wrong": ["The Scrawny Teen", "The Survivor", "The Kid Who Made It"],
  "book": 1,
  "hint": "The title of the first chapter."
}

---

## 🛠️ Key Concepts and Lessons

- @MainActor observable classes for UI-bound state
- AVAudioPlayer for layered audio (music + SFX)
- matchedGeometryEffect for elegant transitions
- StoreKit 2 purchases with verified receipts
- Saving & loading user data using FileManager
- Applying async/await and background tasks
- Using/Resetting animations between question transitions
- File-based state persistence instead of CoreData

---

## 🙌 Acknowledgments
- Built as part of a SwiftUI learning project
- Inspired by the Harry Potter book series by J.K. Rowling
- Background music sourced from royalty-free libraries
  

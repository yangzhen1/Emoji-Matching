import UIKit

import Foundation


class EmojiMatchingGame: CustomStringConvertible {
    
    let allCardBacks = Array("ππππππππβΊβ²π’πππ½")
    let allEmojiCharacters = Array("ππ΄ππ’π±ππππ«π π¬π©πΆπ°πΌβπΈβπΈπ³ββ€ππΊπΌπ½πππ‘π‘π»πππ¦π π§ππππ¨ππ»πΉπ²ππ")
    
    var cards : [Character]
    var cardBack : Character
    var numPairs : Int
    
    enum gameStates: String {
        case waiting1 = "Waiting for first selection"
        case waiting2 = "Waiting for second selection"
        case TurnFailed = "TurnFailed!"
        case TurnSucceed = "TurnSucceed!"
        case GameOver = "GameOver!"
    }
    var gameState: gameStates
    
    enum cardState: String {
        case Shown = "Shown"
        case Hidden = "Hidden"
        case Removed = "Removed"
    }
    // var cardstate: cardState
    var cardStates : [cardState]
    
    
    
    
    
    init(numPairs : Int){
        self.numPairs = numPairs
        gameState = gameStates.waiting1
        
        cardStates = [cardState](repeating: .Hidden, count: numPairs * 2)
        
        
        var emojiSymbolsUsed = [Character]()
        while emojiSymbolsUsed.count < numPairs {
            let index = Int(arc4random_uniform(UInt32(allEmojiCharacters.count)))
            let symbol = allEmojiCharacters[index]
            if !emojiSymbolsUsed.contains(symbol) {
                emojiSymbolsUsed.append(symbol)
            }
        }
        cards = emojiSymbolsUsed + emojiSymbolsUsed
        cards.shuffle()
        
        let index = Int(arc4random_uniform(UInt32(allCardBacks.count)))
        cardBack = allCardBacks[index]
        
        print("\n")
        print(String(cards[0..<4]))
        print(String(cards[4..<8]))
        print(String(cards[8..<12]))
        print(String(cards[12..<16]))
        print(String(cards[16..<20]))
        print("\n")
        
        

        
    }
    
    func pressedCard(_ atIndex : Int){
        
        checkStates()
        switch cardStates[atIndex] {
        case .Hidden:
             // εͺθ¦ζ―hiddenε°±εΎεShown
            if self.gameState == .waiting1 { // ε¦ζδΈδΈͺι½ζ²‘ηΉ
                self.cardStates[atIndex] = .Shown // ηΉδΊ?δΈδΈͺ
                gameState = .waiting2               // ζ’state
                
            }else if gameState == .waiting2 { // ε¦ζδΉεζδΈδΈͺηΉδΊ?η
                self.cardStates[atIndex] = .Shown // ηΉδΊ?δΈδΈͺ
                checkStates()                     // ζ£ζ₯state
            
            }
        
        case .Shown: delay(1.2) {
            return
            }
        case .Removed: delay(1.2) {
            return
            }
        }
  
    }
    
    func startNewTurn(_ atIndex: Int){
        checkStates()
        if gameState == .TurnFailed {
            
                self.cardStates[atIndex] = .Hidden

                self.cardStates[self.checkWait1Index(atIndex)] = .Hidden // δΈ€δΈͺι½ιθ
            gameState = .waiting1

        }else if gameState == .TurnSucceed {

            self.cardStates[atIndex] = .Removed
                                self.cardStates[self.checkPairIndex(atIndex)] = .Removed // δΈ€δΈͺι½ε»ι€
            gameState = .waiting1
                                    self.checkStates()
                                    if self.gameState == .GameOver {
                                    Swift.print("gameOver")// ζ―ζ¬‘TurnSucceed ι½δΌζ£ζ₯ζ―δΈζ―θ΅’δΊγ
//                                        var game = EmojiMatchingGame(numPairs: 10)
            }
        }

    }
    
    func checkPairIndex(_ index : Int) -> Int{
        for k in 0..<cards.count {
            if cards[k] == cards[index] && k != index {
                return k
            }
        }
        return -1
    }
    
    func checkWait1Index(_ wait2Index: Int) -> Int { // η¨δΊ ιζ©δΈ€δΈͺιθ――δΉεζΎη¬¬δΈδΈͺηδ½η½?
        for k in 0..<cards.count {
            if cardStates[k] == .Shown && k != wait2Index {
                return k
            }
        }
        return -1
    }
    
    func checkStates(){ // ζ£ζ₯ε?ζΆstate
        var counter = 0
        var index1 = -1
        var index2 = -1
        
        if cardStates.allSatisfy ({ $0 == .Removed}){
            gameState = .GameOver
        }
        
        for k in 0..<cards.count {
            if cardStates[k] == .Shown {// ζ£ζ₯indexδΈΊkηε°ζΉζ―δΈζ―ShownοΌε¦ζ ζ―οΌ
                if counter == 0 {
                    index1 = k
                    counter = 1
                }else if counter == 1 {
                    index2 = k
                    counter = 2
                }
            }
        }
        if counter == 0 { // ζ²‘ζShown
            gameState = .waiting1
        }else if counter == 1 { // ζδΈδΈͺShown
            gameState = .waiting2
        }else{ // counter == 2 ζδΈ€δΈͺShown
            if cards[index1] == cards[index2] { //δΈ€δΈͺShownηindexδΈζ ·
                gameState = .TurnSucceed
            }else{                // δΈ€δΈͺShownηindexδΈδΈζ ·
                gameState = .TurnFailed
            }
        }
    }
    

    var description: String {
        return "Cards: \(String(cards))"
    }
    
    
    
    func printt(){
        print(String(cards[0..<4]))
        print(String(cards[4..<8]))
        print(String(cards[8..<12]))
        print(String(cards[12..<16]))
        print(String(cards[16..<20]))
    }
    
}

extension Array {
    mutating func shuffle() {
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            self.swapAt(i, j)
        }
    }
}

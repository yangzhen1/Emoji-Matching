import UIKit

import Foundation


class EmojiMatchingGame: CustomStringConvertible {
    
    let allCardBacks = Array("🎆🎇🌈🌅🌇🌉🌃🌄⛺⛲🚢🌌🌋🗽")
    let allEmojiCharacters = Array("🚁🐴🐇🐢🐱🐌🐒🐞🐫🐠🐬🐩🐶🐰🐼⛄🌸⛅🐸🐳❄❤🐝🌺🌼🌽🍌🍎🍡🏡🌻🍉🍒🍦👠🐧👛🐛🐘🐨😃🐻🐹🐲🐊🐙")
    
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
             // 只要是hidden就得先Shown
            if self.gameState == .waiting1 { // 如果一个都没点
                self.cardStates[atIndex] = .Shown // 点亮一个
                gameState = .waiting2               // 换state
                
            }else if gameState == .waiting2 { // 如果之前有一个点亮的
                self.cardStates[atIndex] = .Shown // 点亮一个
                checkStates()                     // 检查state
            
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

                self.cardStates[self.checkWait1Index(atIndex)] = .Hidden // 两个都隐藏
            gameState = .waiting1

        }else if gameState == .TurnSucceed {

            self.cardStates[atIndex] = .Removed
                                self.cardStates[self.checkPairIndex(atIndex)] = .Removed // 两个都去除
            gameState = .waiting1
                                    self.checkStates()
                                    if self.gameState == .GameOver {
                                    Swift.print("gameOver")// 每次TurnSucceed 都会检查是不是赢了。
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
    
    func checkWait1Index(_ wait2Index: Int) -> Int { // 用于 选择两个错误之后找第一个的位置
        for k in 0..<cards.count {
            if cardStates[k] == .Shown && k != wait2Index {
                return k
            }
        }
        return -1
    }
    
    func checkStates(){ // 检查实时state
        var counter = 0
        var index1 = -1
        var index2 = -1
        
        if cardStates.allSatisfy ({ $0 == .Removed}){
            gameState = .GameOver
        }
        
        for k in 0..<cards.count {
            if cardStates[k] == .Shown {// 检查index为k的地方是不是Shown，如果 是：
                if counter == 0 {
                    index1 = k
                    counter = 1
                }else if counter == 1 {
                    index2 = k
                    counter = 2
                }
            }
        }
        if counter == 0 { // 没有Shown
            gameState = .waiting1
        }else if counter == 1 { // 有一个Shown
            gameState = .waiting2
        }else{ // counter == 2 有两个Shown
            if cards[index1] == cards[index2] { //两个Shown的index一样
                gameState = .TurnSucceed
            }else{                // 两个Shown的index不一样
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

//
//  ViewController.swift
//  Emoji Matching
//
//  Created by Sisyphus on 6/23/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var gameBoardButtons: [UIButton]!
   
    var game = EmojiMatchingGame(numPairs: 10)
  
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        game.printt()

    }


    @IBAction func pressedNewGame(_ sender: Any) {
        game = EmojiMatchingGame(numPairs: 10)
        updateView()
        
    }
    
    
    func startNewTurnVC(_ index : Int){
        game.startNewTurn(index)
        
        updateView()
        
    }
    
    @IBAction func pressedGameBoardButton(_ sender: Any) {
        let button = sender as! UIButton
        
        
        switch game.gameState {

        case .waiting1:
            game.pressedCard(button.tag)
            delay(1.2){}
            self.updateView()
        case .waiting2:
            game.pressedCard(button.tag)
            self.updateView()
            delay(1.2){
                self.startNewTurnVC(button.tag)
            }
           
        case .TurnFailed:

            delay(1.2){

            }

        case .TurnSucceed:
            
            delay(1.2){

            }
        case .GameOver:
            delay(1.2){
                self.game = EmojiMatchingGame(numPairs: 10)
            }

        }
        
        updateView()
    }
    
    func updateView(){
        
        
        
        for button in gameBoardButtons {
            let buttonIndex = button.tag
            
            switch game.cardStates[buttonIndex] {
            
            case .Hidden:
                //button.setTitle(String(game.cards[buttonIndex]), for: .normal)
                button.setTitle(String(game.cardBack), for: .normal)
               

            case .Shown:
               button.setTitle(String(game.cards[buttonIndex]), for: .normal)
                
            case .Removed:
              button.setTitle("", for: .normal)
                
            }
        }
        
        
        
    }
    
    
    
}


func delay(_ delay:Double, closure:@escaping ()->()) {
  let when = DispatchTime.now() + delay
  DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

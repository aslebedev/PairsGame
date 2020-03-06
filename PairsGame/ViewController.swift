//
//  ViewController.swift
//  PairsGame
//
//  Created by alexander on 03.03.2020.
//  Copyright © 2020 alexander. All rights reserved.
//


import UIKit

class ViewController: UIViewController {
    
    var startGameButton: UIButton!
    var youWinLabel: UILabel!
    
    var cardButtons = [CardUIButton]()
    var cardNames = [String]()
    var cardsTappedCount = 0
    var guessedCardCount = 0
    var firstTappedCard: CardUIButton? = nil
    var secondTappedCard: CardUIButton? = nil
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        let cardsView = UIView()
        cardsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cardsView)
        
        startGameButton = UIButton(type: .system)
        startGameButton.translatesAutoresizingMaskIntoConstraints = false
        startGameButton.setTitle("START GAME", for: .normal)
        startGameButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        startGameButton.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        view.addSubview(startGameButton)
        
        youWinLabel = UILabel()
        youWinLabel.translatesAutoresizingMaskIntoConstraints = false
        youWinLabel.font = UIFont.systemFont(ofSize: 60)
        youWinLabel.text = "YOU WIN!"
        youWinLabel.alpha = 0
        view.addSubview(youWinLabel)
        
        let indent: CGFloat = 50
        let width = UIScreen.main.bounds.width - indent * 2
        let height = UIScreen.main.bounds.height - indent * 2
        
        NSLayoutConstraint.activate([
            cardsView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: indent),
            cardsView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: indent),
            cardsView.widthAnchor.constraint(equalToConstant: width),
            cardsView.heightAnchor.constraint(equalToConstant: height),
            
            youWinLabel.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            youWinLabel.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor),

            startGameButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -10),
            startGameButton.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
        ])

        for row in 0..<4 {
            for column in 0..<4 {
                let cardButton = CardUIButton(type: .custom)
                
                let frame = CGRect(x: CGFloat(column) * width/4, y: CGFloat(row) * height/4, width: width/5, height: height/5)
                cardButton.frame = frame
                cardButton.imageName = "BACK"
                
                cardButton.isUserInteractionEnabled = false
                cardButton.addTarget(self, action: #selector(cardTapped), for: .touchUpInside)
                
                cardButtons.append(cardButton)
                cardsView.addSubview(cardButton)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path).sorted()
        
        for item in items {
            if item.hasPrefix("BACK") { continue }
            
            if item.hasSuffix(".png") {
                if let index = item.firstIndex(of: ".") {
                    self.cardNames.append(String(item[..<index]))
                }
            }
        }
    }
    
    @objc func startGame() {
        
        let eightCards = cardNames.shuffled().prefix(8)
        let sixteenCards = (eightCards + eightCards).shuffled()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            for i in 0...15 {
                self.cardButtons[i].imageName = sixteenCards[i]
                UIView.transition(with: self.cardButtons[i], duration: 1, options: .transitionFlipFromRight, animations: nil, completion: nil)
            }
            
            UIView.animate(withDuration: 1) {
                self.startGameButton.alpha = 0
                self.youWinLabel.alpha = 0
            }
        }

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5.2) {
            self.cardButtons.forEach( {
                $0.setImage(UIImage(named: "BACK"), for: .normal)
                UIView.transition(with: $0, duration: 1, options: .transitionFlipFromRight, animations: nil,
                                  completion: { _ in
                                    self.cardButtons.forEach( { $0.isUserInteractionEnabled = true } )
                                  }
                )
            })
        }
    }

    @objc func cardTapped(_ sender: CardUIButton) {
        
        if cardsTappedCount>=2 { return }
        
        cardsTappedCount += 1
        
        sender.isUserInteractionEnabled = false
        sender.setImage(UIImage(named: sender.imageName), for: .normal)
        UIView.transition(with: sender, duration: 1, options: .transitionFlipFromRight, animations: nil, completion: nil)
        
        if cardsTappedCount < 2 {
            firstTappedCard = sender
        } else {
            secondTappedCard = sender
        }
        
        if cardsTappedCount >= 2 {
            cardButtons.forEach( { $0.isUserInteractionEnabled = false } )
            
            if let firstTappedCard = firstTappedCard, let secondTappedCard = secondTappedCard {
                checkCards(first: firstTappedCard, second: secondTappedCard)
            } else {
                print("firstTappedCard or secondTappedCard is nil")
            }
        }
    }
    
    func checkCards(first firstCard: CardUIButton, second secondCard: CardUIButton) {
        
        if firstCard.imageName == secondCard.imageName {
            
            guessedCardCount += 2
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.8) {
                UIView.animate(withDuration: 1) {
                    firstCard.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                    secondCard.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                UIView.animate(withDuration: 1) {
                    firstCard.alpha = 0
                    secondCard.alpha = 0
                }
            }
            
        } else {
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.6) {
                firstCard.setImage(UIImage(named: "BACK"), for: .normal)
                secondCard.setImage(UIImage(named: "BACK"), for: .normal)
                UIView.transition(with: firstCard, duration: 1, options: .transitionFlipFromRight, animations: nil, completion: nil)
                UIView.transition(with: secondCard, duration: 1, options: .transitionFlipFromRight, animations: nil, completion: nil)
            }
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.cardButtons.forEach( { $0.isUserInteractionEnabled = true } )
            self.cardsTappedCount = 0
        }
        
        if guessedCardCount >= 16 {
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                UIView.animate(withDuration: 1) {
                    self.youWinLabel.alpha = 1.0
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
                UIView.animate(withDuration: 1) {
                    self.startGameButton.alpha = 1.0
                }
            }
        }
    }
}


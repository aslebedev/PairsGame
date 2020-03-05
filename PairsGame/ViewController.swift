//
//  ViewController.swift
//  PairsGame
//
//  Created by alexander on 03.03.2020.
//  Copyright © 2020 alexander. All rights reserved.
//


// Проблема с экстеншеном, при изменении проперти, меняется проперти у всех экземпляров

import UIKit

class ViewController: UIViewController {
    
    var startGameButton = UIButton()
    
    //var cards = [Card]()
    var cardButtons = [UIButton]()
    var cardNames = [String]()
    var cardsTappedCount = 0
    
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
        
        let topIndent: CGFloat = 80
        let sideIndent: CGFloat = 50
        let width = (UIScreen.main.bounds.width - sideIndent * 2)
        let height = (UIScreen.main.bounds.height - topIndent * 1.8)
        
        NSLayoutConstraint.activate([
            cardsView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: topIndent),
            cardsView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: sideIndent),
            cardsView.widthAnchor.constraint(equalToConstant: width),
            cardsView.heightAnchor.constraint(equalToConstant: height),
            
            startGameButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -10),
            startGameButton.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
        ])

        for row in 0..<4 {
            for column in 0..<4 {
                let cardButton = UIButton(type: .custom)
                
                let frame = CGRect(x: CGFloat(column) * width/4, y: CGFloat(row) * height/4, width: width/5, height: height/5)
                cardButton.frame = frame
                
                cardButton.imageName = "BACK"   // using extension
                cardButton.addTarget(self, action: #selector(cardTapped), for: .touchUpInside)
                
//                cards.append(Card(button: cardButton, imageName: "BACK", row: row, column: column))
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
        
        startGameButton.isHidden = true
        
        let eightCards = cardNames.shuffled().prefix(8)
        let sixteenCards = (eightCards + eightCards).shuffled()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            UIView.animate(withDuration: 1) {
                for i in 0...15 {
                    self.cardButtons[i].imageName = sixteenCards[i]
                    UIView.transition(with: self.cardButtons[i], duration: 2, options: .transitionFlipFromRight, animations: nil, completion: nil)
                }
            }
        }

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.cardButtons.forEach( { print("after: \($0.imageName)") } )
        }

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.2) {
            UIView.animate(withDuration: 1) {
                self.cardButtons.forEach( {
                    $0.setImage(UIImage(named: "BACK"), for: .normal)
                    UIView.transition(with: $0, duration: 2, options: .transitionFlipFromRight, animations: nil, completion: nil)
                })
            }
        }
    }

    @objc func cardTapped(_ sender: UIButton) {
        
        if cardsTappedCount>=2 { return }
        
        cardsTappedCount += 1
            
        UIView.animate(withDuration: 1, delay: 0, options: [],
            animations: {
                sender.setImage(UIImage(named: sender.imageName), for: .normal)
                UIView.transition(with: sender, duration: 2, options: .transitionFlipFromRight, animations: nil, completion: nil)
        })
        
//        if cardsTappedCount >= 2 {
//            cards.forEach( { $0.adjustsImageWhenHighlighted = false } )
//
//        }
    }
    
    func checkPairs() {
        
//        cards.forEach( { $0.adjustsImageWhenHighlighted = true } )
//        cardsTappedCount = 0
    }
}


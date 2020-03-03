//
//  ViewController.swift
//  PairsGame
//
//  Created by alexander on 03.03.2020.
//  Copyright © 2020 alexander. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var cards = [UIImageView]()

    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        let cardsView = UIView()
        cardsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cardsView)
        
        let topIndent: CGFloat = 80
        let sideIndent: CGFloat = 50
        let width = (UIScreen.main.bounds.width - sideIndent)
        let height = (UIScreen.main.bounds.height - topIndent * 1.5)
        
        NSLayoutConstraint.activate([
            cardsView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: topIndent),
            cardsView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: sideIndent / 2),
            cardsView.widthAnchor.constraint(equalToConstant: width),
            cardsView.heightAnchor.constraint(equalToConstant: height),
        ])

        for row in 0..<4 {
            for column in 0..<4 {
                let cardButton = UIButton(type: .custom)
                
                let frame = CGRect(x: CGFloat(column) * width/4, y: CGFloat(row) * height/4, width: width/5, height: height/5)
                cardButton.frame = frame
                
//                cardButton.adjustsImageWhenHighlighted = false
                cardButton.setImage(UIImage(named: "BACK"), for: [.normal])
                cardsView.addSubview(cardButton)
                
                cardButton.addTarget(self, action: #selector(cardTapped), for: .touchUpInside)
            }
        }
 

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @objc func cardTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 1, delay: 0, options: [],
            animations: {
                sender.setImage(UIImage(named: "2H"), for: .normal)
                UIView.transition(with: sender, duration: 2, options: .transitionFlipFromRight, animations: nil, completion: nil)
        })
    }
}


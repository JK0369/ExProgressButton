//
//  ViewController.swift
//  ExProgressButton
//
//  Created by 김종권 on 2022/12/25.
//

import UIKit

class ViewController: UIViewController {
    private var progressButton: ProgressButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressButton = ProgressButton(radius: 50, completion: { [weak self] in
            self?.progressButton.isHidden = true
        })
        progressButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progressButton)
        NSLayoutConstraint.activate([
            self.progressButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            self.progressButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.progressButton.widthAnchor.constraint(equalToConstant: 100),
            self.progressButton.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.progressButton.animate(startRatio: 0.0)
    }
}

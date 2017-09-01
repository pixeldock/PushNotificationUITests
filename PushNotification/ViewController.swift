//
//  ViewController.swift
//  PushNotification
//
//  Created by Jörn Schoppe on 09.07.17.
//  Copyright © 2017 pixeldock. All rights reserved.
//

import UIKit
import PusherKit

enum ViewControllerType: String {
    case red, blue, green
}

class ViewController: UIViewController {
    
    let titleLabel = UILabel()
    var tokenLabel: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.frame = view.frame
        titleLabel.font = UIFont.systemFont(ofSize: 40, weight: UIFont.Weight.thin)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard presentingViewController != nil else { return }
        
        let closeButton = UIButton(type: .custom)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.thin)
        closeButton.setTitle("Close", for: .normal)
        closeButton.addTarget(self, action: #selector(didPressCloseButton), for: .touchUpInside)
        closeButton.frame = CGRect(x: view.bounds.maxX - 100, y: 30, width: 100, height: 40)
        view.addSubview(closeButton)
    }
    
    @objc func didPressCloseButton(_ button: UIButton) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func presentViewController(withType type: ViewControllerType) {
        let viewController = ViewController()
        
        switch type {
        case .green:
            viewController.view.backgroundColor = UIColor(red:0.31, green:0.73, blue:0.28, alpha:1.00)
            viewController.titleLabel.text = "Green"
        case .red:
            viewController.view.backgroundColor = UIColor(red:0.79, green:0.09, blue:0.01, alpha:1.00)
            viewController.titleLabel.text = "Red"
        case .blue:
            viewController.view.backgroundColor = UIColor(red:0.00, green:0.62, blue:0.91, alpha:1.00)
            viewController.titleLabel.text = "Blue"
        }
        
        present(viewController, animated: true, completion: nil)
    }
}

//
//  WelcomeViewController.swift
//  New York Times App
//
//  Created by Mahmut Yazar on 9.01.2023.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func startClicked(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "FlowVC") as! FlowViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
}

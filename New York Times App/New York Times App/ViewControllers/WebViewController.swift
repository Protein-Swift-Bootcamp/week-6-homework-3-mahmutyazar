//
//  WebViewController.swift
//  New York Times App
//
//  Created by Mahmut Yazar on 12.01.2023.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    var url: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didGetNotification(_:)), name: Notification.Name("Text"), object: nil)
        
        print(url)
        
       
        
    }
    
    
    @objc func didGetNotification(_ notification: Notification) {
        let text = notification.object as! String?
                self.url = text
        
        if let url = URL(string: self.url ?? "") {
            let request: URLRequest = .init(url: url)
            webView.load(request)
        }
        
    }
}

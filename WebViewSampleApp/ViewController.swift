//
//  ViewController.swift
//  WebViewSampleApp
//
//  Created by Ahmad Mahmoud on 03/06/2024.
//

import UIKit
import WebKit
import UTIQ

class ViewController: UIViewController {
    
    let myWebView = MyWebView()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initUtiq()
        myWebView.addCoordinator(coordinator: Coordinator(showConsentAction: {
            if(UTIQ.shared.isInitialized()){
                self.showConsent()
            }
        }))
        
        view.addSubview(myWebView.webView)
        NSLayoutConstraint.activate([
            myWebView.webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myWebView.webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            myWebView.webView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            myWebView.webView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor)
        ])
        
        myWebView.loadWebview()
    }
    
    func initUtiq(){
        let utiqConfigs = Bundle.main.url(forResource: "utiq_configs", withExtension: "json")!
        let fileContents = try? String(contentsOf: utiqConfigs)
        let options = UTIQOptions()
        options.enableLogging()
        options.setFallBackConfigJson(json: fileContents!)
        self.myWebView.showIds(atid: "UTIQ initializing...", mtid: "")
        UTIQ.shared.initialize(sdkToken: "R&Ai^v>TfqCz4Y^HH2?3uk8j", options:  options, success: {
            self.myWebView.showIds(atid: "UTIQ initialized", mtid: "")
        }, failure: { e in
            self.myWebView.showIds(atid: "Error: \(e)", mtid: "")
            print("Error: \(e)")
        })
    }
    
    func showConsent(){
        let alert = UIAlertController(title: "Utiq Consent", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Accept", style: UIAlertAction.Style.default, handler: { action in
            try? UTIQ.shared.acceptConsent()
            let stubToken = "523393b9b7aa92a534db512af83084506d89e965b95c36f982200e76afcb82cb"
            self.myWebView.showIds(atid: "UTIQ requesting IDs...", mtid: "")
            UTIQ.shared.startService(stubToken: stubToken, dataCallback: { data in
                self.myWebView.showIds(atid: data.atid ?? "", mtid: data.mtid ?? "")
            }, errorCallback: { e in
                self.myWebView.showIds(atid: "Error: \(e)", mtid: "")
                print("Error: \(e)")
            })
            
        }))
        alert.addAction(UIAlertAction(title: "Reject", style: UIAlertAction.Style.default, handler: { action in
            try? UTIQ.shared.rejectConsent()
            self.myWebView.showIds(atid: "consent rejected", mtid: "")
        }))
        self.present(alert, animated: true, completion: nil)
    }
}


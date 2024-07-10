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
    
    public lazy var webView: WKWebView = {
        let userContentController = WKUserContentController()
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        self.webView = WKWebView(frame: .zero, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.isInspectable = true
        return webView
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Showw Att
        self.initUtiqSdk {
            self.showConsentPopUp(acceptAction: { [weak self] in
                try? UTIQ.shared.acceptConsent()
                self?.startUiq()
            }, rejectAction: { [weak self] in
                try? UTIQ.shared.rejectConsent()
                // TODO:- Show error in webview
            })
        }
        view.addSubview(self.webView)
        NSLayoutConstraint.activate([
            self.webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.webView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            self.webView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor)
        ])
        if let url = URL(string: "https://utiq-test.brand-demo.com/utiq/mobile/native-page.html") {
            let resource = URLRequest(url: url)
            webView.load(resource)
        }
    }
    
    private func initUtiqSdk(action: @escaping (() -> Void)){
        let utiqConfigs = Bundle.main.url(forResource: "utiq_configs", withExtension: "json")!
        let fileContents = try? String(contentsOf: utiqConfigs)
        let options = UTIQOptions().enableLogging().setFallBackConfigJson(json: fileContents!)
        UTIQ.shared.initialize(sdkToken: "R&Ai^v>TfqCz4Y^HH2?3uk8j", options:  options, success: {
            action()
        }, failure: { [weak self] error in
            // TODO:- Show error in WebView
            print("Error: \(error)")
        })
    }
    
    private func postUtiqIdsInWebView(adTechPass: String, marTechPass: String) {
        self.webView.evaluateJavaScript("refreshIds('\(adTechPass)', '\(marTechPass)');") { (result, error) in
            if let result = result {
                print("Success: \(result)")
            } else if let error = error {
                print("Error: \(error)")
            }
        }
    }
    
    private func showConsentPopUp(acceptAction: @escaping (() -> Void), rejectAction: @escaping (() -> Void)) {
        // TODO:- We need to add a message in the opo to reflect the purpose of this pop, we can copy the same content from the e-commerce App.
        let alert = UIAlertController(title: "Utiq Consent", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Accept", style: UIAlertAction.Style.default, handler: { action in
            acceptAction()
        }))
        alert.addAction(UIAlertAction(title: "Reject", style: UIAlertAction.Style.default, handler: { action in
           rejectAction()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func startUiq() {
        let stubToken = "523393b9b7aa92a534db512af83084506d89e965b95c36f982200e76afcb82cb"
        UTIQ.shared.startService(stubToken: stubToken, dataCallback: { [weak self] data in
            self?.postUtiqIdsInWebView(adTechPass: data.atid ?? "", marTechPass: data.mtid ?? "")
        }, errorCallback: { [weak self] error in
            print("Error: \(error)")
            // TODO:- Show error in WebView
        })
    }
}


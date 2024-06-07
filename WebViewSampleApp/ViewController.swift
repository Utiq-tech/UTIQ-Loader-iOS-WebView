//
//  ViewController.swift
//  WebViewSampleApp
//
//  Created by Ahmad Mahmoud on 03/06/2024.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    private lazy var webView: WKWebView = {
        
        let userContentController = WKUserContentController()
        userContentController.add(Coordinator(), name: "bridge")
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            webView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor)
        ])
        webView.isInspectable = true
        let contentController = self.webView.configuration.userContentController
        contentController.add(self, name: "consentHandler")
        //if let url = URL(string: "https://utiq-test.brand-demo.com/utiq/mobile/mobile-page.html") {
        if let url = URL(string: "http://127.0.0.1:8080/stage/utiq/mobile/mobile-page.html") {
            let resource = URLRequest(url: url)
            webView.load(resource)
        }
    }
}

extension ViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let dict = message.body as? [String : AnyObject] else {
            return
        }
        print("Js Message", dict)
        //
        guard let isConsentGranted = dict["isConsentGranted"] else {
            return
        }
        let script = "document.getElementById('mobile-anchor').innerText = \"\(isConsentGranted)\""
        webView.evaluateJavaScript(script) { (result, error) in
            if let result = result {
                print("Label is updated with message: \(result)")
            } else if let error = error {
                print("An error occurred: \(error)")
            }
        }
    }
}


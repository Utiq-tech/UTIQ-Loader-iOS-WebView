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
        let webView = WKWebView()
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
        let token = "54fc04fcfdee14ad8268d59b3303baf8854bc4d27308a2668dd47ed2a8a54cae"
        if let url = URL(string: "https://utiq-test.utest1.work/utiq/mobile/mobile-page.html?utiq_stub=\(token)") {
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


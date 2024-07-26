//
//  Controller.swift
//  WebViewSampleApp
//
//  Created by bdado on 19/6/24.
//

import Foundation
import WebKit

class MyWebView : NSObject, WKNavigationDelegate, WKScriptMessageHandler {
    
    var showConsentAction: (() -> Void)? = nil
    
    lazy var webView: WKWebView = {
        let userContentController = WKUserContentController()
        userContentController.add(self, name: "bridge")
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.isInspectable = true
        return webView
    }()
    
    func setConsentAction(_ showConsentAction: @escaping (() -> Void)) {
        self.showConsentAction = showConsentAction
    }
    
    func loadWebview() {
        if let url = URL(string: "https://utiq-test.utest1.work/utiq/mobile/native-page.html") {
            let resource = URLRequest(url: url)
            webView.load(resource)
        }
    }
    
    func showIds(atid: String, mtid: String) {
        // Using 'self.webView.evaluateJavaScript' we are executing the javascript code on the webside and send data in real time
        self.webView.evaluateJavaScript("refreshIds('\(atid)', '\(mtid)');") { (result, error) in
            if let result = result {
                print("Success: \(result)")
            } else if let error = error {
                print("Error: \(error)")
            }
        }
    }
    
    func showTextMessage(text: String) {
        // Using 'self.webView.evaluateJavaScript' we are executing the javascript code on the webside and send data in real time
        self.webView.evaluateJavaScript("showTextMessage('\(text)');") { (result, error) in
            if let result = result {
                print("Success: \(result)")
            } else if let error = error {
                print("Error: \(error)")
            }
        }
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        handleMessage(msg: message.body as! String)
    }
    
    func handleMessage(msg: String) {
        switch(msg){
            case "show_consent" : do {
                if let action = showConsentAction{
                    action()
                }
            }
            default: break
        }
    }
}

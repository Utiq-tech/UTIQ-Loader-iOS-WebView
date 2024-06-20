//
//  Controller.swift
//  WebViewSampleApp
//
//  Created by bdado on 19/6/24.
//

import Foundation
import WebKit

class MyWebView{
    
    public lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.isInspectable = true
        return webView
    }()
    
    func loadWebview(){
        if let url = URL(string: "https://utiq-test.brand-demo.com/utiq/mobile/native-page.html") {
        //if let url = URL(string: "http://127.0.0.1:8080/stage/utiq/mobile/native-page.html") {
            let resource = URLRequest(url: url)
            webView.load(resource)
        }
    }
    
    func addCoordinator(coordinator: Coordinator){
        let userContentController = WKUserContentController()
        userContentController.add(coordinator, name: "bridge")
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.isInspectable = true
    }
    
    func showIds(atid: String, mtid: String){
        //Using 'self.webView.evaluateJavaScript' we are executing the javascript code on the webside and send data in real time
        self.webView.evaluateJavaScript("refreshIds('\(atid)', '\(mtid)');") { (result, error) in
            if let result = result {
                print("Success: \(result)")
            } else if let error = error {
                print("Error: \(error)")
            }
        }
    }
}

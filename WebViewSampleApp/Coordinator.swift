//
//  CustomWebView.swift
//  WebViewSampleApp
//
//  Created by bdado on 6/6/24.
//

import Foundation
import SwiftUI
import WebKit
import UTIQ

class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler{
    var webView: WKWebView?
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        self.webView = webView
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("iran -> : \(message.body)")
        switch(message.body as! String){
        case "show_consent" : do {
                //show consent popup
            
            }
            default: break
        }
    }
}





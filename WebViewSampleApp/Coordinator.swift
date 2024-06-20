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
    
    var showConsentAction: (() -> Void)
    
    init(showConsentAction: @escaping (() -> Void)) {
        self.showConsentAction = showConsentAction
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        handleMessage(msg: message.body as! String)
    }
    
    func handleMessage(msg: String){
        switch(msg){
            case "show_consent" : do {
                showConsentAction()
            }
            default: break
        }
    }
}





//
//  ViewController.swift
//  WebViewSampleApp
//
//  Created by Ahmad Mahmoud on 03/06/2024.
//

import UIKit
import WebKit
import UTIQ
import AppTrackingTransparency
import AdSupport

class ViewController: UIViewController {
    
    let myWebView = MyWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let utiqConsent = UtiqConsentVC(acceptAction: {
            try? UTIQ.shared.acceptConsent()
            let stubToken = "523393b9b7aa92a534db512af83084506d89e965b95c36f982200e76afcb82cb"
            self.myWebView.showTextMessage(text: "UTIQ requesting IDs...")
            UTIQ.shared.startService(stubToken: stubToken, dataCallback: { data in
                self.myWebView.showIds(atid: data.atid ?? "", mtid: data.mtid ?? "")
                self.myWebView.showTextMessage(text: "UTIQ IDs successfully fetched")
            }, errorCallback: { e in
                self.myWebView.showTextMessage(text: "Error: \(e)")
                print("Error: \(e)")
            })
            self.dismiss(animated: true)
        }, rejectAction: {
            try? UTIQ.shared.rejectConsent()
            self.myWebView.showTextMessage(text: "Consent rejected")
            self.myWebView.showIds(atid: "", mtid: "")
            self.dismiss(animated: true)
        })
        myWebView.setConsentAction(
            showConsentAction: { [weak self] in
                if(UTIQ.shared.isInitialized()){
                    self?.present(utiqConsent, animated: true, completion: nil)
                }
            }
        )
        
        // Request ATT permission
        checkTrackingAuthorization()
        
        self.initUtiq()
        
        view.addSubview(myWebView.webView)
        NSLayoutConstraint.activate([
            myWebView.webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myWebView.webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            myWebView.webView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            myWebView.webView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor)
        ])
        
        myWebView.loadWebview()
        print("iran1 -> ")
    }
    
    func checkTrackingAuthorization() {
            if #available(iOS 14, *) {
                let trackingStatus = ATTrackingManager.trackingAuthorizationStatus
                handleTrackingAuthorization(status: trackingStatus)
            } else {
                // ATT is not available, handle accordingly
                print("ATT is only available on iOS 14 and later")
            }
        }

    func handleTrackingAuthorization(status: ATTrackingManager.AuthorizationStatus) {
        switch status {
        case .notDetermined:
            // Request tracking authorization
            requestTrackingAuthorization()
        case .restricted, .denied:
            // Tracking is restricted or denied
            print("Tracking permission: \(status == .restricted ? "Restricted" : "Denied")")
        case .authorized:
            // Tracking is authorized
            print("Tracking permission: Authorized")
            // Optionally, retrieve IDFA
            let idfa = ASIdentifierManager.shared().advertisingIdentifier
            print("IDFA: \(idfa)")
        @unknown default:
            print("Tracking permission: Unknown status")
        }
    }

    func requestTrackingAuthorization() {
        ATTrackingManager.requestTrackingAuthorization { status in
            DispatchQueue.main.async {
                self.handleTrackingAuthorization(status: status)
            }
        }
    }
    
    func initUtiq(){
        let utiqConfigs = Bundle.main.url(forResource: "utiq_configs", withExtension: "json")!
        let fileContents = try? String(contentsOf: utiqConfigs)
        let options = UTIQOptions()
        options.enableLogging()
        options.setFallBackConfigJson(json: fileContents!)
        self.myWebView.showTextMessage(text: "UTIQ initializing...")
        UTIQ.shared.initialize(sdkToken: "R&Ai^v>TfqCz4Y^HH2?3uk8j", options:  options, success: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.myWebView.showTextMessage(text: "UTIQ initialized")
            }
        }, failure: { e in
            self.myWebView.showTextMessage(text: "Error: \(e)")
            print("Error: \(e)")
        })
    }
}



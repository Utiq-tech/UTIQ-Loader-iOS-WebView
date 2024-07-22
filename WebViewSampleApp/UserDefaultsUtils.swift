//
//  UserDefaultsUtils.swift
//  WebViewSampleApp
//
//  Created by bdado on 22/7/24.
//

import Foundation

class UserDefaultsUtils {
    
    private static let userDefaults = UserDefaults.standard
    private static let CONSENT = "CONSENT"
    
    static func getConsent() -> String {
        return self.userDefaults.string(forKey: CONSENT) ?? ""
    }
    
    static func setConsent(value: String) {
        self.userDefaults.set(value, forKey: CONSENT)
    }
}

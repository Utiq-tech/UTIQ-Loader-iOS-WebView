//
//  UtiqConsent.swift
//  WebViewSampleApp
//
//  Created by bdado on 12/7/24.
//

import Foundation
import UIKit

class UtiqConsentVC: UIViewController {
    
    private var acceptAction: (()->Void)? = nil
    private var rejectAction: (()->Void)? = nil
    
    override func loadView() {
        self.view = loadXib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loadXib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "UtiqConsent", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        return view!
    }
    
    func setActions(acceptAction: @escaping ()->Void, rejectAction: @escaping ()->Void){
        self.acceptAction = acceptAction
        self.rejectAction = rejectAction
    }
    
    @IBAction func acceptButton(_ sender: Any) {
        if let action = acceptAction{
            action()
        }
    }
    
    @IBAction func rejectButton(_ sender: Any) {
        if let action = rejectAction{
            action()
        }
    }
}

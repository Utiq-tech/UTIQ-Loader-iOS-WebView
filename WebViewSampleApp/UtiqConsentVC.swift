//
//  UtiqConsent.swift
//  WebViewSampleApp
//
//  Created by bdado on 12/7/24.
//

import Foundation
import UIKit

class UtiqConsentVC: UIViewController {
    
    private var acceptAction: (() -> Void)?
    private var rejectAction: (() -> Void)?
    
    override func loadView() {
        self.view = loadXib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init(acceptAction: @escaping () -> Void, rejectAction: @escaping (() -> Void)) {
        self.acceptAction = acceptAction
        self.rejectAction = rejectAction
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func loadXib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "UtiqConsent", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        return view!
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

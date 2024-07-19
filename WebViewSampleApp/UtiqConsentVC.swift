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
    
    private func loadXib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "UtiqConsent", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        return view!
    }
    
    @IBAction private func acceptButton(_ sender: Any) {
        acceptAction?()
    }
    
    @IBAction private func rejectButton(_ sender: Any) {
        rejectAction?()
    }
}

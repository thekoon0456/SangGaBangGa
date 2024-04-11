//
//  AlertBuilder.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/10/24.
//

import UIKit

final class AlertBuilder {
    private let baseViewController: UIViewController
    private let alertController = AlertController()
    
    private var message: String?
    private var showCancel: Bool = false
    private var addActionConfirm: AddAction?
    
    init(baseViewController: UIViewController) {
        self.baseViewController = baseViewController
    }
    
    func setMessage(_ text: String) -> Self {
        message = text
        return self
    }
    
    func addActionCancel(_ showCancel: Bool) -> Self {
        self.showCancel = showCancel
        return self
    }
    
    func addActionConfirm(_ text: String, action: (() -> Void)? = nil) -> Self {
        self.addActionConfirm = AddAction(text: text, action: action)
        return self
    }
    
    func show() {
        alertController.modalPresentationStyle = .overFullScreen
        alertController.modalTransitionStyle = .crossDissolve
        
        alertController.message = message
//        alertController.
    }
    
}

struct AddAction {
    var text: String?
    var action: (() -> Void)?
}

final class AlertController: UIAlertController {
    
}

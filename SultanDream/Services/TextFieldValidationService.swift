//
//  TextFieldValidationService.swift
//  SultanDream
//
//  Created by Sultan Karybaev on 16.04.2022.
//

import Foundation
import UIKit

protocol TextFieldValidationServiceDelegate {
    func isValidEmail(textField: UITextField) -> Bool
}

class TextFieldValidationService: TextFieldValidationServiceDelegate {
    
    public func isValidEmail(textField: UITextField) -> Bool {
        let email = textField.text ?? ""
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
}

//
//  PasswordVC.swift
//  SultanDream
//
//  Created by Sultan Karybaev on 09.04.2022.
//

import UIKit

class PasswordVC: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var currentPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var repeatNewPasswordTextFiled: UITextField!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var bottomView: KeyboardBindView!
    @IBOutlet weak var bottomViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLayer()
        self.setGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.bottomView.bindToKeyboard()
        self.bottomView.setBottomLayoutConstraint(constraint: self.bottomViewBottomConstraint)
        if #available(iOS 11.0, *) {
            let bottomPadding = self.view.safeAreaInsets.bottom
            self.bottomView.setScreenBottomPadding(padding: bottomPadding)
        }
    }
    
    private func setLayer() {
        self.errorLabel.isHidden = true
        self.currentPasswordTextField.isSecureTextEntry = true
        self.currentPasswordTextField.autocapitalizationType = .none
        if #available(iOS 11.0, *) {
            self.currentPasswordTextField.textContentType = .password
        }
        self.newPasswordTextField.isSecureTextEntry = true
        self.newPasswordTextField.autocapitalizationType = .none
        if #available(iOS 11.0, *) {
            self.newPasswordTextField.textContentType = .password
        }
        self.repeatNewPasswordTextFiled.isSecureTextEntry = true
        self.repeatNewPasswordTextFiled.autocapitalizationType = .none
        if #available(iOS 11.0, *) {
            self.repeatNewPasswordTextFiled.textContentType = .password
        }
    }
    
    private func setGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func changePasswordButtonWasPressed(_ sender: Any) {
        self.changePassword()
    }
    
    private func changePassword() {
        if let currentPassword = self.currentPasswordTextField.text, let newPassword = self.newPasswordTextField.text, let repeatNewPassword = self.repeatNewPasswordTextFiled.text, currentPassword != "", newPassword != "", repeatNewPassword != "" {
            if newPassword == repeatNewPassword {
                self.errorLabel.isHidden = true
                AccountService.instance.changePassword(oldPassword: currentPassword, newPassword: newPassword) { success, message in
                    if success {
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        self.errorLabel.isHidden = false
                        self.errorLabel.text = message
                    }
                }
            } else {
                self.errorLabel.isHidden = false
                self.errorLabel.text = "Passwords don't match"
            }
        } else {
            self.errorLabel.isHidden = false
            self.errorLabel.text = "Please, fill all fields"
        }
    }
    
}

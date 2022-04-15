//
//  LoginVC.swift
//  SultanDream
//
//  Created by Sultan Karybaev on 22.03.2022.
//

import UIKit
import SwiftUI

class LoginVC: UIViewController {
    
    @IBOutlet weak var dreamWallLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordLabel: UILabel!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var bottomView: KeyboardBindView!
    @IBOutlet weak var bottomViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginButton: UIButton!
    
    private var layerState: LayerState = .Login
    private var savedEmail: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTextField.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.emailTextField.layer.borderWidth = 1
        self.emailTextField.layer.cornerRadius = 6
        self.passwordTextField.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.passwordTextField.layer.borderWidth = 1
        self.passwordTextField.layer.cornerRadius = 6
        self.repeatPasswordTextField.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.repeatPasswordTextField.layer.borderWidth = 1
        self.repeatPasswordTextField.layer.cornerRadius = 3
        self.passwordTextField.isSecureTextEntry = true
        self.passwordTextField.autocapitalizationType = .none
        if #available(iOS 11.0, *) {
            self.passwordTextField.textContentType = .password
        }
        self.repeatPasswordTextField.isSecureTextEntry = true
        self.repeatPasswordTextField.autocapitalizationType = .none
        if #available(iOS 11.0, *) {
            self.repeatPasswordTextField.textContentType = .password
        }
        self.dreamWallLabel.textColor = MAIN_COLOR
        self.signupButton.setTitleColor(MAIN_COLOR, for: .normal)
        self.forgotPasswordButton.setTitleColor(MAIN_COLOR, for: .normal)
        self.loginButton.backgroundColor = MAIN_COLOR
        self.loginButton.setTitleColor(UIColor.black, for: .normal)
        self.setLayer(layerState: .Login)
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
    
    private func setGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    private func setLayer(layerState: LayerState) {
        self.emailTextField.text = ""
        self.passwordTextField.text = ""
        self.repeatPasswordTextField.text = ""
        self.errorLabel.isHidden = true
        switch layerState {
            case .Login:
                self.backButton.isHidden = true
                self.emailLabel.text = "Email"
                self.emailTextField.placeholder = "Email"
                self.passwordLabel.isHidden = false
                self.passwordTextField.isHidden = false
                self.repeatPasswordLabel.isHidden = true
                self.repeatPasswordTextField.isHidden = true
                self.accountLabel.text = "Don't have an account?"
                self.signupButton.setTitle("Sign Up", for: .normal)
                self.forgotPasswordButton.isHidden = false
                self.loginButton.setTitle("Log In", for: .normal)
                break
            case .SendCode:
                self.backButton.isHidden = true
                self.emailLabel.text = "Email"
                self.emailTextField.placeholder = "Email"
                self.passwordLabel.isHidden = true
                self.passwordTextField.isHidden = true
                self.repeatPasswordLabel.isHidden = true
                self.repeatPasswordTextField.isHidden = true
                self.accountLabel.text = "Already have an account?"
                self.signupButton.setTitle("Log In", for: .normal)
                self.forgotPasswordButton.isHidden = false
                self.loginButton.setTitle("Send Code", for: .normal)
                break
            case .Signup:
                self.backButton.isHidden = false
                self.emailLabel.text = "Code"
                self.emailTextField.placeholder = "Code"
                self.passwordLabel.isHidden = false
                self.passwordTextField.isHidden = false
                self.repeatPasswordLabel.isHidden = false
                self.repeatPasswordTextField.isHidden = false
                self.accountLabel.text = "Already have an account?"
                self.signupButton.setTitle("Log In", for: .normal)
                self.forgotPasswordButton.isHidden = false
                self.loginButton.setTitle("Sign Up", for: .normal)
                break
            case .ForgotPasswordEmail:
                self.backButton.isHidden = true
                self.emailLabel.text = "Email"
                self.emailTextField.placeholder = "Email"
                self.passwordLabel.isHidden = true
                self.passwordTextField.isHidden = true
                self.repeatPasswordLabel.isHidden = true
                self.repeatPasswordTextField.isHidden = true
                self.accountLabel.text = "Already have an account?"
                self.signupButton.setTitle("Log In", for: .normal)
                self.forgotPasswordButton.isHidden = true
                self.loginButton.setTitle("Reset password", for: .normal)
                break
            case .ForgotPasswordCode:
                self.backButton.isHidden = false
                self.emailLabel.text = "Code"
                self.emailTextField.placeholder = "Code"
                self.passwordLabel.isHidden = false
                self.passwordTextField.isHidden = false
                self.repeatPasswordLabel.isHidden = false
                self.repeatPasswordTextField.isHidden = false
                self.accountLabel.text = "Already have an account?"
                self.signupButton.setTitle("Log In", for: .normal)
                self.forgotPasswordButton.isHidden = true
                self.loginButton.setTitle("Reset password", for: .normal)
                break
        }
        self.layerState = layerState
    }
    
    private func isValidEmail() -> Bool {
        let email = self.emailTextField.text ?? ""
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }

    @IBAction func backButtonWasPressed(_ sender: Any) {
        if self.layerState == .Signup {
            self.setLayer(layerState: .SendCode)
        } else if self.layerState == .ForgotPasswordCode {
            self.setLayer(layerState: .ForgotPasswordEmail)
        }
    }
    
    @IBAction func signupButtonWasPressed(_ sender: Any) {
        if self.layerState == .Login {
            self.setLayer(layerState: .SendCode)
        } else {
            self.setLayer(layerState: .Login)
        }
    }
    
    @IBAction func forgotPasswordButtonWasPressed(_ sender: Any) {
        self.setLayer(layerState: .ForgotPasswordEmail)
    }
    
    @IBAction func loginButtonWasPressed(_ sender: Any) {
        self.loginOrSignup()
    }
    
    private func loginOrSignup() {
        switch self.layerState {
            case .Login:
                if self.isValidEmail() {
                    if let email = self.emailTextField.text, let password = self.passwordTextField.text, (email != "" && password != "") {
                        self.errorLabel.isHidden = true
                        AccountService.instance.login(email: email, password: password) { success, message in
                            if success {
                                guard let mainNC = self.storyboard?.instantiateViewController(withIdentifier: "MainNC") else { return }
                                mainNC.modalPresentationStyle = .fullScreen
                                self.present(mainNC, animated: true, completion: nil)
                            } else {
                                self.errorLabel.isHidden = false
                                self.errorLabel.text = message
                            }
                        }
                    } else {
                        self.errorLabel.isHidden = false
                        self.errorLabel.text = "Type in password"
                    }
                } else {
                    self.errorLabel.isHidden = false
                    self.errorLabel.text = "Email is not valid"
                }
                break
            case .SendCode:
                if let email = self.emailTextField.text, self.isValidEmail() {
                    self.savedEmail = email
                    AccountService.instance.sendEmail(email: email) { success, message in
                        if success {
                            self.setLayer(layerState: .Signup)
                        } else {
                            self.errorLabel.isHidden = false
                            self.errorLabel.text = message
                        }
                    }
                } else {
                    self.errorLabel.isHidden = false
                    self.errorLabel.text = "Email is not valid"
                }
                break
            case .Signup:
                if let code = self.emailTextField.text, let password = self.passwordTextField.text, let repeatPassword = self.repeatPasswordTextField.text, (code != "" && password != "" && repeatPassword != "") {
                    if password == repeatPassword {
                        self.errorLabel.isHidden = true
                        AccountService.instance.signup(email: self.savedEmail, code: code, password: password) { success, message in
                            if success {
                                guard let mainNC = self.storyboard?.instantiateViewController(withIdentifier: "MainNC") else { return }
                                mainNC.modalPresentationStyle = .fullScreen
                                self.present(mainNC, animated: true, completion: nil)
                            } else {
                                self.errorLabel.isHidden = false
                                self.errorLabel.text = message
                            }
                        }
                    } else {
                        self.errorLabel.isHidden = false
                        self.errorLabel.text = "Passwords do not match"
                    }
                } else {
                    self.errorLabel.isHidden = false
                    self.errorLabel.text = "Type in password and code"
                }
                break
            case .ForgotPasswordEmail:
                if let email = self.emailTextField.text, self.isValidEmail() {
                    self.savedEmail = email
                    AccountService.instance.resetPasswordEmail(email: email) { success, message in
                        if success {
                            self.setLayer(layerState: .ForgotPasswordCode)
                        } else {
                            self.errorLabel.isHidden = false
                            self.errorLabel.text = message
                        }
                    }
                } else {
                    self.errorLabel.isHidden = false
                    self.errorLabel.text = "Email is not valid"
                }
                break
            case .ForgotPasswordCode:
                if let code = self.emailTextField.text, let password = self.passwordTextField.text, let repeatPassword = self.repeatPasswordTextField.text, (code != "" && password != "" && repeatPassword != "") {
                    if password == repeatPassword {
                        self.errorLabel.isHidden = true
                        AccountService.instance.resetPassword(email: self.savedEmail, code: code, password: password) { success, message in
                            if success {
                                guard let mainNC = self.storyboard?.instantiateViewController(withIdentifier: "MainNC") else { return }
                                mainNC.modalPresentationStyle = .fullScreen
                                self.present(mainNC, animated: true, completion: nil)
                            } else {
                                self.errorLabel.isHidden = false
                                self.errorLabel.text = message
                            }
                        }
                    } else {
                        self.errorLabel.isHidden = false
                        self.errorLabel.text = "Passwords do not match"
                    }
                } else {
                    self.errorLabel.isHidden = false
                    self.errorLabel.text = "Type in password and code"
                }
                break
        }
    }
    
}

enum LayerState {
    case Login
    case SendCode
    case Signup
    case ForgotPasswordEmail
    case ForgotPasswordCode
}

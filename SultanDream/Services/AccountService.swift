//
//  AccountService.swift
//  SultanDream
//
//  Created by Sultan Karybaev on 25.03.2022.
//

import UIKit
import Alamofire
import SwiftyJSON

class AccountService {
    static let instance = AccountService()
    private init() {}
    private let ROUTER_PATH = "account"
    
    public func login(email: String, password: String, handler: @escaping (Bool, String) -> ()) {
        let parameters: [String: Any] = [
            "email": email,
            "password": password
        ]
        AF.request("\(API_ADDRESS)/\(ROUTER_PATH)/login", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    guard let status = json["status"].int else { handler(false, "Something wrong on the server. Try again later"); return }
                    guard let message = json["message"].string else { handler(false, "Something wrong on the server. Try again later"); return }
                    guard let data = json["data"].dictionaryObject else { handler(false, "Something wrong on the server. Try again later"); return }
                    DispatchQueue.main.async {
                        if status == 200 {
                            if let token_str = data["token"] as? String {
                                let token = Token(token: token_str, email: email)
                                RealmService.instance.deleteRealmToken()
                                RealmService.instance.setToken(token: token)
                                handler(true, "")
                            } else {
                                handler(false, "Something wrong on the server. Try again later")
                            }
                        } else {
                            handler(false, message)
                        }
                    }
                case .failure(let error):
                    print("AccountService login error \(error.localizedDescription)")
                    handler(false, "Something wrong on the server. Try again later")
            }
        }
    }
    
    public func sendEmail(email: String, handler: @escaping (Bool, String) -> ()) {
        let parameters: [String: Any] = [
            "email": email
        ]
        AF.request("\(API_ADDRESS)/\(ROUTER_PATH)/email", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    guard let status = json["status"].int else { handler(false, "Something wrong on the server. Try again later"); return }
                    guard let message = json["message"].string else { handler(false, "Something wrong on the server. Try again later"); return }
                    guard let data = json["data"].dictionaryObject else { handler(false, "Something wrong on the server. Try again later"); return }
                    DispatchQueue.main.async {
                        if status == 200 {
                            handler(true, "")
                        } else {
                            handler(false, message)
                        }
                    }
                case .failure(let error):
                    print("AccountService login error \(error.localizedDescription)")
                    handler(false, "Something wrong on the server. Try again later")
            }
        }
    }
    
    public func signup(email: String, code: String, password: String, handler: @escaping (Bool, String) -> ()) {
        let parameters: [String: Any] = [
            "email": email,
            "code": code,
            "password": password
        ]
        AF.request("\(API_ADDRESS)/\(ROUTER_PATH)/signup", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    guard let status = json["status"].int else { handler(false, "Something wrong on the server. Try again later"); return }
                    guard let message = json["message"].string else { handler(false, "Something wrong on the server. Try again later"); return }
                    guard let data = json["data"].dictionaryObject else { handler(false, "Something wrong on the server. Try again later"); return }
                    DispatchQueue.main.async {
                        if status == 200 {
                            if let token_str = data["token"] as? String {
                                let token = Token(token: token_str, email: email)
                                RealmService.instance.deleteRealmToken()
                                RealmService.instance.setToken(token: token)
                                handler(true, "")
                            } else {
                                handler(false, "Something wrong on the server. Try again later")
                            }
                        } else {
                            handler(false, message)
                        }
                    }
                case .failure(let error):
                    print("AccountService login error \(error.localizedDescription)")
                    handler(false, "Something wrong on the server. Try again later")
            }
        }
    }
    
    public func resetPasswordEmail(email: String, handler: @escaping (Bool, String) -> ()) {
        let parameters: [String: Any] = [
            "email": email
        ]
        AF.request("\(API_ADDRESS)/\(ROUTER_PATH)/reset_password_email", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    guard let status = json["status"].int else { handler(false, "Something wrong on the server. Try again later"); return }
                    guard let message = json["message"].string else { handler(false, "Something wrong on the server. Try again later"); return }
                    guard let data = json["data"].dictionaryObject else { handler(false, "Something wrong on the server. Try again later"); return }
                    DispatchQueue.main.async {
                        if status == 200 {
                            handler(true, "")
                        } else {
                            handler(false, message)
                        }
                    }
                case .failure(let error):
                    print("AccountService login error \(error.localizedDescription)")
                    handler(false, "Something wrong on the server. Try again later")
            }
        }
    }
    
    public func resetPassword(email: String, code: String, password: String, handler: @escaping (Bool, String) -> ()) {
        let parameters: [String: Any] = [
            "email": email,
            "code": code,
            "password": password
        ]
        AF.request("\(API_ADDRESS)/\(ROUTER_PATH)/reset_password", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    guard let status = json["status"].int else { handler(false, "Something wrong on the server. Try again later"); return }
                    guard let message = json["message"].string else { handler(false, "Something wrong on the server. Try again later"); return }
                    guard let data = json["data"].dictionaryObject else { handler(false, "Something wrong on the server. Try again later"); return }
                    DispatchQueue.main.async {
                        if status == 200 {
                            if let token_str = data["token"] as? String {
                                let token = Token(token: token_str, email: email)
                                RealmService.instance.deleteRealmToken()
                                RealmService.instance.setToken(token: token)
                                handler(true, "")
                            } else {
                                handler(false, "Something wrong on the server. Try again later")
                            }
                        } else {
                            handler(false, message)
                        }
                    }
                case .failure(let error):
                    print("AccountService login error \(error.localizedDescription)")
                    handler(false, "Something wrong on the server. Try again later")
            }
        }
    }
    
    public func changePassword(oldPassword: String, newPassword: String, handler: @escaping (Bool, String) -> ()) {
        guard let token = RealmService.instance.getToken() else { return }
        let headers = ["authorization" : token.token]
        let httpHeaders = HTTPHeaders(headers)
        let parameters: [String: Any] = [
            "oldPassword": oldPassword,
            "newPassword": newPassword
        ]
        AF.request("\(API_ADDRESS)/\(ROUTER_PATH)/change_password", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: httpHeaders).responseJSON { (response) in
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    guard let status = json["status"].int else { handler(false, "Something wrong on the server. Try again later"); return }
                    guard let message = json["message"].string else { handler(false, "Something wrong on the server. Try again later"); return }
                    guard let data = json["data"].dictionaryObject else { handler(false, "Something wrong on the server. Try again later"); return }
                    DispatchQueue.main.async {
                        if status == 200 {
                            handler(true, "")
                        } else {
                            handler(false, message)
                        }
                    }
                case .failure(let error):
                    print("AccountService login error \(error.localizedDescription)")
                    handler(false, "Something wrong on the server. Try again later")
            }
        }
    }
    
}

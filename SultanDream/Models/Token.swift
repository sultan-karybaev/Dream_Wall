//
//  Token.swift
//  SultanDream
//
//  Created by Sultan Karybaev on 25.03.2022.
//

import Foundation
import RealmSwift

class Token: Object {

    @objc dynamic public private(set) var token: String = ""
    @objc dynamic public private(set) var email: String = ""

    override class func primaryKey() -> String {
        return "token"
    }

    convenience init(token: String, email: String) {
        self.init()
        self.token = token
        self.email = email
    }

}

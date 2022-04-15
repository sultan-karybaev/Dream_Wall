//
//  Dream.swift
//  SultanDream
//
//  Created by Sultan Karybaev on 26.03.2022.
//

import Foundation
import RealmSwift

class Dream: Object {
    
    @objc dynamic public private(set) var id: Int = 0
    @objc dynamic public private(set) var topText: String = ""
    @objc dynamic public private(set) var mainText: String = ""
    @objc dynamic public private(set) var first_fileId: Int = 0
    @objc dynamic public private(set) var second_fileId: Int = 0
    @objc dynamic public private(set) var currentDate: Date = Date(timeIntervalSince1970: 0)
    @objc dynamic public private(set) var index: Int = 0

    override class func primaryKey() -> String {
        return "id"
    }

    convenience init(id: Int, topText: String, mainText: String, first_fileId: Int, second_fileId: Int, currentDate: Date) {
        self.init()
        self.id = id
        self.topText = topText
        self.mainText = mainText
        self.first_fileId = first_fileId
        self.second_fileId = second_fileId
        self.currentDate = currentDate
    }
    
    public func setIndex(value: Int) {
        self.index = value
    }

}

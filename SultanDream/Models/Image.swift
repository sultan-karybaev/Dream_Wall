//
//  Image.swift
//  SultanDream
//
//  Created by Sultan Karybaev on 26.03.2022.
//

import Foundation
import RealmSwift

class Image: Object {
    
    @objc dynamic public private(set) var id: Int = 0
    @objc dynamic public private(set) var ETag: String = ""
    @objc dynamic public private(set) var VersionId: String = ""
    @objc dynamic public private(set) var Location: String = ""
    @objc dynamic public private(set) var Key: String = ""
    @objc dynamic public private(set) var Bucket: String = ""
    @objc dynamic public private(set) var finalUrl: String = ""
    @objc dynamic public private(set) var localUrl: String = ""

    override class func primaryKey() -> String {
        return "id"
    }

    convenience init(id: Int, ETag: String, VersionId: String, Location: String, Key: String, Bucket: String, finalUrl: String) {
        self.init()
        self.id = id
        self.ETag = ETag
        self.VersionId = VersionId
        self.Location = Location
        self.Key = Key
        self.Bucket = Bucket
        self.finalUrl = finalUrl
    }
    
    public func setLocalUrl(value: String) {
        self.localUrl = value
    }

}

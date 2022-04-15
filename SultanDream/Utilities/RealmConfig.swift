//
//  RealmConfig.swift
//  SultanDream
//
//  Created by Sultan Karybaev on 22.03.2022.
//

import Foundation
import RealmSwift

class RealmConfig {

    static var realmDataConfig: Realm.Configuration {
        let realmPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(REALM_RUN_CONFIG)
        let config = Realm.Configuration(
            fileURL: realmPath,
            schemaVersion: 2,
            migrationBlock: { migration, oldSchemaVersion in
                print("RealmConfig oldSchemaVersion \(oldSchemaVersion)")
                if (oldSchemaVersion < 2) {
                    migration.enumerateObjects(ofType: Dream.className()) { (_, newDream) in
                        newDream?["index"] = 0
                    }
                }
        })
        return config
    }
}

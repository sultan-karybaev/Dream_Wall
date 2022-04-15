//
//  RealmService.swift
//  SultanDream
//
//  Created by Sultan Karybaev on 25.03.2022.
//

import Foundation
import RealmSwift

class RealmService {
    static let instance = RealmService()
    private init() {}
    
    public func setToken(token: Token) {
        do {
            let realm = try Realm(configuration: RealmConfig.realmDataConfig)
            try realm.write {
                realm.add(token, update: .all)
                try realm.commitWrite()
            }
        } catch let error {
            debugPrint("Error adding Token to realm! \(error.localizedDescription)")
        }
    }

    public func getToken() -> Token? {
        do {
            let realm = try Realm(configuration: RealmConfig.realmDataConfig)
            let tokenResults = realm.objects(Token.self)
            return tokenResults.first
        } catch {
            return nil
        }
    }

    public func getRealmTokenCount() -> Int {
        do {
            let realm = try Realm(configuration: RealmConfig.realmDataConfig)
            let tokenResults = realm.objects(Token.self)
            return tokenResults.count
        } catch {
            return 0
        }
    }

    public func deleteRealmToken() {
        do {
            let realm = try Realm(configuration: RealmConfig.realmDataConfig)
            let tokenResults = realm.objects(Token.self)
            try realm.write {
                realm.delete(tokenResults)
                try realm.commitWrite()
            }
        } catch let error {
            debugPrint("Error adding Dream to realm! \(error.localizedDescription)")
        }
    }
    
    
    //Dream
    public func setDream(dream: Dream) {
        do {
            let realm = try Realm(configuration: RealmConfig.realmDataConfig)
            try realm.write {
                realm.add(dream, update: .all)
                try realm.commitWrite()
            }
        } catch let error {
            debugPrint("Error adding Token to realm! \(error.localizedDescription)")
        }
    }
    
    public func getDream() -> Dream? {
        do {
            let realm = try Realm(configuration: RealmConfig.realmDataConfig)
            let dreams = realm.objects(Dream.self)
            print("RealmService getDream dreams \(dreams.count)")
            return dreams.first
        } catch {
            return nil
        }
    }
    
    public func getDreams() -> [Dream] {
        do {
            let realm = try Realm(configuration: RealmConfig.realmDataConfig)
            let dreams = realm.objects(Dream.self)
            return Array(dreams)
        } catch {
            return []
        }
    }
    
    public func deleteDreams() {
        do {
            let realm = try Realm(configuration: RealmConfig.realmDataConfig)
            let dreams = realm.objects(Dream.self)
            try realm.write {
                realm.delete(dreams)
                try realm.commitWrite()
            }
        } catch let error {
            debugPrint("Error adding Dream to realm! \(error.localizedDescription)")
        }
    }
    
    //Image
    public func setImage(image: Image) {
        do {
            let realm = try Realm(configuration: RealmConfig.realmDataConfig)
            try realm.write {
                realm.add(image, update: .all)
                try realm.commitWrite()
            }
        } catch let error {
            debugPrint("Error adding Token to realm! \(error.localizedDescription)")
        }
    }
    
    public func getImages() -> [Image] {
        do {
            let realm = try Realm(configuration: RealmConfig.realmDataConfig)
            let images = realm.objects(Image.self)
            return Array(images)
        } catch {
            return []
        }
    }
    
    public func getImage(id: Int) -> Image? {
        do {
            let realm = try Realm(configuration: RealmConfig.realmDataConfig)
            let image = realm.object(ofType: Image.self, forPrimaryKey: id)
            return image
        } catch {
            return nil
        }
    }
    
    public func setImageLocalUrl(id: Int, localUrl: String) {
        do {
            let realm = try Realm(configuration: RealmConfig.realmDataConfig)
            let image = realm.object(ofType: Image.self, forPrimaryKey: id)
            try realm.write {
                image?.setLocalUrl(value: localUrl)
                try realm.commitWrite()
            }
        } catch let error { debugPrint("Error setUserIsAddConfirmed \(error.localizedDescription)") }
    }
    
    public func deleteImages() {
        do {
            let realm = try Realm(configuration: RealmConfig.realmDataConfig)
            let dreams = realm.objects(Image.self)
            try realm.write {
                realm.delete(dreams)
                try realm.commitWrite()
            }
        } catch let error {
            debugPrint("Error adding Dream to realm! \(error.localizedDescription)")
        }
    }
}

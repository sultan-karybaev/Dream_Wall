//
//  RESTService.swift
//  SultanDream
//
//  Created by Sultan Karybaev on 25.03.2022.
//

import Foundation
import Alamofire
import SwiftyJSON

class RESTService {
    static let instance = RESTService()
    private init() {}
    private let ROUTER_PATH = "dreams"
    
    public func getDreams(handler: @escaping (Bool, Dream?, Dream?, Dream?) -> ()) {
        guard let token = RealmService.instance.getToken() else { return }
        let headers = ["authorization" : token.token]
        let httpHeaders = HTTPHeaders(headers)
        AF.request("\(API_ADDRESS)/\(ROUTER_PATH)/get_random_dreams", method: .post, parameters: nil, encoding: JSONEncoding.default, headers: httpHeaders).responseJSON { (response) in
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    guard let status = json["status"].int else { return }
                    guard let message = json["message"].string else { return }
                    guard let data = json["data"].dictionaryObject else { return }
                    DispatchQueue.main.async {
                        if status == 200 {
                            guard let firstDream = data["first_dream"] as? [String : Any] else { return }
                            guard let secondDream = data["second_dream"] as? [String : Any] else { return }
                            guard let thirdDream = data["third_dream"] as? [String : Any] else { return }
                            RealmService.instance.deleteImages()
                            guard let firstDreamObj = self.processDream(data: firstDream) else { return }
                            guard let secondDreamObj = self.processDream(data: secondDream) else { return }
                            guard let thirdDreamObj = self.processDream(data: thirdDream) else { return }
                            RealmService.instance.deleteDreams()
                            firstDreamObj.setIndex(value: 1)
                            secondDreamObj.setIndex(value: 2)
                            thirdDreamObj.setIndex(value: 3)
                            RealmService.instance.setDream(dream: firstDreamObj)
                            RealmService.instance.setDream(dream: secondDreamObj)
                            RealmService.instance.setDream(dream: thirdDreamObj)
                            handler(true, firstDreamObj, secondDreamObj, thirdDreamObj)
                        } else {
                            handler(false, nil, nil, nil)
                        }
                    }
                case .failure(let error):
                    print("AccountService getDream error \(error.localizedDescription)")
            }
        }
    }
    
    public func sendDream(isEdit: Bool, dreamId: Int, index: Int, topText: String, mainText: String, firstImageData: Data, secondImageData: Data, handler: @escaping (Bool, Double) -> ()) {
        guard let token = RealmService.instance.getToken() else { return }
        let headers = ["authorization" : token.token]
        let httpHeaders = HTTPHeaders(headers)
        let parameters: [String: String] = [
            "IsEdit": "\(isEdit)",
            "IsFirst": "\(firstImageData.count != 0)",
            "IsSecond": "\(secondImageData.count != 0)",
            "DreamId": "\(dreamId)",
            "TopText": topText,
            "MainText": mainText
        ]
        print("sendDream parameters \(parameters)")
        print("sendDream firstImageData \(firstImageData)")
        print("sendDream secondImageData \(secondImageData)")
//        sendDream firstImageData 4766019 bytes
//        sendDream secondImageData 8009170 bytes
        AF.upload(multipartFormData: { (multipartFormData) in
            if firstImageData.count > 0 {
                multipartFormData.append(firstImageData, withName: "First", fileName: "file1.jpg", mimeType: "image/jpg")
            }
            if secondImageData.count > 0 {
                multipartFormData.append(secondImageData, withName: "Second", fileName: "file2.jpg", mimeType: "image/jpg")
            }
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: "\(API_ADDRESS)/\(ROUTER_PATH)/upload_images", method: .post, headers: httpHeaders).uploadProgress(closure: { (progress) in
            print("sendDream Upload Progress: \(progress.fractionCompleted)")
            handler(false, progress.fractionCompleted)
        }).responseJSON { (response) in
            print("RESTService response")
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("RESTService sendDream json \(json)")
                    guard let status = json["status"].int else { return }
                    guard let message = json["message"].string else { return }
                    guard let data = json["data"].dictionaryObject else { return }
                    DispatchQueue.main.async {
                        if status == 200 {
                            if let dream = data["dream"] as? [String : Any], let dreamObj = self.processDream(data: dream) {
//                                RealmService.instance.deleteDreams()
                                dreamObj.setIndex(value: index)
                                RealmService.instance.setDream(dream: dreamObj)
                            }
                            handler(true, 1)
                        } else {
                            handler(true, 1)
                        }
                    }
                case .failure(let error):
                    print("RESTService sendImage error \(error.localizedDescription)")
                    handler(true, 1)
            }
        }
    }
    
    public func getNumberOfDreams(handler: @escaping (Int) -> ()) {
        guard let token = RealmService.instance.getToken() else { return }
        let headers = ["authorization" : token.token]
        let httpHeaders = HTTPHeaders(headers)
        AF.request("\(API_ADDRESS)/\(ROUTER_PATH)/get_dreams_count", method: .post, parameters: nil, encoding: JSONEncoding.default, headers: httpHeaders).responseJSON { (response) in
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    guard let status = json["status"].int else { return }
                    guard let message = json["message"].string else { return }
                    guard let data = json["data"].dictionaryObject else { return }
                    DispatchQueue.main.async {
                        if status == 200 {
                            guard let count = data["count"] as? Int else { return }
                            handler(count)
                        }
                    }
                case .failure(let error):
                    print("RESTService getNumberOfDreams error \(error.localizedDescription)")
            }
        }
    }
    
    public func getIdeas(handler: @escaping ([String]) -> ()) {
        guard let token = RealmService.instance.getToken() else { return }
        let headers = ["authorization" : token.token]
        let httpHeaders = HTTPHeaders(headers)
        AF.request("\(API_ADDRESS)/\(ROUTER_PATH)/get_ideas", method: .post, parameters: nil, encoding: JSONEncoding.default, headers: httpHeaders).responseJSON { (response) in
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    guard let status = json["status"].int else { return }
                    guard let message = json["message"].string else { return }
                    guard let data = json["data"].dictionaryObject else { return }
                    DispatchQueue.main.async {
                        if status == 200 {
                            guard let count = data["ideas"] as? [String] else { return }
                            handler(count)
                        }
                    }
                case .failure(let error):
                    print("RESTService getNumberOfDreams error \(error.localizedDescription)")
            }
        }
    }
    
    private func processDream(data: [String : Any]) -> Dream? {
        guard let id = data["id"] as? Int else { return nil }
        guard let topText = data["topText"] as? String else { return nil }
        guard let mainText = data["mainText"] as? String else { return nil }
        guard let first_fileId = data["first_fileId"] as? Int else { return nil }
        guard let second_fileId = data["second_fileId"] as? Int else { return nil }
        guard let first = data["First"] as? [String: Any] else { return nil }
        guard let second = data["Second"] as? [String: Any] else { return nil }
        guard let firstImage = self.processImage(data: first) else { return nil }
        guard let secondImage = self.processImage(data: second) else { return nil }
        RealmService.instance.setImage(image: firstImage)
        RealmService.instance.setImage(image: secondImage)
        let dreamObj = Dream(id: id, topText: topText, mainText: mainText, first_fileId: first_fileId, second_fileId: second_fileId, currentDate: Date())
        return dreamObj
    }
    
    private func processImage(data: [String : Any]) -> Image? {
        guard let id = data["id"] as? Int else { return nil }
        guard let ETag = data["ETag"] as? String else { return nil }
        guard let VersionId = data["VersionId"] as? String else { return nil }
        guard let Location = data["Location"] as? String else { return nil }
        guard let Key = data["Key"] as? String else { return nil }
        guard let Bucket = data["Bucket"] as? String else { return nil }
        guard let finalUrl = data["finalUrl"] as? String else { return nil }
        let image = Image(id: id, ETag: ETag, VersionId: VersionId, Location: Location, Key: Key, Bucket: Bucket, finalUrl: finalUrl)
        return image
    }
}

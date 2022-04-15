//
//  FileService.swift
//  SultanDream
//
//  Created by Sultan Karybaev on 22.03.2022.
//

import Foundation

class FileService {
    static let instance = FileService()
    private var mainUrl: URL = URL(fileURLWithPath: "")
    private var totalImageFilesSize: Int = 0
    private init() {}
    
    private func getMainUrl() -> URL? {
        if FileManager.default.fileExists(atPath: self.mainUrl.path) && self.mainUrl.lastPathComponent == "Images" {
            return self.mainUrl
        } else if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let mainUrl = url.appendingPathComponent("Images")
            do {
                if !FileManager.default.fileExists(atPath: mainUrl.path) {
                        try FileManager.default.createDirectory(atPath: mainUrl.path, withIntermediateDirectories: true, attributes: nil)
                    self.mainUrl = mainUrl
                    return mainUrl
                } else {
                    guard let isDirectory = try self.mainUrl.resourceValues(forKeys: [.isDirectoryKey]).isDirectory else { return nil }
                    self.mainUrl = mainUrl
                    return mainUrl
                }
            } catch let error {
                debugPrint("FileService init Error \(error.localizedDescription)")
                return nil
            }
        }
        return nil
    }
    
    public func isImageExist(name: String) -> Bool {
        guard let mainUrl = self.getMainUrl() else { return false }
        let filePath = mainUrl.appendingPathComponent(name)
        return FileManager.default.fileExists(atPath: filePath.path)
    }
    
    public func getImageSize(name: String) -> Int {
        guard let mainUrl = self.getMainUrl() else { return 0 }
        let imagePath = mainUrl.appendingPathComponent(name)
        do {
            guard let size = try imagePath.resourceValues(forKeys: [.totalFileAllocatedSizeKey]).totalFileAllocatedSize else { return 0 }
            return size
        } catch let error { debugPrint("getImageSize Error \(error.localizedDescription)") }
        return 0
    }
    
    public func getRealmFileSize() -> Int {
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let realmFileUrl = url.appendingPathComponent(REALM_RUN_CONFIG)
            do {
                guard let size = try realmFileUrl.resourceValues(forKeys: [.totalFileAllocatedSizeKey]).totalFileAllocatedSize else { return 0 }
                return size
            } catch let error { debugPrint("showFileUrl Error \(error.localizedDescription)") }
        }
        return 0
    }
    
    public func saveImage(imageData: Data, name: String) {
        guard let mainUrl = self.getMainUrl() else { return }
        let fileURL = mainUrl.appendingPathComponent(name)
        do {
            try imageData.write(to: fileURL)
        } catch let error {
            print("FileService saveImage error \(error.localizedDescription)")
        }
    }
    
    public func getImageDataFromPhone(filePath: String) -> Data? {
        guard let mainUrl = self.getMainUrl() else { return nil }
        let fileURL = mainUrl.appendingPathComponent(filePath)
        let isExist = FileManager.default.fileExists(atPath: fileURL.path)
        if isExist {
            do {
                let data = try Data(contentsOf: fileURL)
                //print("getImageFromPhone data \(data)")
                return data
            } catch {
                return nil
            }
        }
        return nil
    }
    
    public func getImageFilesSize() -> Int {
        guard let mainUrl = self.getMainUrl() else { return 0 }
        self.totalImageFilesSize = 0
        do {
            guard let isDirectory = try mainUrl.resourceValues(forKeys: [.isDirectoryKey]).isDirectory else { return self.totalImageFilesSize }
            if isDirectory {
                let urlArray = try FileManager.default.contentsOfDirectory(at: mainUrl, includingPropertiesForKeys: nil, options: [])
                for url in urlArray {
                    guard let size = try url.resourceValues(forKeys: [.totalFileAllocatedSizeKey]).totalFileAllocatedSize else { continue }
                    self.totalImageFilesSize += size
                }
            }
        } catch let error { debugPrint("getImageFilesSize Error \(error.localizedDescription)") }
        return self.totalImageFilesSize
    }
    
    public func getAllImageNames() -> [String] {
        guard let mainUrl = self.getMainUrl() else { return [] }
        //print("getAllImageUrls self.mainUrl \(FileManager.default.fileExists(atPath: mainUrl.path))")
        do {
            guard let isDirectory = try mainUrl.resourceValues(forKeys: [.isDirectoryKey]).isDirectory else { return [] }
            //print("getAllImageUrls isDirectory \(isDirectory)")
            if isDirectory {
                let urlArray = try FileManager.default.contentsOfDirectory(at: mainUrl, includingPropertiesForKeys: nil, options: [])
                let urlPaths = urlArray.map { $0.lastPathComponent }
                //print("getAllImageUrls urlPaths \(urlPaths)")
                return urlPaths
//                print("getAllImageUrls urlArray \(urlArray)")
//
//                return urlArray
            }
        } catch let error { debugPrint("getAllImageUrls Error \(error.localizedDescription)") }
        return []
    }
    
    public func removeImage(name: String) {
        if name == "" { return }
        guard let mainUrl = self.getMainUrl() else { return }
        let imagePath = mainUrl.appendingPathComponent(name)
        self.removeImageByUrl(url: imagePath)
    }
    
    private func removeImageByUrl(url: URL) {
        if FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.removeItem(at: url)
            } catch let error { debugPrint("FileService removeImage Error \(error.localizedDescription)") }
        }
    }
    
    public func removeAllImages() {
        guard let mainUrl = self.getMainUrl() else { return }
        do {
            guard let isDirectory = try mainUrl.resourceValues(forKeys: [.isDirectoryKey]).isDirectory else { return }
            if isDirectory {
                let urlArray = try FileManager.default.contentsOfDirectory(at: mainUrl, includingPropertiesForKeys: nil, options: [])
                for url in urlArray {
                    try FileManager.default.removeItem(at: url)
                }
            }
        } catch let error { debugPrint("removeAllImages Error \(error.localizedDescription)") }
//        let images = RealmImageService.instance.getImages()
//        for image in images {
//            RealmImageService.instance.setImageSmallFilePath(id: image.id, smallFilePath: "")
//            RealmImageService.instance.setImageMediumFilePath(id: image.id, mediumFilePath: "")
//            RealmImageService.instance.setImageOriginalFilePath(id: image.id, originalFilePath: "")
//        }
//        RealmStaticMapImageService.instance.clearAllStaticMapImages()
    }
    
//    public func clearNoneExistingFiles() {
//        let imageUrls = self.getAllImageNames()
//        var urlsToDelete: Set<String> = Set(imageUrls)
//        let images = RealmImageService.instance.getImages()
//        for image in images {
//            if urlsToDelete.contains(image.smallFilePath) { urlsToDelete.remove(image.smallFilePath) }
//            if urlsToDelete.contains(image.mediumFilePath) { urlsToDelete.remove(image.mediumFilePath) }
//            if urlsToDelete.contains(image.originalFilePath) { urlsToDelete.remove(image.originalFilePath) }
//            if self.isImageExist(name: image.smallFilePath), let imageData = self.getImageDataFromPhone(filePath: image.smallFilePath), let uiimage = UIImage(data: imageData), (uiimage.size.height == 200 || uiimage.size.width == 200) {} else {
//                RealmImageService.instance.setImageSmallFilePath(id: image.id, smallFilePath: "")
//            }
//            if self.isImageExist(name: image.mediumFilePath), let imageData = self.getImageDataFromPhone(filePath: image.mediumFilePath), let uiimage = UIImage(data: imageData), (uiimage.size.height == 720 || uiimage.size.width == 720) {} else {
//                RealmImageService.instance.setImageMediumFilePath(id: image.id, mediumFilePath: "")
//            }
//            if self.isImageExist(name: image.originalFilePath), let imageData = self.getImageDataFromPhone(filePath: image.originalFilePath), let _ = UIImage(data: imageData) {} else {
//                RealmImageService.instance.setImageOriginalFilePath(id: image.id, originalFilePath: "")
//            }
//        }
//        let staticMapImages = RealmStaticMapImageService.instance.getAllStaticMapImages()
//        for staticMapImage in staticMapImages {
//            if urlsToDelete.contains(staticMapImage.filePath) { urlsToDelete.remove(staticMapImage.filePath) }
//            if self.isImageExist(name: staticMapImage.filePath), let imageData = self.getImageDataFromPhone(filePath: staticMapImage.filePath), let _ = UIImage(data: imageData) {} else {
//                RealmStaticMapImageService.instance.deleteStaticMapImage(staticMapImage: staticMapImage)
//            }
//        }
//        for name in urlsToDelete {
//            self.removeImage(name: name)
//        }
//    }
}

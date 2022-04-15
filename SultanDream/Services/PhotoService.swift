//
//  PhotoService.swift
//  SultanDream
//
//  Created by Sultan Karybaev on 25.03.2022.
//

import UIKit
import Photos

class PhotoService {

    static let instance = PhotoService()
    private init() {}
    
    private var photos: [PHAsset] = []
    private var imagesDict: [String: UIImage] = [:]
    private var fullSizeImagesDict: [String: UIImage] = [:]
    
    public func isPhotoStatusDetermined() -> Bool {
        let photoStatus = PHPhotoLibrary.authorizationStatus()
        return photoStatus != .notDetermined
    }
    
    public func requestAccess(handler: @escaping () -> ()) {
        PHPhotoLibrary.requestAuthorization { (newStatus) in
            handler()
        }
    }
    
    public func isPhotoAllowed() -> Bool {
        let photoStatus = PHPhotoLibrary.authorizationStatus()
        switch photoStatus {
            case .notDetermined:
                return false
            case .restricted:
                return false
            case .denied:
                return false
            case .authorized:
                return true
            case .limited:
                return false
            @unknown default:
                return false
        }
    }
    
    public func launchService() {
        if self.isPhotoAllowed() {
            self.getPhotosFromGallery()
        }
    }
    
    private func getPhotosFromGallery() {
        self.photos = []
        let fetchOptions: PHFetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        fetchResult.enumerateObjects({ (object, index, stop) -> Void in
            self.photos.append(object)
        })
    }
    
    public func getPhotos() -> [PHAsset] {
        self.photos
    }
    
    public func getUIImage(asset: PHAsset) -> (ImageSize, UIImage?) {
        if let uiimage = self.fullSizeImagesDict[asset.localIdentifier] {
            return (.Original, uiimage)
        } else if let uiimage = self.imagesDict[asset.localIdentifier] {
            return (.Small, uiimage)
        } else {
            return (.None, nil)
        }
    }

    public func getImage(asset: PHAsset, handler: @escaping (UIImage?) -> ()) {
        if let uiimage = self.imagesDict[asset.localIdentifier] {
            handler(uiimage)
            return
        }
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.deliveryMode = .highQualityFormat
        let size = CGSize(width: 200, height: 200)
        PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: nil, resultHandler: { (image, attributes) in
            DispatchQueue.main.async {
                if let image = image {
                    self.imagesDict[asset.localIdentifier] = image
                }
                handler(image)
            }
        })
    }
    
    public func getFullImage(asset: PHAsset, handler: @escaping (UIImage?) -> ()) {
        if let uiimage = self.fullSizeImagesDict[asset.localIdentifier] {
            handler(uiimage)
            return
        }
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.deliveryMode = .highQualityFormat
        let size = PHImageManagerMaximumSize
//        let size = CGSize(width: 600, height: 600)
        PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: options, resultHandler: { (image, attributes) in
            DispatchQueue.main.async {
                self.fullSizeImagesDict[asset.localIdentifier] = image
                handler(image)
            }
        })
    }
    
}

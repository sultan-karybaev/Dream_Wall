//
//  PhotoGalleryVC.swift
//  SultanDream
//
//  Created by Sultan Karybaev on 25.03.2022.
//

import UIKit
import Photos

@objc protocol PhotoGalleryVCDelegate: AnyObject {
    @objc optional func chosenAsset(asset: PHAsset)
}

class PhotoGalleryVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var absentLabel: UILabel!
    
    private var photos: [PHAsset] = []
    private let cellWidth = ((UIScreen.main.bounds.size.width)/4)-1

    weak public var delegate: PhotoGalleryVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLayer()
        self.setCollectionView()
    }
    
    private func setLayer() {
        self.absentLabel.isHidden = true
    }
    
    private func setCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        PhotoService.instance.launchService()
        self.photos = PhotoService.instance.getPhotos()
        self.absentLabel.isHidden = self.photos.count > 0
        self.collectionView.isHidden = self.photos.count == 0
        self.collectionView.reloadData()
    }

}

extension PhotoGalleryVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoGalleryImageCell", for: indexPath) as? PhotoGalleryImageCell else { return UICollectionViewCell() }
        let asset = self.photos[indexPath.row]
        let (imageSize, uiimage) = PhotoService.instance.getUIImage(asset: asset)
        cell.mainImageView.image = uiimage
        if imageSize == .None {
            PhotoService.instance.getImage(asset: asset) { (image) in
                cell.mainImageView.image = image
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.cellWidth, height: self.cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = self.photos[indexPath.row]
        self.delegate?.chosenAsset?(asset: asset)
        self.dismiss(animated: true, completion: nil)
    }
    
}

enum ImageSize {
    case Original
    case Medium
    case Small
    case Micro
    case None
}

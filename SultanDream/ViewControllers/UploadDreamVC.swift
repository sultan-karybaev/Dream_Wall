//
//  UploadDreamVC.swift
//  SultanDream
//
//  Created by Sultan Karybaev on 24.03.2022.
//

import UIKit
import Photos

@objc protocol UploadDreamVCDelegate: AnyObject {
    @objc optional func updateDream()
}

class UploadDreamVC: UIViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var topTitleTextField: UITextField!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var mainTitleTextField: UITextField!
    @IBOutlet weak var topImageLabel: UILabel!
    @IBOutlet weak var topImageMainView: UIView!
    @IBOutlet weak var topImageMainViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topImageAddImageButton: UIButton!
    @IBOutlet weak var topImageImageView: UIImageView!
    @IBOutlet weak var topImageProgressView: UIView!
    @IBOutlet weak var topImageProgressViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var topImageProgressLabel: UILabel!
    @IBOutlet weak var topImageChangeButton: UIButton!
    @IBOutlet weak var topImageChangeButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomImageLabel: UILabel!
    @IBOutlet weak var bottomImageMainView: UIView!
    @IBOutlet weak var bottomImageMainViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomImageAddImageButton: UIButton!
    @IBOutlet weak var bottomImageImageView: UIImageView!
    @IBOutlet weak var bottomImageProgressView: UIView!
    @IBOutlet weak var bottomImageProgressViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomImageProgressLabel: UILabel!
    @IBOutlet weak var bottomImageChangeButton: UIButton!
    @IBOutlet weak var bottomImageChangeButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomView: KeyboardBindView!
    @IBOutlet weak var bottomViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var uploadDreamButton: UIButton!
    
    weak public var delegate: UploadDreamVCDelegate?
    
    private var squareWidth: CGFloat = 0
    private var isFirstImage: Bool = false
    private var isSecondImage: Bool = false
    private var firstAsset: PHAsset?
    private var secondAsset: PHAsset?
    private var isEdit: Bool = false
    private var editDream: Dream?
    private var firstDream: Dream?
    private var secondDream: Dream?
    private var thirdDream: Dream?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLayer()
        self.setGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.bottomView.bindToKeyboard()
        self.bottomView.setBottomLayoutConstraint(constraint: self.bottomViewBottomConstraint)
        if #available(iOS 11.0, *) {
            let bottomPadding = self.view.safeAreaInsets.bottom
            self.bottomView.setScreenBottomPadding(padding: bottomPadding)
        }
    }
    
    private func setLayer() {
        self.title = self.isEdit ? "Change Dream" : "Upload Dream"
        self.segmentControl.isHidden = !self.isEdit
//        let logoutBarItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(self.openLogout))
//        logoutBarItem.tintColor = MAIN_COLOR
//        self.navigationItem.rightBarButtonItem = logoutBarItem
        self.squareWidth = self.view.frame.width - 100
        if #available(iOS 13.0, *) {
            self.segmentControl.selectedSegmentTintColor = MAIN_COLOR
        }
        self.segmentControl.tintColor = MAIN_COLOR
        self.segmentControl.selectedSegmentIndex = 0
        self.errorLabel.isHidden = true
//        self.topTitleTextField.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        self.topTitleTextField.layer.borderWidth = 1
//        self.topTitleTextField.layer.cornerRadius = 6
        self.mainTitleTextField.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.mainTitleTextField.layer.borderWidth = 1
        self.mainTitleTextField.layer.cornerRadius = 6
        self.topImageMainView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.topImageMainView.layer.borderWidth = 1
        self.topImageMainViewHeightConstraint.constant = self.squareWidth
        self.topImageImageView.isHidden = true
        self.topImageProgressView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6)
        self.topImageProgressViewWidthConstraint.constant = 0
        self.topImageProgressLabel.isHidden = true
        self.topImageChangeButtonHeightConstraint.constant = 0
        self.bottomImageMainView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.bottomImageMainView.layer.borderWidth = 1
        self.bottomImageMainViewHeightConstraint.constant = self.squareWidth
        self.bottomImageImageView.isHidden = true
        self.bottomImageProgressView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6)
        self.bottomImageProgressViewWidthConstraint.constant = 0
        self.bottomImageProgressLabel.isHidden = true
        self.bottomImageChangeButtonHeightConstraint.constant = 0
        self.topImageAddImageButton.setTitleColor(MAIN_COLOR, for: .normal)
        self.topImageChangeButton.backgroundColor = MAIN_COLOR
        self.topImageChangeButton.setTitleColor(UIColor.black, for: .normal)
        self.bottomImageAddImageButton.setTitleColor(MAIN_COLOR, for: .normal)
        self.bottomImageChangeButton.backgroundColor = MAIN_COLOR
        self.bottomImageChangeButton.setTitleColor(UIColor.black, for: .normal)
        self.uploadDreamButton.backgroundColor = MAIN_COLOR
        self.uploadDreamButton.setTitleColor(UIColor.black, for: .normal)
        if self.isEdit {
            let dreams = RealmService.instance.getDreams().sorted { $0.index < $1.index }
            for (i, dream) in dreams.enumerated() {
                if i == 0 { self.firstDream = dream }
                else if i == 1 { self.secondDream = dream }
                else if i == 2 { self.thirdDream = dream }
            }
            self.editDream = self.firstDream
            self.setDreamLayer()
        }
    }
    
    private func setDreamLayer() {
        self.errorLabel.isHidden = true
        self.mainTitleLabel.isHidden = true
        self.mainTitleTextField.isHidden = true
        self.topImageLabel.isHidden = true
        self.topImageMainView.isHidden = true
        self.topImageChangeButtonHeightConstraint.constant = 0
        self.bottomImageLabel.isHidden = true
        self.bottomImageMainView.isHidden = true
        self.bottomImageChangeButtonHeightConstraint.constant = 0
        guard let dream = self.editDream else { return }
        self.mainTitleLabel.isHidden = false
        self.mainTitleTextField.isHidden = false
        self.topImageLabel.isHidden = false
        self.topImageMainView.isHidden = false
        self.bottomImageLabel.isHidden = false
        self.bottomImageMainView.isHidden = false
        self.mainTitleTextField.text = dream.mainText
        if let firstImage = RealmService.instance.getImage(id: dream.first_fileId), let data = FileService.instance.getImageDataFromPhone(filePath: firstImage.localUrl), let uiimage = UIImage(data: data) {
            self.topImageImageView.image = uiimage
            self.topImageAddImageButton.isHidden = true
            self.topImageImageView.isHidden = false
            self.topImageChangeButtonHeightConstraint.constant = 30
        }
        if let secondImage = RealmService.instance.getImage(id: dream.second_fileId), let data = FileService.instance.getImageDataFromPhone(filePath: secondImage.localUrl), let uiimage = UIImage(data: data) {
            self.bottomImageImageView.image = uiimage
            self.bottomImageAddImageButton.isHidden = true
            self.bottomImageImageView.isHidden = false
            self.bottomImageChangeButtonHeightConstraint.constant = 30
        }
    }
    
    private func setGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc private func openLogout() {
        var actions: [UIAlertAction] = []
        let deleteGroupAction = UIAlertAction(title: "Log out", style: .default, handler: {(_: UIAlertAction!) in
            self.logout()
        })
        actions.append(deleteGroupAction)
        self.showActionSheet(actions: actions)
    }
    
    private func logout() {
        guard let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC else { return }
        loginVC.modalPresentationStyle = .fullScreen
        RealmService.instance.deleteRealmToken()
        RealmService.instance.deleteDreams()
        RealmService.instance.deleteImages()
        self.present(loginVC, animated: true, completion: nil)
    }
    
    public func setIsEdit(value: Bool) {
        self.isEdit = value
    }
    
    public func setDream(dream: Dream) {
        self.isEdit = true
        self.editDream = dream
    }
    
    private func openGallery() {
        if PhotoService.instance.isPhotoStatusDetermined() {
            if PhotoService.instance.isPhotoAllowed() {
                guard let photoGalleryVC = self.storyboard?.instantiateViewController(withIdentifier: "PhotoGalleryVC") as? PhotoGalleryVC else { return }
                photoGalleryVC.delegate = self
                self.present(photoGalleryVC, animated: true, completion: nil)
            } else {
                self.showPrivacySettingAlert(message: "Please, allow Dream Reminder to access Photos in Phone Settings")
            }
        } else {
            PhotoService.instance.requestAccess {
                DispatchQueue.main.async {
                    self.openGallery()
                }
            }
        }
    }
    
    private func openPhoneGallery(isFirstImage: Bool) {
        self.isFirstImage = isFirstImage
        self.isSecondImage = !isFirstImage
        self.openGallery()
    }
    
    @IBAction func segmentControlValueChanged(_ sender: Any) {
        if self.segmentControl.selectedSegmentIndex == 0 {
            self.editDream = self.firstDream
        } else if self.segmentControl.selectedSegmentIndex == 1 {
            self.editDream = self.secondDream
        } else if self.segmentControl.selectedSegmentIndex == 2 {
            self.editDream = self.thirdDream
        }        
        self.setDreamLayer()
    }
    
    @IBAction func topImageAddImageButtonWasPressed(_ sender: Any) {
        self.openPhoneGallery(isFirstImage: true)
    }
    
    @IBAction func topImageChangeImageButtonWasPressed(_ sender: Any) {
        self.openPhoneGallery(isFirstImage: true)
    }
    
    @IBAction func bottomImageAddImageButtonWasPressed(_ sender: Any) {
        self.openPhoneGallery(isFirstImage: false)
    }
    
    @IBAction func bottomImageChangeImageButtonWasPressed(_ sender: Any) {
        self.openPhoneGallery(isFirstImage: false)
    }
    
    @IBAction func uploadButtonWasPressed(_ sender: Any) {
        if let topTitle = self.topTitleTextField.text, let mainTitle = self.mainTitleTextField.text, mainTitle != "" {
            if topTitle.count < 16 {
                if mainTitle.count < 36 {
                    self.uploadDream(topTitle: topTitle, mainTitle: mainTitle)
                } else {
                    self.errorLabel.isHidden = false
                    self.errorLabel.text = "Main Title should be less 36 characters"
                }
            } else {
                self.errorLabel.isHidden = false
                self.errorLabel.text = "Top Title should be less 16 characters"
            }
        } else {
            self.errorLabel.isHidden = false
            self.errorLabel.text = "Main Title cannot be empty"
        }
    }
    
    private func uploadDream(topTitle: String, mainTitle: String) {
        self.errorLabel.isHidden = true
        let isEdit = self.isEdit
        if self.isEdit, let dream = self.editDream {
            if self.firstAsset == nil && self.secondAsset == nil && dream.topText == topTitle && dream.mainText == mainTitle {
                self.errorLabel.isHidden = false
                self.errorLabel.text = "Add some changes"
                return
            }
            let isFirst = self.firstAsset != nil
            let isSecond = self.secondAsset != nil
            var firstData = Data()
            var secondData = Data()
            self.getImageData(asset: self.firstAsset) { [weak self] data1 in
                firstData = data1
                self?.getImageData(asset: self?.secondAsset) { [weak self] data2 in
                    secondData = data2
                    self?.segmentControl.isEnabled = false
                    self?.mainTitleTextField.isEnabled = false
                    self?.topImageChangeButton.isEnabled = false
                    self?.bottomImageChangeButton.isEnabled = false
                    self?.uploadDreamButton.isEnabled = false
                    RESTService.instance.sendDream(isEdit: isEdit, dreamId: dream.id, index: dream.index, topText: topTitle, mainText: mainTitle, firstImageData: firstData, secondImageData: secondData) { [weak self] isFinish, progress in
                        self?.setProgress(isFinish: isFinish, progress: progress, isFirst: isFirst, isSecond: isSecond)
                    }
                }
            }
        } else if let firstAsset = self.firstAsset, let secondAsset = self.secondAsset, !self.isEdit {
            self.errorLabel.isHidden = true
            var firstData = Data()
            var secondData = Data()
            self.getImageData(asset: firstAsset) { [weak self] data1 in
                firstData = data1
                self?.getImageData(asset: secondAsset) { [weak self] data2 in
                    secondData = data2
                    self?.segmentControl.isEnabled = false
                    self?.mainTitleTextField.isEnabled = false
                    self?.topImageChangeButton.isEnabled = false
                    self?.bottomImageChangeButton.isEnabled = false
                    self?.uploadDreamButton.isEnabled = false
                    RESTService.instance.sendDream(isEdit: isEdit, dreamId: 0, index: 0, topText: topTitle, mainText: mainTitle, firstImageData: firstData, secondImageData: secondData) { [weak self] isFinish, progress in
                        self?.setProgress(isFinish: isFinish, progress: progress, isFirst: true, isSecond: true)
                    }
                }
            }
        } else {
            self.errorLabel.isHidden = false
            self.errorLabel.text = "Dream must have 2 pictures"
        }
    }
    
    private func getImageData(asset: PHAsset?, handler: @escaping (Data) -> ()) {
        guard let phasset = asset else { handler(Data()); return }
        let (imageSize, uiimage) = PhotoService.instance.getUIImage(asset: phasset)
//        guard let data = uiimage?.jpegData(compressionQuality: 1.0) else { return }
//        print("UploadDreamVC getImageData \(data) \(data.count)")
        if imageSize != .Original {
            PhotoService.instance.getFullImage(asset: phasset) { [weak self] (image) in
//                guard let data = image?.jpegData(compressionQuality: 1.0) else { return }
//                guard let data = image?.jpegData(compressionQuality: 0.5) else { return }
                if let uiimage = image {
                    guard let data = self?.getDataBySize(uiimage: uiimage, byteCount: 1500000, quality: 1) else { return }
                    handler(data)
                }
                
            }
        } else {
//            guard let data = uiimage?.jpegData(compressionQuality: 1.0) else { return }
//            guard let data = uiimage?.jpegData(compressionQuality: 0.5) else { return }
            if let uiimage = uiimage {
                let data = self.getDataBySize(uiimage: uiimage, byteCount: 1500000, quality: 1)
                handler(data)
            }
        }
    }
    
    private func getDataBySize(uiimage: UIImage, byteCount: Int, quality: CGFloat) -> Data {
        if let data = uiimage.jpegData(compressionQuality: quality) {
            if data.count < byteCount {
                return data
            } else {
                return self.getDataBySize(uiimage: uiimage, byteCount: byteCount, quality: quality - 0.05)
            }
        } else {
            return Data()
        }
    }
    
    private func setProgress(isFinish: Bool, progress: Double, isFirst: Bool, isSecond: Bool) {
        if isFinish {
            if self.isEdit { self.delegate?.updateDream?() }
            self.navigationController?.popViewController(animated: true)
        } else {
            let labelProgress = Int(progress * 100)
            if isFirst && isSecond {
                self.topImageProgressLabel.isHidden = false
                self.bottomImageProgressLabel.isHidden = false
                let doubleProgress = progress * 2
                if doubleProgress >= 1 {
                    let secondProgress = doubleProgress - 1
                    self.topImageProgressLabel.text = "100%"
                    self.topImageProgressViewWidthConstraint.constant = self.squareWidth
                    self.bottomImageProgressLabel.text = "\(Int(secondProgress * 100))%"
                    self.bottomImageProgressViewWidthConstraint.constant = self.squareWidth * CGFloat(secondProgress)
                } else {
                    self.topImageProgressLabel.text = "\(Int(doubleProgress * 100))%"
                    self.topImageProgressViewWidthConstraint.constant = self.squareWidth * CGFloat(doubleProgress)
                    self.bottomImageProgressLabel.text = "0%"
                    self.bottomImageProgressViewWidthConstraint.constant = 0
                }
            } else if isFirst {
                self.topImageProgressLabel.isHidden = false
                self.topImageProgressLabel.text = "\(labelProgress)%"
                self.topImageProgressViewWidthConstraint.constant = self.squareWidth * CGFloat(progress)
            } else if isSecond {
                self.bottomImageProgressLabel.isHidden = false
                self.bottomImageProgressLabel.text = "\(labelProgress)%"
                self.bottomImageProgressViewWidthConstraint.constant = self.squareWidth * CGFloat(progress)
            }
        }
    }

}

extension UploadDreamVC: PhotoGalleryVCDelegate {
    
    func chosenAsset(asset: PHAsset) {
        if self.isFirstImage {
            let (imageSize, uiimage) = PhotoService.instance.getUIImage(asset: asset)
            self.topImageImageView.image = uiimage
            if imageSize != .Original {
                PhotoService.instance.getFullImage(asset: asset) { (image) in
                    self.topImageImageView.image = image
                }
            }
            self.firstAsset = asset
            self.topImageAddImageButton.isHidden = true
            self.topImageImageView.isHidden = false
            self.topImageChangeButtonHeightConstraint.constant = 30
        } else if self.isSecondImage {
            let (imageSize, uiimage) = PhotoService.instance.getUIImage(asset: asset)
            self.bottomImageImageView.image = uiimage
            if imageSize != .Original {
                PhotoService.instance.getFullImage(asset: asset) { (image) in
                    self.bottomImageImageView.image = image
                }
            }
            self.secondAsset = asset
            self.bottomImageAddImageButton.isHidden = true
            self.bottomImageImageView.isHidden = false
            self.bottomImageChangeButtonHeightConstraint.constant = 30
        }
        self.isFirstImage = false
        self.isSecondImage = false
    }
    
}

extension UIViewController {
    
    public func showPrivacySettingAlert(message: String) {
        let alert = UIAlertController(title: "Privacy Access", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    public func showActionSheet(actions: [UIAlertAction], cancelHandler: (() -> ())? = nil) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            cancelHandler?()
        })
        cancelAction.setValue(#colorLiteral(red: 1, green: 0.205890223, blue: 0.06832957851, alpha: 1), forKey: "titleTextColor")
        alert.addAction(cancelAction)
        for action in actions {
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
}

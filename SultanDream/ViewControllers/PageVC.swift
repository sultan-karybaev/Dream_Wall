//
//  ViewController.swift
//  SultanDream
//
//  Created by Sultan Karybaev on 5/10/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import SocketIO

class PageVC: UIViewController {

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var downImageView: UIImageView!
    @IBOutlet weak var mainLabelHeightConstraint: NSLayoutConstraint!
    
    private var topSegmentControl: UISegmentedControl = UISegmentedControl()
    
    private var currentDream: Dream?
    
    private var firstDream: Dream?
    private var secondDream: Dream?
    private var thirdDream: Dream?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLayer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getData()
    }
    
    private func setLayer() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6)
        UIApplication.statusBarUIView?.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6)
        self.topSegmentControl = UISegmentedControl(frame: CGRect(x: 0, y: 0, width: 180, height: 30))
        self.topSegmentControl.insertSegment(withTitle: "1", at: 0, animated: false)
        self.topSegmentControl.insertSegment(withTitle: "2", at: 1, animated: false)
        self.topSegmentControl.insertSegment(withTitle: "3", at: 2, animated: false)
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        self.topSegmentControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        self.topSegmentControl.addTarget(self, action: #selector(self.topSegmentControlValueChanged), for: .valueChanged)
        if #available(iOS 13.0, *) {
            self.topSegmentControl.selectedSegmentTintColor = MAIN_COLOR
        }
        self.topSegmentControl.tintColor = MAIN_COLOR
        self.topSegmentControl.selectedSegmentIndex = 0
        self.navigationController?.navigationBar.topItem?.titleView = self.topSegmentControl
        let moreIcon = UIImage(named: "application")?.downsizeImage(toSize: 20).withRenderingMode(.alwaysTemplate)
        let moreBarItem = UIBarButtonItem(image: moreIcon, style: .plain, target: self, action: #selector(moreWasPressed))
        moreBarItem.tintColor = MAIN_COLOR
        self.navigationItem.rightBarButtonItem = moreBarItem
//        let plusIcon = UIImage(named: "plus")?.downsizeImage(toSize: 20).withRenderingMode(.alwaysTemplate)
//        let plusBarItem = UIBarButtonItem(image: plusIcon, style: .plain, target: self, action: #selector(plusWasPressed))
//        plusBarItem.tintColor = MAIN_COLOR
//        self.navigationItem.rightBarButtonItem = plusBarItem
//        let editIcon = UIImage(named: "edit")?.downsizeImage(toSize: 20).withRenderingMode(.alwaysTemplate)
//        let editBarItem = UIBarButtonItem(image: editIcon, style: .plain, target: self, action: #selector(editWasPressed))
//        editBarItem.tintColor = MAIN_COLOR
//        self.navigationItem.leftBarButtonItem = editBarItem
    }
    
    @objc private func topSegmentControlValueChanged() {
        self.currentDream = nil
        if self.topSegmentControl.selectedSegmentIndex == 0 {
            self.currentDream = self.firstDream
        } else if self.topSegmentControl.selectedSegmentIndex == 1 {
            self.currentDream = self.secondDream
        } else if self.topSegmentControl.selectedSegmentIndex == 2 {
            self.currentDream = self.thirdDream
        }
        self.setData()
    }
    
    private func getData() {
//        self.requestDream()
        var needRequest = false
        let dreams = RealmService.instance.getDreams().sorted { $0.index < $1.index }
        print("PageVC getData dreams \(dreams)")
        if dreams.count != 3 {
            self.setData()
            self.requestDream()
        } else {
            for (i, dream) in dreams.enumerated() {
                let currentDate = Date()
                let dreamDate = dream.currentDate
                if dreamDate.get(.day) != currentDate.get(.day) || dreamDate.get(.month) != currentDate.get(.month) || dreamDate.get(.year) != currentDate.get(.year) {
                    needRequest = true
                }
                if i == 0 { self.firstDream = dream }
                else if i == 1 { self.secondDream = dream }
                else if i == 2 { self.thirdDream = dream }
                if i == self.topSegmentControl.selectedSegmentIndex {
                    self.currentDream = dream
                    self.setData()
                }
            }
            if needRequest { self.requestDream() }
        }
        
        
//        if let dream = RealmService.instance.getDream() {
//            //print("PageVC getData dream \(dream)")
//            self.currentDream = dream
//            self.setData()
//            let currentDate = Date()
//            let dreamDate = dream.currentDate
//            if dreamDate.get(.day) != currentDate.get(.day) || dreamDate.get(.month) != currentDate.get(.month) || dreamDate.get(.year) != currentDate.get(.year) {
//                self.requestDream()
//            }
//        } else {
//            self.requestDream()
//        }
    }
    
    private func setData() {
        print("pagevc setData self.currentDream \(self.currentDream)")
        let images = RealmService.instance.getImages()
        
//        print("PageVC setData \(self.firstDream) \(self.secondDream) \(self.thirdDream)")
//        print("PageVC setData images \(images)")
        self.topImageView.image = nil
        self.downImageView.image = nil
        if let currentDream = self.currentDream {
            //self.navigationController?.navigationBar.topItem?.title = currentDream.topText
            self.setText(text: currentDream.mainText)
            print("PageVC setData firstImage \(RealmService.instance.getImage(id: currentDream.first_fileId))")
            print("PageVC setData secondImage \(RealmService.instance.getImage(id: currentDream.second_fileId))")
            if let firstImage = RealmService.instance.getImage(id: currentDream.first_fileId), let secondImage = RealmService.instance.getImage(id: currentDream.second_fileId) {
                self.setImage(image: firstImage, imageView: self.topImageView, name: "top_image_\(currentDream.index).jpg")
                self.setImage(image: secondImage, imageView: self.downImageView, name: "bottom_image_\(currentDream.index).jpg")
            }
        } else {
            self.setText(text: "You don't have any dreams yet")
        }
    }
    
    private func setImage(image: Image, imageView: UIImageView, name: String) {
        if image.localUrl == "" || !FileService.instance.isImageExist(name: image.localUrl) {
            self.requestImage(image: image, imageView: imageView, name: name)
        } else {
            if let data = FileService.instance.getImageDataFromPhone(filePath: image.localUrl), let uiimage = UIImage(data: data) {
                imageView.image = uiimage
            } else {
                self.requestImage(image: image, imageView: imageView, name: name)
            }
        }
    }
    
    private func requestImage(image: Image, imageView: UIImageView, name: String) {
        print("PageVC requestImage")
        guard let url = URL(string:image.finalUrl) else { return }
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                if let uiimage = UIImage(data: data) {
                    FileService.instance.saveImage(imageData: data, name: name)
                    DispatchQueue.main.async {
                        imageView.image = uiimage
                        RealmService.instance.setImageLocalUrl(id: image.id, localUrl: name)
                    }
                }
            } catch {}
        }
    }
    
    private func requestDream() {
        RESTService.instance.getDreams { [weak self] success, firstDream, secondDream, thirdDream in
            if success {
                //topSegmentControlValueChanged()
                //self?.currentDream = dream
                self?.firstDream = firstDream
                self?.secondDream = secondDream
                self?.thirdDream = thirdDream
                self?.topSegmentControlValueChanged()
                //self?.setData()
            } else {
                guard let loginVC = self?.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC else { return }
                loginVC.modalPresentationStyle = .fullScreen
                RealmService.instance.deleteRealmToken()
                RealmService.instance.deleteDreams()
                RealmService.instance.deleteImages()
                self?.present(loginVC, animated: true, completion: nil)
            }
        }
    }
    
    @objc private func moreWasPressed() {
        guard let optionsVC = self.storyboard?.instantiateViewController(withIdentifier: "OptionsVC") as? OptionsVC else { return }
        self.navigationController?.pushViewController(optionsVC, animated: true)
    }
    
    @objc private func plusWasPressed() {
        guard let uploadDreamVC = self.storyboard?.instantiateViewController(withIdentifier: "UploadDreamVC") as? UploadDreamVC else { return }
        self.navigationController?.pushViewController(uploadDreamVC, animated: true)
    }
    
    @objc private func editWasPressed() {
        guard let uploadDreamVC = self.storyboard?.instantiateViewController(withIdentifier: "UploadDreamVC") as? UploadDreamVC else { return }
        guard let dream = self.currentDream else { return }
        uploadDreamVC.setDream(dream: dream)
        uploadDreamVC.delegate = self
        self.navigationController?.pushViewController(uploadDreamVC, animated: true)
    }
    
    private func setText(text: String) {
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        paragraphStyle.lineSpacing = 10 // Whatever line spacing you want in points
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        self.mainLabel.attributedText = attributedString
        let labelSize = self.mainLabel.textRect(forBounds: CGRect(x: 0, y: 0, width: self.view.frame.width - 60, height: 1000), limitedToNumberOfLines: 1000)
        self.mainLabelHeightConstraint.constant = labelSize.height
    }

}

extension PageVC: UploadDreamVCDelegate {
    
    func updateDream() {
        self.getData()
    }
    
}

extension UIImage {
    
    func downsizeImage(toSize size: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: size, height: size), false, 0)
        self.draw(in: CGRect(x: 0, y: 0, width: size, height: size))
        guard let downsizedImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        return downsizedImage
    }
    
}

extension Date {
//    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
//        return calendar.dateComponents(Set(components), from: self)
//    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}

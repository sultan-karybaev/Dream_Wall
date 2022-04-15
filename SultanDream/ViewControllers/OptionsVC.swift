//
//  OptionsVC.swift
//  SultanDream
//
//  Created by Sultan Karybaev on 09.04.2022.
//

import UIKit

class OptionsVC: UIViewController {

    @IBOutlet weak var uploadNewDreamButton: UIButton!
    @IBOutlet weak var changeDreamButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var aboutDreamWallButton: UIButton!
    @IBOutlet weak var popularIdeasButton: UIButton!
    @IBOutlet weak var changePasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLayer()
    }
    
    private func setLayer() {
        self.uploadNewDreamButton.layer.cornerRadius = 8
        self.changeDreamButton.layer.cornerRadius = 8
        self.profileButton.layer.cornerRadius = 8
        self.aboutDreamWallButton.layer.cornerRadius = 8
        self.popularIdeasButton.layer.cornerRadius = 8
        self.changePasswordButton.layer.cornerRadius = 8
    }
    
    @IBAction func uploadNewDreamButtonWasPressed(_ sender: Any) {
        guard let uploadDreamVC = self.storyboard?.instantiateViewController(withIdentifier: "UploadDreamVC") as? UploadDreamVC else { return }
        self.navigationController?.pushViewController(uploadDreamVC, animated: true)
    }
    
    @IBAction func changeDreamButtonWasPressed(_ sender: Any) {
        guard let uploadDreamVC = self.storyboard?.instantiateViewController(withIdentifier: "UploadDreamVC") as? UploadDreamVC else { return }
        uploadDreamVC.setIsEdit(value: true)
        self.navigationController?.pushViewController(uploadDreamVC, animated: true)
    }
    
    @IBAction func profileButtonWasPressed(_ sender: Any) {
        guard let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC else { return }
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    @IBAction func aboutDreamWallButtonWasPressed(_ sender: Any) {
        guard let aboutVC = self.storyboard?.instantiateViewController(withIdentifier: "AboutVC") as? AboutVC else { return }
        self.navigationController?.pushViewController(aboutVC, animated: true)
    }
    
    @IBAction func popularIdeasButtonWasPressed(_ sender: Any) {
        guard let popularIdeasVC = self.storyboard?.instantiateViewController(withIdentifier: "PopularIdeasVC") as? PopularIdeasVC else { return }
        self.navigationController?.pushViewController(popularIdeasVC, animated: true)
    }
    
    @IBAction func changePasswordButtonWasPressed(_ sender: Any) {
        guard let passwordVC = self.storyboard?.instantiateViewController(withIdentifier: "PasswordVC") as? PasswordVC else { return }
        self.navigationController?.pushViewController(passwordVC, animated: true)
    }
    
}

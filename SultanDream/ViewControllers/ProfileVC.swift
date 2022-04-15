//
//  ProfileVC.swift
//  SultanDream
//
//  Created by Sultan Karybaev on 09.04.2022.
//

import UIKit

class ProfileVC: UIViewController {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var numberOfDreamsLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setEmail()
        self.getNumberOfDreams()
    }
    
    private func setEmail() {
        if let token = RealmService.instance.getToken() {
            self.emailLabel.text = token.email
        }
        self.numberOfDreamsLabel.text = "0"
    }
    
    private func getNumberOfDreams() {
        RESTService.instance.getNumberOfDreams { count in
            self.numberOfDreamsLabel.text = "\(count)"
        }
    }
    
    @IBAction func logoutButtonWasPressed(_ sender: Any) {
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

}

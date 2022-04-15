//
//  PopularIdeasVC.swift
//  SultanDream
//
//  Created by Sultan Karybaev on 09.04.2022.
//

import UIKit

class PopularIdeasVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var ideas: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.getData()
    }
    
    private func getData() {
        RESTService.instance.getIdeas { ideas in
            self.ideas = ideas
            self.tableView.reloadData()
        }
    }

}

extension PopularIdeasVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.ideas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DreamIdeaCell") as? DreamIdeaCell else { return UITableViewCell() }
        let idea = self.ideas[indexPath.row]
        cell.mainLabel.text = idea
        return cell
    }
    
    
}

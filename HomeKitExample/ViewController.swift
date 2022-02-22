//
//  ViewController.swift
//  HomeKitExample
//
//  Created by Neo Nguyen on 22/02/2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tb: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tb.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        // Do any additional setup after loading the view.
        self.onUpdateHomes()
    }
    
    private func onUpdateHomes(){
        VLHomeManager.shared.onUpdateHomes = {[weak self] homes in
            guard let wSelf = self else { return  }
            wSelf.tb.reloadData()
            
            VLHomeManager.shared.searchAccessory()
        }
        
        VLHomeManager.shared.onAddedAccessory = {
            [weak self] (home, access, err) in
            guard let _ = self else { return }
            VLHomeManager.shared.addAccesories(home: home, accessory: access)
        }
    }
    
    @IBAction func onTapSearch(_ sender : Any?){
        VLHomeManager.shared.searchAccessory()
    }
    
    @IBAction func onTapAddManual(_ sender : Any?){
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VLHomeManager.shared.getHomes().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tb.dequeueReusableCell(withIdentifier: "UITableViewCell") else { return UITableViewCell.init() }
        let home = VLHomeManager.shared.getHomes()[indexPath.row]
        cell.textLabel?.text = home.name
        return cell
    }
}


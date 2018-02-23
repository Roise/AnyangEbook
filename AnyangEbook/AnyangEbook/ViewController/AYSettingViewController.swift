//
//  AYSettingViewController.swift
//  AnyangEbook
//
//  Created by N4046 on 2018. 1. 10..
//  Copyright © 2018년 roi. All rights reserved.
//

import UIKit

class AYSettingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.reloadData()
        self.tableView.register(UINib.init(nibName: "AYSettingTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingTableViewCell")
        
        self.navigationController?.navigationItem.title = "설정"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AYSettingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as? AYSettingTableViewCell
        cell?.title.text = "푸쉬알림"
        cell?.switchBUtton.isOn = UserDefaults.standard.bool(forKey: "isPush")
        cell?.selectionStyle = .none        
        return cell!
    }
}

extension AYSettingViewController: AYSettingCellDelegate {
    func switchOnOff(sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "isPush")
    }
}

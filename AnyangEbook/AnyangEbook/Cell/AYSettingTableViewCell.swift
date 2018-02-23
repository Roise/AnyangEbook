//
//  AYSettingTableViewCell.swift
//  AnyangEbook
//
//  Created by N4046 on 2018. 2. 22..
//  Copyright © 2018년 roi. All rights reserved.
//

import UIKit

protocol AYSettingCellDelegate {
    func switchOnOff(sender: UISwitch) -> Swift.Void
}

class AYSettingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var switchBUtton: UISwitch!
    
    public var delegate: AYSettingCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func switching(_ sender: UISwitch) { switchBUtton.isOn = !switchBUtton.isOn
        switchBUtton.setOn(switchBUtton.isOn, animated: true)
        delegate?.switchOnOff(sender: sender)
    }
    
}

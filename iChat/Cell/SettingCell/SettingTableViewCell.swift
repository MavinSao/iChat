//
//  SettingTableViewCell.swift
//  iChat
//
//  Created by Mavin on 9/19/21.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemImage: UIImageView!

    
    func config(item: Setting){
        self.itemImage.image = UIImage(named:item.image)
        self.itemTitle.text = item.title
        self.itemImage.backgroundColor = item.backColor
    }
    
}

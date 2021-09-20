//
//  Setting.swift
//  iChat
//
//  Created by Mavin on 9/20/21.
//

import Foundation
import UIKit

struct Setting {
    var title: String
    var image: String
    var segueIden: String
    var backColor: UIColor
    
    init(title: String, image: String, segueIden: String, backColor: UIColor) {
        self.title = title
        self.image = image
        self.segueIden = segueIden
        self.backColor = backColor
    }
}

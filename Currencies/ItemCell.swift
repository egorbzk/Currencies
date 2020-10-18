//
//  ItemCell.swift
//  Currencies
//
//  Created by Egor Bozko on 10/18/20.
//  Copyright © 2020 Egor Bozko. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    static let ItemCellKey = "ItemCell"
    static let ItemCellNibKey = "ItemCell"
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var controlButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//    }

}

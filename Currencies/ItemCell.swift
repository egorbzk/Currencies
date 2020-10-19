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
   
    public var controlAction: (() -> Void)?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var controlButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func controlButtonPressed(_ sender: Any) {
        controlAction?()
    }
}

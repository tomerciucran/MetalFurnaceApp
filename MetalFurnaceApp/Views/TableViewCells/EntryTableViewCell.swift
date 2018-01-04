//
//  EntryTableViewCell.swift
//  MetalFurnaceApp
//
//  Created by Tomer Ciucran on 03.01.18.
//  Copyright © 2018 Cihan Muradoglu. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "EntryTableViewCell"
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var furnaceNameLabel: UILabel!
    @IBOutlet weak var scrapNameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

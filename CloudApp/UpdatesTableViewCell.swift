//
//  UpdatesTableViewCell.swift
//  CloudApp
//
//  Created by Anusha on 8/17/16.
//  Copyright © 2016 Anusha. All rights reserved.
//

import UIKit

class UpdatesTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var linkLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

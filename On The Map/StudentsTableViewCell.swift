//
//  StudentsTableViewCell.swift
//  On The Map
//
//  Created by Sören Kirchner on 15.09.17.
//  Copyright © 2017 Sören Kirchner. All rights reserved.
//

import UIKit

class StudentsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

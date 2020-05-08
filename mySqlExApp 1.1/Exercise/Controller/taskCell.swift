//
//  taskCell.swift
//  mySqlExApp2
//
//  Created by DenisMacOS on 13/11/2019.
//  Copyright © 2019 imac. All rights reserved.
//

import UIKit

class taskCell: UITableViewCell {

    @IBOutlet weak var taskTextOutlet: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

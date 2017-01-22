//
//  CoverTableViewCell.swift
//  NAS-T
//
//  Created by Axel on 30/11/16.
//  Copyright © 2016 Axel. All rights reserved.
//

import UIKit

class CoverTableViewCell: UITableViewCell {

    // MARK: Properties
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

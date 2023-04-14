//
//  SearchTableViewCell.swift
//
//  Created by Andrew Li on 4/8/20.
//  Copyright © 2020 Andrew Li. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    //outlets
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var urlLink: WebButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

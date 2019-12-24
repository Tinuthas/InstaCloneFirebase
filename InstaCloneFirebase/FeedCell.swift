//
//  FeedCell.swift
//  InstaCloneFirebase
//
//  Created by Marcus Vinicius Galdino Medeiros on 24/12/19.
//  Copyright © 2019 Marcus Vinicius Galdino Medeiros. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {

    @IBOutlet weak var useremailLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func likeClicked(_ sender: Any) {
        print("like button clicked")
    }
    
}

//
//  FeedCell.swift
//  InstaCloneFirebase
//
//  Created by Marcus Vinicius Galdino Medeiros on 24/12/19.
//  Copyright © 2019 Marcus Vinicius Galdino Medeiros. All rights reserved.
//

import UIKit
import Firebase
import OneSignal

class FeedCell: UITableViewCell {

    @IBOutlet weak var useremailLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var documentIDLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func likeClicked(_ sender: Any) {
        //print("like button clicked")
        //print(documentIDLabel.text)
        let fireStoreDatabase = Firestore.firestore()
        if let likeCount = Int(likeLabel.text!) {
            let likeStore = ["likes": likeCount + 1] as [String:Any]
            fireStoreDatabase.collection("Posts").document(documentIDLabel.text!).setData(likeStore, merge: true)
        }
        
        let userEmail = useremailLabel.text!
        
        fireStoreDatabase.collection("playerId").whereField("email", isEqualTo: userEmail).getDocuments { (snapshot, error) in
            if error == nil {
                if snapshot?.isEmpty == false && snapshot != nil {
                    for document in snapshot!.documents {
                        if let playedID = document.get("player_id") as? String{
                            OneSignal.postNotification(["contents":["en":"\(Auth.auth().currentUser!.email) liked your post"], "include-player-ids": ["\(playedID)"]])
                        }
                    }
                }
            }
        }
        
     
        
        
       
    }
    
}

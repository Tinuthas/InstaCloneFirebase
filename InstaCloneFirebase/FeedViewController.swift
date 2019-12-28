//
//  FeedViewController.swift
//  InstaCloneFirebase
//
//  Created by Marcus Vinicius Galdino Medeiros on 22/12/19.
//  Copyright © 2019 Marcus Vinicius Galdino Medeiros. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import OneSignal

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var feedArray = [FeedModel]()
    @IBOutlet weak var tableView: UITableView!
    let fireStoreDatabase = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        getDataFromFirebase()
        //SEND MANUAL NOTIFICATION TO PLAYED ID
        //OneSignal.postNotification(["contents":["en":"Test Message"], "include-player-ids": ["23452-32323232-32323-232323-23233232"]])
        
        let status : OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
        
        let playerId = status.subscriptionStatus.userId
        
        if let playerNewId = playerId {
            fireStoreDatabase.collection("PlayerId").whereField("email", isEqualTo: Auth.auth().currentUser!.email).getDocuments { (snapshot, error) in
                if error == nil {
                    if snapshot?.isEmpty == false && snapshot != nil {
                        for document in snapshot!.documents {
                            if let playerIdFromFirebase = document.get("player_id") as? String {
                                print("playerIDFromFirebase: " + playerIdFromFirebase)
                                let documentID = document.documentID
                                 if playerNewId != playerIdFromFirebase {
                                    self.createPlayerID(playerNewId: playerNewId)
                                }
                                
                               
                            }
                        }
                    }else {
                        self.createPlayerID(playerNewId: playerNewId)
                    }
                }
            }
            
            //print("played ID : " + playerNewId)
            
            
        }
        
        
    }
    
    func createPlayerID(playerNewId: String){
        let playerIdDictionary = ["email": Auth.auth().currentUser!.email, "player_id":playerNewId]
              fireStoreDatabase.collection("PlayerId").addDocument(data: playerIdDictionary,completion: {(error) in
              if error != nil {
                    print(error?.localizedDescription ?? "Error")
              }
         })
    }
    
    func getDataFromFirebase() {
        /*let settings = fireStoreDatabase.settings
        settings.areTimestampsInSnapshotsEnabled = true
        fireStoreDatabase.settings = settings*/
        fireStoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription ?? "Error Database")
            }else {
                if snapshot != nil && snapshot?.isEmpty != true {
                    self.feedArray = [FeedModel]()
                    for document in snapshot!.documents {
                        let documentID = document.documentID
                        //print(documentID)
                        if let postedBy = document.get("postedBy") as? String{
                            if let postComment = document.get("postComment") as? String {
                                if let likes = document.get("likes") as? Int {
                                    if let imageUrl = document.get("imageUrl") as? String {
                                         if let date = document.get("date") as? String {
                                            self.feedArray.append(FeedModel(id: documentID, date: date , imageUrl: imageUrl, likes: likes, postComment: postComment, postedBy: postedBy))
                                         }else if let date = document.get("date") as? Timestamp {
                                            self.feedArray.append(FeedModel(id: documentID, date: "\(date.dateValue())" , imageUrl: imageUrl, likes: likes, postComment: postComment, postedBy: postedBy))
                                        }
                                    }
                                }
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(feedArray.count)
        return feedArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        let feedModel = feedArray[indexPath.row]
        cell.useremailLabel.text = feedModel.postedBy
        cell.likeLabel.text = String(feedModel.likes)
        cell.commentLabel.text = feedModel.postComment
        cell.documentIDLabel.text = feedModel.id
        cell.userImageView.sd_setImage(with: URL(string: feedModel.imageUrl))
        return cell
    }

}

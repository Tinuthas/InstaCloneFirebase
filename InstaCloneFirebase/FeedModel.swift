//
//  FeedModel.swift
//  InstaCloneFirebase
//
//  Created by Marcus Vinicius Galdino Medeiros on 24/12/19.
//  Copyright © 2019 Marcus Vinicius Galdino Medeiros. All rights reserved.
//

import Foundation

class FeedModel{
    var id: String
    var date : String
    var imageUrl: String
    var likes: Int
    var postComment: String
    var postedBy: String
    
    init(id: String, date: String, imageUrl: String, likes: Int, postComment: String, postedBy: String) {
        self.id = id
        self.date = date
        self.imageUrl = imageUrl
        self.likes = likes
        self.postComment = postComment
        self.postedBy = postedBy
    }
}

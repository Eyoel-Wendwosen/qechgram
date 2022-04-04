//
//  PostProfileCollectionViewController.swift
//  Qechgram
//
//  Created by Eyoel Wendwosen on 4/3/22.
//

import UIKit
import Parse

class PostCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var postImageView: UIImageView!
    
    var post: PFObject!
    
    func configure(post: PFObject) {
        let imageData = post["image"] as! PFFileObject
        let imageUrl = imageData.url!
        let url = URL(string: imageUrl)!
        postImageView.af_setImage(withURL: url)
    }
}

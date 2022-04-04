//
//  PostCell.swift
//  Qechgram
//
//  Created by Eyoel Wendwosen on 3/25/22.
//

import UIKit
import Parse

class PostCell: UITableViewCell {
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var profileImageview: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageview.layer.borderWidth = 1
        profileImageview.layer.masksToBounds = false
        profileImageview.layer.borderColor = UIColor.white.cgColor
        profileImageview.layer.cornerRadius = profileImageview.frame.size.height / 2
        profileImageview.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(post: PFObject) {
        let user = post["owner"] as! PFUser
        usernameLabel.text = user.username
        captionLabel.text = post["caption"] as? String
        
        if (user["profile_image"] != nil) {
            let imageData = user["profile_image"] as! PFFileObject
            let imageUrl = imageData.url!
            let url = URL(string: imageUrl)!
            profileImageview.af_setImage(withURL: url)
        }
        
        let imageData = post["image"] as! PFFileObject
        let imageUrl = imageData.url!
        let url = URL(string: imageUrl)!
        photoView.af_setImage(withURL: url)
    }

}

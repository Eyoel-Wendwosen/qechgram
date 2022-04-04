//
//  CommentCell.swift
//  Qechgram
//
//  Created by Eyoel Wendwosen on 4/3/22.
//

import UIKit
import Parse

class CommentCell: UITableViewCell {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2
        profileImageView.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(comment: PFObject){
        
        let author = comment["author"] as! PFUser
        usernameLabel.text = author.username
        commentLabel.text = comment["text"] as? String
        
        if (author["profile_image"] != nil) {
            let imageData = author["profile_image"] as! PFFileObject
            let imageUrl = imageData.url!
            let url = URL(string: imageUrl)!
            profileImageView.af_setImage(withURL: url)

        }
    }
    

}

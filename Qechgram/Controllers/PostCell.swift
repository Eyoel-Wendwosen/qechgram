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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(post: PFObject) {
        let user = post["owner"] as! PFUser
        usernameLabel.text = user.username
        captionLabel.text = post["caption"] as! String
        
        let imageData = post["image"] as! PFFileObject
        let imageUrl = imageData.url!
        let url = URL(string: imageUrl)!
        photoView.af_setImage(withURL: url)
    }

}

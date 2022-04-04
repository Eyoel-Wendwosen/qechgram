//
//  ProfilePageViewController.swift
//  Qechgram
//
//  Created by Eyoel Wendwosen on 4/3/22.
//

import UIKit
import Parse

class ProfilePageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernameLightLabel: UILabel!
    @IBOutlet weak var postCollectionView: UICollectionView!

    var posts = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postCollectionView.delegate = self
        postCollectionView.dataSource = self
        
//        layoutCollectionViewCells()
        setUpProfileView()
        fetchPosts()
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = postCollectionView.dequeueReusableCell(withReuseIdentifier: "PostCollectionViewCell", for: indexPath) as! PostCollectionViewCell
        
        let post = posts[indexPath.item]
        cell.configure(post: post)
        
        return cell
    }
    
    func layoutCollectionViewCells() {
        let layout = postCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        let width = (view.frame.size.width - layout.minimumInteritemSpacing * 2) / 3

        layout.itemSize = CGSize(width: width, height: width)
    }
    
    func setUpProfileView() {
        let user = PFUser.current()
        
        usernameLabel.text = PFUser.current()?.username
        usernameLightLabel.text = PFUser.current()?.username
        
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height  / 2
        profileImageView.clipsToBounds = true
    
        if user?["profile_image"] != nil {
            let imageData = user!["profile_image"] as! PFFileObject
            let imageUrl = imageData.url!
            let url = URL(string: imageUrl)!
            profileImageView.af.setImage(withURL: url)
        }
        
    }
    
    @IBAction func onImageButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let user = PFUser.current()!
      
        let image = info[.editedImage] as! UIImage

        let imageData = PFFileObject(data: image.pngData()!)
        user.setObject(imageData, forKey: "profile_image")
        user.saveInBackground { success, error in
            if(success) {
                let size = CGSize(width: 150, height: 150)
                let scaledImage = image.af.imageAspectScaled(toFill: size, scale: 1)
                self.profileImageView.image = scaledImage
                picker.dismiss(animated: true, completion: nil)
            } else {
                picker.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func fetchPosts() {
        let query = PFQuery(className: "Posts")
        query.whereKey("owner", equalTo: PFUser.current())
        query.findObjectsInBackground { posts, error in
            if(posts != nil) {
                self.posts = posts!
                self.postCollectionView.reloadData()
            } else {
                print("Erorr occured in fetching posts")
            }
        }
        
    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

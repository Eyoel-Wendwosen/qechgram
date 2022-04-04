//
//  FeedViewController.swift
//  Qechgram
//
//  Created by Eyoel Wendwosen on 3/25/22.
//

import UIKit
import Parse
import AlamofireImage
import MessageInputBar

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MessageInputBarDelegate {


    @IBOutlet weak var postTable: UITableView!
    var commentBar = MessageInputBar()
    let postRefreshController = UIRefreshControl()
    
    var posts = [PFObject]()
    var selectedPost: PFObject!
    var showsCommentBar = false

    override func viewDidLoad() {
        super.viewDidLoad()

        postTable.delegate = self
        postTable.dataSource = self
        commentBar.delegate = self
        
        commentBar.inputTextView.placeholder = "Add a comment..."
        commentBar.sendButton.title = "Post"
        
        postTable.reloadData()
        postRefreshController.addTarget(self, action: #selector(loadPosts), for: .valueChanged)
        postTable.refreshControl = postRefreshController
        postTable.keyboardDismissMode = .interactive
        
        // add notification center listner
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillBeHidden(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadPosts()
        
    }
    
    @objc func keyboardWillBeHidden(note: Notification) {
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
    }
    
    override var inputAccessoryView: UIView? {
        return commentBar
    }
    
    override var canBecomeFirstResponder: Bool {
        return showsCommentBar
    }
 
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        // create the commnet and post
        let comment = PFObject(className: "Comment")
        comment["text"] = text
        comment["author"] = PFUser.current()
        
        selectedPost.add(comment, forKey: "comment")
        selectedPost.saveInBackground(block: { success, error in
            if (success) {
                print("Commnet saved!")
            } else {
                print("Error saving comment!")
            }
        })
        postTable.reloadData()
        
        // clear and dismiss the keybaord
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let post = posts[indexPath.section]
        let comments = (post["comment"] as? [PFObject]) ?? []
        if (indexPath.row == comments.count + 1) {
            showsCommentBar = true
            becomeFirstResponder()
            selectedPost = post
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let post = posts[section]
        let comments = (post["comment"] as? [PFObject]) ?? []
        return comments.count + 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.section]
        let comments = (post["comment"] as? [PFObject]) ?? []
        
        if(indexPath.row == 0) {
            let cell = postTable.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
            
            cell.configure(post: post)
            return cell
        } else if (indexPath.row <= comments.count){
            let cell = postTable.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
            let comment = comments[indexPath.row - 1]
            cell.configure(comment: comment)
            return cell
        } else {
            let cell = postTable.dequeueReusableCell(withIdentifier: "NewCommentCell")!
            return cell
        }
       
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section + 1 == posts.count {
            loadMorePosts()
        }
    }
    
    @IBAction func onLogout(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("logout"), object: nil)
    }
    
    @objc func loadPosts() {
        let query = PFQuery(className: "Posts")
        query.includeKeys(["owner", "comment", "comment.author"])
        query.addDescendingOrder("createdAt")
        query.limit = 4
        
        query.findObjectsInBackground { posts, error in
            if(posts != nil) {
                self.posts = posts!
                self.postTable.reloadData()
                self.postRefreshController.endRefreshing()
            }
        }
    }
    
    func loadMorePosts() {
        let query = PFQuery(className: "Posts")
        query.includeKeys(["owner", "comment", "comment.author"])
        query.addDescendingOrder("createdAt")
        query.skip = posts.count
        query.limit = 4
        
        query.findObjectsInBackground { posts, error in
            if(posts != nil) {
                for post in posts! {
                    self.posts.append(post)
                }
                self.postTable.reloadData()
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

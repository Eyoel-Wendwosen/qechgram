//
//  FeedViewController.swift
//  Qechgram
//
//  Created by Eyoel Wendwosen on 3/25/22.
//

import UIKit
import Parse
import AlamofireImage

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    @IBOutlet weak var postTable: UITableView!
    
    var posts = [PFObject]()
    
    let postRefreshController = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        postTable.delegate = self
        postTable.dataSource = self
        postTable.reloadData()
        postRefreshController.addTarget(self, action: #selector(loadPosts), for: .valueChanged)
        postTable.refreshControl = postRefreshController
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadPosts()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = postTable.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        
        let post = posts[indexPath.row]
        cell.configure(post: post)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == posts.count {
            loadMorePosts()
        }
    }
    
    @IBAction func onLogout(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("logout"), object: nil)
    }
    
    @objc func loadPosts() {
        let query = PFQuery(className: "Posts")
        query.includeKey("owner")
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
        query.includeKey("owner")
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

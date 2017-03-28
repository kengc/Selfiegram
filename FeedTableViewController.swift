//
//  FeedTableViewController.swift
//  Selfiegram
//
//  Created by Kevin Cleathero on 2017-03-06.
//  Copyright © 2017 Kevin Cleathero. All rights reserved.
//

import UIKit
import Parse

class FeedTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var words = ["Hello", "my", "name", "is", "Selfiegram"]
    var posts = [Post]()
    var selectedRowIndex:Int?  // had to add ? because we didn't assign a default value. can be int or nil could be = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPosts (block: {})
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.posts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! SelfieCell
        
        
        //original
        let post = self.posts[indexPath.row]
        
        
        //set the cell’s post property to the post for that indexPath
        cell.post = post
        
        
        cell.usernameLabel.text = post.user.username
        cell.commentLabel.text = post.comment
        
        
        return cell
    }
    
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        
        // 1: Create an ImagePickerController
        let pickerController = UIImagePickerController()
        
        // 2: Self in this line refers to this View Controller
        //    Setting the Delegate Property means you want to receive a message
        //    from pickerController when a specific event is triggered.
        pickerController.delegate = self
        
        if TARGET_OS_SIMULATOR == 1 {
            // 3. We check if we are running on a Simulator
            //    If so, we pick a photo from the simulator’s Photo Library
            // We need to do this because the simulator does not have a camera
            pickerController.sourceType = .photoLibrary
        } else {
            // 4. We check if we are running on an iPhone or iPad (ie: not a simulator)
            //    If so, we open up the pickerController's Camera (Front Camera, for selfies!)
            pickerController.sourceType = .camera
            pickerController.cameraDevice = .front
            pickerController.cameraCaptureMode = .photo
        }
        
        // Preset the pickerController on screen
        self.present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            // setting the compression quality to 90%
            if let imageData = UIImageJPEGRepresentation(image, 0.9),
                let imageFile = PFFile(data: imageData),
                let user = PFUser.current(){
                
                //2. We create a Post object from the image
                let post = Post(image: imageFile, user: user, comment: "A Selfie")
                
                post.saveInBackground(block: { (success, error) -> Void in
                    if success {
                        print("Post successfully saved in Parse")
                        
                        //3. Add post to our posts array, chose index 0 so that it will be added
                        //   to the top of your table instead of at the bottom (default behaviour)
                        self.posts.insert(post, at: 0)
                        
                        //4. Now that we have added a post, updating our table
                        //   We are just inserting our new Post instead of reloading our whole tableView
                        //   Both method would work, however, this gives us a cool animation for free
                        
                        let indexPath = IndexPath(row: 0, section: 0)
                        self.tableView.insertRows(at: [indexPath], with: .automatic)
                    }
                })
            }
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func getPosts(block: @escaping (Void)->Void) {
        
        if let query = Post.query() {
            
            query.order(byDescending: "createdAt")
            query.includeKey("user")
            
            query.findObjectsInBackground(block: { (posts, error) -> Void in
                // this block of code will run when the query is complete
                if let posts = posts as? [Post] {
                    
                    self.posts = posts
                    self.tableView.reloadData()
                    
                } else {
                    print("\(error)")
                }
                block() //if statment or not want this executed needed escaping
            })
        } else {
            block() //code from pullrefresh
        }
    }
    
    
    
    @IBAction func doubleTappedSelfie(_ sender: UITapGestureRecognizer) {
        print("double tapped selfie")
        
        // get the location (x,y) position on our tableView where we have clicked
        let tapLocation = sender.location(in: tableView)
        
        // based on the x, y position we can get the indexPath for where we are at
        if let indexPathAtTapLocation = tableView.indexPathForRow(at: tapLocation){
            
            // based on the indexPath we can get the specific cell that is being tapped
            let cell = tableView.cellForRow(at: indexPathAtTapLocation) as! SelfieCell
            
            //run a method on that cell
            cell.tapAnimation()
            
            
        }
        
    }
    
    @IBAction func refreshPulled(_ sender: UIRefreshControl) {
        //self.tableView.reloadData()
        getPosts { () in
            sender.endRefreshing()  //if was any beign past then need to cast it ti
        }
        //getPosts()
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        //print("the user tapped on a row \(indexPath)")
        selectedRowIndex = indexPath.row
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        
        //do checks here for your ingages or someone elses return trie or false
        return true
    }
    
    
    
    // Override to support editing the table view.
    //we've overridden this by placing our camera icon on the top right, otherwise it would show there
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //Delete the row from the data source
            //use the objectID to determine which object the user wants to delete
            
            print("\(indexPath)")
            
            
            let post = posts[indexPath.row]
            let user = PFUser.current()
            print("Post ID: \(post.objectId)")
            print("User ID: \(user?.objectId)")
            
            //#1 delete from parse in cloud
            post.deleteInBackground(block: { (success, error) in
                
                //if successfull deleting from parse then delete locally
                if success {
                    //tableView.deleteRows(at: indexPath, with: UITableViewRowAnimation)
                    
                    //#2 delete from mirrired array (mirrored to parse)
                    self.posts.remove(at: indexPath.row)
                    
                    //#3 now remove from table. it wants an array but we can be explicit
                    
                    //indexpath here want row and section
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    //refresh is automatic with the above call?
                    
                    ////////past post object to isolated method
                    // but also check to ensure that the user that is deleting the post
                    //is the owner of the photo, if not do not allow delete HUD message
                    //PFQuery to find the like activity
                    if let activityQuery = Activity.query(){
                        activityQuery.whereKey("post", equalTo: post)
                        activityQuery.whereKey("user", equalTo: user!)
                        activityQuery.whereKey("type", equalTo: "like")
                        activityQuery.findObjectsInBackground(block: { (activities, error) -> Void in
                            
                            
                            // You should only have one like activity from a user
                            // but this is code is being safe and checking for one or multiple instances
                            // and then deleting all of them
                            if let activities = activities {
                                for activity in activities {
                                    activity.deleteInBackground(block: { (success, error) -> Void in
                                        print("deleted activity")
                                    })
                                }
                            }
                        })
                    }
                    
                }
            })
            
        } else if editingStyle == .insert {
            //Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

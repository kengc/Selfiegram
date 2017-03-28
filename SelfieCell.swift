//
//  SelfieCellTableViewCell.swift
//  Selfiegram
//
//  Created by Kevin Cleathero on 2017-03-07.
//  Copyright © 2017 Kevin Cleathero. All rights reserved.
//

import UIKit
import Parse

class SelfieCell: UITableViewCell {
    
    //first add a post object to our cell
    //  var post:Post?
    
    @IBOutlet weak var selfieImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var heartAnimationView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //creating another property. this is like a set property method
    //selfiecell.post = sfdf   didset will getfired
    var post:Post? {
        
        // didSet is run when we set this variable in FeedViewController
        //if it gets set to somthing execute the code below set the vars below, otherwise skip it
        //didset is trigger when a post object (whether legit or nil) has been assigned
        didSet{
            
            if let post = post {
                
                selfieImageView.image = nil
                
                let imageFile = post.image
                
                
                imageFile.getDataInBackground { (data, error) in
                    
                    //two ways of doing this
                    //            if error == nil {
                    //                print("error fetching imagefile data")
                    //                return
                    //            } else {
                    //
                    //            }
                    
                    //OR
                    if let data = data {
                        let image = UIImage(data: data)
                        self.selfieImageView.image = image
                    }
                }
                
                usernameLabel.text = post.user.username
                commentLabel.text = post.comment
                
                // set the likeButton defaulted to false
                likeButton.isSelected = false
                
                // query the likes property on post
                let query = post.likes.query()
                query.findObjectsInBackground(block: { (users, error) -> Void in
                    
                    if let users = users as? [PFUser]{
                        for user in users {
                            // If we find that the current user's objectId in our collection
                            // of likes we set the likeButton to selected
                            // objectId is a great way to compare if two objects are equal
                            if user.objectId == PFUser.current()?.objectId {
                                self.likeButton.isSelected = true
                            }
                        }
                    }
                })
            }
        }
    }
    
    //IBAction allows the method to be visible in the storyboard (drag n drop stuff)
    @IBAction func likeButtonClicked(_ sender: UIButton) {
        
        // the ! symbol means NOT
        // We are therefore setting the button's selected state to
        // the opposite of what it was. This is a great way to toggle buttons
        //
        sender.isSelected = !sender.isSelected
        
        // Get rid of Optionals
        if let post = post,
            let user = PFUser.current() {
            
            // like button has been selected and we should add a like from currentUser
            if sender.isSelected {
                
                // PFRelation has a useful method called addObject that adds the unique element
                // you are passing in as the argument. It will never add multiple copies
                // of the same element (in this case user)
                //sets the relation between the post and the user and how `didSet` queries for that information.
                post.likes.add(user)
                
                // We have modified the likes property on post. We must now save it to Parse
                post.saveInBackground(block: { (success, error) -> Void in
                    if success {
                        print("like from user successfully saved")
                        
                        // Creating an row in the Activity table
                        // Saving it as a "like" type
                        let activity = Activity(type: "like", post: post, user: user)
                        activity.saveInBackground(block: { (success, error) -> Void in
                            print("activity successfully saved")
                        })
                    }else{
                        print("error is \(error)")
                    }
                })
            } else {
                
                //post.deleteInBackground(block: { (success, error) in
                
                //#2 delete from mirrored array (mirrored to parse)
                post.likes.remove(user)
                
                //at this point i am pasing the changes back to parse and parse is making the
                //changes to the table, hence we are SAVING whatever changes i did to the post
                //object
                post.saveInBackground(block: { (success, error) -> Void in
                    if success {
                        //PFQuery to find the like activity
                        if let activityQuery = Activity.query(){
                            activityQuery.whereKey("post", equalTo: post)
                            activityQuery.whereKey("user", equalTo: user)
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
                        print("like from user successfully removed")
                    }else{
                        print("error is \(error)")
                    }
                })
            }
        }
    }
    
    
    func tapAnimation(){
        
        //checking for nil in my objects first then...
        if let postUser = post?.user,
            let currentUser = PFUser.current() {
            
            //then we check if the users are the same
            if postUser.objectId == currentUser.objectId {
                
                //Done: Check if the post is already liked, if it is then do not run animation code
                if likeButton.isSelected != true
                {
                    self.heartAnimationView.transform = CGAffineTransform(scaleX: 0, y: 0)
                    self.heartAnimationView.isHidden = false
                    
                    
                    //animation for 1 second, no delay
                    UIView.animate(withDuration: 1.0, delay: 0, options: [], animations: { () -> Void in
                        
                        // during our animation change heartAnimationView to be 3X what it is on storyboard
                        self.heartAnimationView.transform = CGAffineTransform(scaleX: 3, y: 3)
                        
                    }) { (success) -> Void in
                        
                        // when animation is complete set heartAnimationView to be hidden
                        self.heartAnimationView.isHidden = true
                    }
                    
                    likeButtonClicked(likeButton)
                }
            }
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

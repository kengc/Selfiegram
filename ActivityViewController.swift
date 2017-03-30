//
//  ActivityViewController.swift
//  Selfiegram
//
//  Created by Kevin Cleathero on 2017-03-27.
//  Copyright © 2017 Kevin Cleathero. All rights reserved.
//

import UIKit

class ActivityViewController: UITableViewController {
   
    //type:String, post:Post, user:PFUser
    var activities = [Activity]()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.titleView = UIImageView(image: UIImage(named: "Selfigram-logo"))
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return activities.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//       1) Get a cell from the reuse pool.
        let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath)
        
//       2) Get the right Activity out of our activities array using the indexPath.
        
        let activity = activities[indexPath.row]
        
        //explain what is happening in english. if username isn't null then do the rest or is ther 
        //an and?
        //two condition test for ensuring that it is not nil, if BOTH conditions not nil
        //then proceed
        if let liker = activity.user.username,
            let userBeingLiked = activity.post.user.username {
            cell.textLabel?.text = "♥️" + " \(liker) liked \(userBeingLiked)'s photo"
        }
        
       
//       4) Return the cell, back to the table view so it can display it.
        return cell
    }
 
    override func viewDidAppear(_ animated: Bool) {

        if let query = Activity.query() {
            
            query.order(byDescending: "createdAt")
            query.includeKey("user")
            query.includeKey("post.user")
            
            query.findObjectsInBackground(block: { (activities, error) -> Void in
                // this block of code will run when the query is complete
                if let activities = activities as? [Activity] {
                    
                    self.activities = activities
                    self.tableView.reloadData()
                    
                }
            })
        
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

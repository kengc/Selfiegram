//
//  FeedTableViewController.swift
//  Selfiegram
//
//  Created by Kevin Cleathero on 2017-03-06.
//  Copyright © 2017 Kevin Cleathero. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController {
    
    var words = ["Hello", "my", "name", "is", "Selfiegram"]
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let me = User(uname: "Kevin", pimage: UIImage(named: "Grumpy-Cat")!)
        
        let post0 = Post(uimage: UIImage(named: "Grumpy-Cat")!, puser: me, pcomment: "Grumpy cat 0")
        let post1 = Post(uimage: UIImage(named: "Grumpy-Cat")!, puser: me, pcomment: "Grumpy cat 1")
        let post2 = Post(uimage: UIImage(named: "Grumpy-Cat")!, puser: me, pcomment: "Grumpy cat 2")
        let post3 = Post(uimage: UIImage(named: "Grumpy-Cat")!, puser: me, pcomment: "Grumpy cat 3")
        let post4 = Post(uimage: UIImage(named: "Grumpy-Cat")!, puser: me, pcomment: "Grumpy cat 4")
        
        posts = [post0, post1, post2, post3, post4]
        
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
        return 5
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        //this connects back to the object cell using the identifier "postCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        
        let post = posts[indexPath.row]
        cell.imageView?.image = post.image
        

        //cell.textLabel?.text = "This is a post \(indexPath.row)" //old step 2
        //cell.textLabel?.text = words[indexPath.row]   //old step 3
        cell.textLabel?.text = post.comment  //step 4
        
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
         print("the user tapped on a row \(indexPath)")
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

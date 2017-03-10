//
//  FeedTableViewController.swift
//  Selfiegram
//
//  Created by Kevin Cleathero on 2017-03-06.
//  Copyright © 2017 Kevin Cleathero. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var words = ["Hello", "my", "name", "is", "Selfiegram"]
    var posts = [Post]()
    var selectedRowIndex:Int?  // had to add ? because we didn't assign a default value. can be int or nil could be = 0
    
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
        //return 5
        return posts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        //this connects back to the object cell using the identifier "postCell"
        //let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! SelfieCell
        //cast type to a sefliviewcell
         
        let post = posts[indexPath.row]
        
        //cell.imageView?.image = post.image
        cell.selfieImageView.image = post.image
        
        cell.usernameLabel?.text = post.user.userName
        
        
        //cell.textLabel?.text = "This is a post \(indexPath.row)" //old step 2
        //cell.textLabel?.text = words[indexPath.row]   //old step 3
        //cell.textLabel?.text = post.comment  //step 4
        cell.commentLabel?.text = post.comment
       

        
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
        
        // 1. When the delegate method is returned, it passes along a dictionary called info.
        //    This dictionary contains multiple things that maybe useful to us.
        //    We are getting an image from the UIImagePickerControllerOriginalImage key in that dictionary
        //  the ? means if TRY this and if, after unpacking into a UIImage, there is a UIImage then
        // display the image, else if there isnt a UIImage then ignore this fuction
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            //2. To our imageView, we set the image property to be the image the user has chosen
            //profileImageView.image = image
            //2. We create a Post object from the image
            let me = User(uname: "sam", pimage: UIImage(named: "Grumpy-Cat")!)
            let post = Post(uimage: image, puser: me, pcomment: "My Selfie")
            
            //3. Add post to our posts array
            //    Adds it to the very top of our array
            
            if let indexRow = selectedRowIndex {
//                posts.remove(at: indexRow)
//                posts.insert(post, at: indexRow)
            posts[indexRow] = post  //short form of the above 2 lines
            }
        
        }
        
        //4. We remember to dismiss the Image Picker from our screen.
        dismiss(animated: true, completion: nil)
        
        //5. Now that we have added a post, reload our table
        tableView.reloadData()
        
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
         //print("the user tapped on a row \(indexPath)")
        selectedRowIndex = indexPath.row
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

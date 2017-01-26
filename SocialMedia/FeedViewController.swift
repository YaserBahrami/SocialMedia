//
//  FeedViewController.swift
//  SocialMedia
//
//  Created by yaser on 10/20/16.
//  Copyright © 2016 yaserBahrami. All rights reserved.
//

import UIKit
import Firebase
import Alamofire


class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var posts = [Post]()
    var imageSelected = false
    static var imageCache = NSCache<AnyObject, AnyObject>()
    
    @IBOutlet weak var imageSelector: UIImageView!
    @IBOutlet weak var PostTexField: MaterialTextField!
    @IBOutlet weak var postButton: MaterialButton!
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FeedViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 381
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        DataService.ds.REF_POSTS.observe(.value, with: { snapshot in
            self.posts = []
            if let snapshots = snapshot?.children.allObjects as? [FDataSnapshot] {
                
                for snap in snapshots{
                    if let postDict = snap.value as? Dictionary<String, AnyObject>{
                        let key = snap.key
                        let post = Post(postKey: key!, dictionary: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.posts.reverse()
            self.tableView.reloadData()
        })
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell{
            
            cell.request?.cancel()
            
            var img: UIImage?
            if let url = post.imageUrl{
                img = FeedViewController.imageCache.object(forKey: url as AnyObject) as? UIImage
            }
            cell.configureCell(post: post, img: img)
            
            return cell
        }else{
            return PostCell()
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let post = posts[indexPath.row]
        
        if post.imageUrl == "" || post.imageUrl == nil {
            return tableView.estimatedRowHeight - 150
        }else{
            return tableView.estimatedRowHeight
        }
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        imageSelector.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageSelected  = true
        
    }
    
    @IBAction func selectImage(_ sender: UITapGestureRecognizer) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func makePost(_ sender: AnyObject) {
        postButton.isEnabled = false
        PostTexField.isEnabled = false
        
        if let text = PostTexField.text, text != ""{
            
            if let img = imageSelector.image, imageSelected == true {
                let urlString = DataService.ds.ImageShack_API_URL
                
                //Compress
                let imgData = UIImageJPEGRepresentation(img, 0.2)
                let apiKey = DataService.ds.ImageShack_API_KEY.data(using: String.Encoding.utf8)!
                let keyJSON = "json".data(using: String.Encoding.utf8)!
                
                //upload to ImageShack API
                
                Alamofire.upload(multipartFormData: { multipartFormData in
                    multipartFormData.append(imgData!, withName: "fileupload", fileName: "image", mimeType: "image/jpg")
                    multipartFormData.append(apiKey, withName: "key")
                    multipartFormData.append(keyJSON, withName: "format")
                    }, to: urlString, encodingCompletion: { encodingResult in
                        switch encodingResult{
                        case .success(let upload, _, _):
                            upload.responseJSON(completionHandler: {response in
                                if let info = response.result.value as? Dictionary<String,AnyObject> {
                                    if let links = info["links"] as? Dictionary<String,AnyObject>{
                                        if let imageLink = links["image_link"] as? String{
                                            print("Link: \(imageLink)")
                                            
                                            self.postToFirebase(imageLink)
                                        }
                                    }
                                }
                            })
                        case .failure(let error):
                            print(error)
                        }
                })
            }else{
                let alert = UIAlertController(title: "پست نامعتبر", message: "حتما باید عکسی آپلود شود.", preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "باشه", style: .default, handler: nil)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
                
                postButton.isEnabled = true
                PostTexField.isEnabled = true
                
            }
        }else{
            let alert = UIAlertController(title: "پست نامعتبر", message: "متن نمیتواند خالی باشد", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "باشه", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
            postButton.isEnabled = true
            PostTexField.isEnabled = true
        }
    }
    
    func postToFirebase(_ imgUrl: String?){
        var post: Dictionary<String,AnyObject> = [
            "Description" : PostTexField.text! as AnyObject,
            "Likes" : 0 as AnyObject,
            "UserName" : UserDefaults.standard.value(forKey: KEY_USERNAME) as AnyObject,
            "DateTime": "\(NSDate())" as AnyObject
        ]
        if imgUrl != nil{
            post["ImageUrl"] = imgUrl! as AnyObject?
        }
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        
        firebasePost?.setValue(post)
        
        PostTexField.text = nil
        imageSelector.image = UIImage(named: "camera")
        
        imageSelected = false
        
        postButton.isEnabled = true
        PostTexField.isEnabled = true
        
        tableView.reloadData()
    }
    
    
    @IBAction func logoutBtn(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: KEY_UID)
        let signInVC = storyboard?.instantiateViewController(withIdentifier: "SignInStoryboard") as! SignInViewController
        navigationController?.pushViewController(signInVC, animated: true)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

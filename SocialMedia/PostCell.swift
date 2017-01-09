 //
//  PostCell.swift
//  SocialMedia
//
//  Created by yaser on 10/20/16.
//  Copyright © 2016 yaserBahrami. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class PostCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var showcaseImg: UIImageView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var likeImage: UIImageView!
    
    var post: Post!
    var request : Request?
    var likeRef : Firebase!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.likeTapped(sender:)))
        
        tap.numberOfTapsRequired = 1
        likeImage.addGestureRecognizer(tap)
        likeImage.isUserInteractionEnabled = true
        
    }

    override func draw(_ rect: CGRect) {
        profileImg.layer.cornerRadius = profileImg.frame.size.width/2
        profileImg.clipsToBounds = true
        showcaseImg.clipsToBounds = true
    }
    
    func configureCell(post: Post, img: UIImage?){
        self.post = post
        
        likeRef = DataService.ds.REF_USER_CURRENT.child(byAppendingPath: "Likes").child(byAppendingPath: post.postKey);
        
        self.descriptionText.text = post.postDescription
        self.likesLabel.text = "\(post.likes)"
        
        if post.imageUrl != nil{
            
            if img != nil {
                self.showcaseImg.image = img
            }else{
                request = Alamofire.request(post.imageUrl!).response(completionHandler: { (response ) in
                    
                    if response.error == nil{
                        let img = UIImage(data: response.data!)!
                        self.showcaseImg.image = img
                        FeedViewController.imageCache.setObject(img, forKey: self.post.imageUrl! as AnyObject)
                    }
                }).validate(contentType: ["image/*"])
            }
        }else{
            
            self.showcaseImg.isHidden = true
        }
        
        likeRef?.observeSingleEvent(of: .value, with: { snapshot in
            if let doesNotExist = snapshot?.value as? NSNull{
                //this means we have not likes this specific posts.
                self.likeImage.image = UIImage(named: "heart-empty")
            }
            else{
                self.likeImage.image = UIImage(named: "heart-full")
            }
        })
        
    }
    
    
    func likeTapped(sender: UITapGestureRecognizer) {
        likeRef.observeSingleEvent(of: .value, with: { snapshot in
            
            if let doesNotExist = snapshot?.value as? NSNull {
                self.likeImage.image = UIImage(named: "heart-full")
                self.post.adjustLikes(addLike: true)
                self.likeRef.setValue(true)
                
            } else {
                self.likeImage.image = UIImage(named: "heart-empty")
                self.post.adjustLikes(addLike: false)
                self.likeRef.removeValue()
            }
            self.likesLabel?.text = "\(self.post!.likes)"
        })
    }

    

}

//
//  PostCell.swift
//  SocialMedia
//
//  Created by yaser on 10/20/16.
//  Copyright © 2016 yaserBahrami. All rights reserved.
//

import UIKit
import Alamofire

class PostCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var showcaseImg: UIImageView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var likesLabel: UILabel!
    
    var post: Post!
    var request : Request?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func draw(_ rect: CGRect) {
        profileImg.layer.cornerRadius = profileImg.frame.size.width/2
        profileImg.clipsToBounds = true
        showcaseImg.clipsToBounds = true
    }
    
    func configureCell(post: Post, img: UIImage?){
        self.post = post
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
    }
    

}

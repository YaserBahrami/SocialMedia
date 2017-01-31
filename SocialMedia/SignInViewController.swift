//
//  ViewController.swift
//  SocialMedia
//
//  Created by yaser on 10/5/16.
//  Copyright © 2016 yaserBahrami. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class SignInViewController: UIViewController {
    
    @IBOutlet weak var UserEmail: UITextField!
    @IBOutlet weak var UserPass: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.value(forKey: KEY_UID) != nil{
            self.performSegue(withIdentifier: SEGUE_LOGGED_IN, sender: nil)
        }
    }
    
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func fbBtnPressed(_ sender: UIButton!){
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (facebookResult, facebookError) in
            
            if facebookError != nil {
                print("Facebook login failed. Error \(facebookError)")
            } else {
                let accessToken = FBSDKAccessToken.current().tokenString
                print("Successfully logged in with facebook. \(accessToken)")
                
                DataService.ds.REF_BASE.auth(withOAuthProvider: "facebook", token: accessToken, withCompletionBlock: { error, authData  in
                    if error != nil {
                        print("Login failed. \(error)")
                    } else {
                        let user = ["Provider" : (authData?.provider)!,"Blah":"blah"]
                        DataService.ds.CreateFireBaseUser(uid: (authData?.uid)!, user: user)
                        
                        print("Logged In!\(authData)")
                        UserDefaults.standard.setValue(authData?.uid, forKey: KEY_UID)
                        self.performSegue(withIdentifier: SEGUE_LOGGED_IN, sender: nil)
                    }
                })
            }
        }
    }
    
    @IBAction func LoginAndSignUpBtn(_ sender: AnyObject) {
        
        let ref = DataService.ds.REF_BASE
        let email = UserEmail.text
        let pass = UserPass.text
        
        
        if email != "", pass != "" {
            ref.authUser(email, password: pass, withCompletionBlock: { error, authData in

                if error != nil{
                    let error1 : NSError = error as! NSError
                    self.CheckErrorType(error: error1)
                }
                else {
                    UserDefaults.standard.setValue(authData?.uid, forKey: KEY_UID)
                    self.performSegue(withIdentifier: SEGUE_LOGGED_IN, sender: nil)
                }
            })
            
        }else{
            showErrorAlert(title: "فیلد الزامی", msg: "لطفا ایمیل و پسورد را وارد نمایید.")
        }
    }
    func showErrorAlert(title: String, msg: String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "باشه", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    func showAlertForCreateUser(title: String, msg: String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "عضویت", style: .default, handler: {action in self.GetUserNameInAlert()})
        let action2 = UIAlertAction(title: "ورود مجدد", style: .destructive, handler: nil)
        alert.addAction(action)
        alert.addAction(action2)
        present(alert, animated: true, completion: nil)
    }
    func CheckErrorType (error: NSError){
        switch error.code{
        case Status_Invalid_Email : self.showErrorAlert(title: "خطا", msg: "ایمیل را در فرمت درست وارد کنید.")
        case Status_Invalid_Password : self.showErrorAlert(title: "خطا", msg: "پسورد شما اشتباه است.")
        case Status_Aborted : self.showErrorAlert(title: "خطا", msg: "خطایی در اتصال به سرور رخ داده است. لطفا از اتصال VPN مطمئن شده و بار دیگر امتحان کنید.")
        case Status_Invalid_User : self.showAlertForCreateUser(title: "خطا", msg: "کاربری با این مشخصات یافت نشد. آیا مایل به عضویت با این مشخصات هستید؟")
        default : self.showErrorAlert(title: "خطا", msg: "خطایی رخ داده است لطفا اطلاعات زیر را به پشتیبانی اعلام نمایید." + "\(error.description)")
        }
    }
    func GetUserNameInAlert(){
        let alert = UIAlertController(title: "نام کاربری", message: "لطفا نام کاربری خود را وارد نمایید.", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "نام کاربری"
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(textField?.text)")
            self.CreateFireBaseUser(userName: textField?.text ?? "anonymous")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func CreateFireBaseUser(userName: String){
        let ref = DataService.ds.REF_BASE
        UserDefaults.standard.setValue(userName, forKey: KEY_USERNAME)
        let email = UserEmail.text
        let pass = UserPass.text
        if email != "", pass != ""{
            ref.createUser(email, password: pass,
                           withValueCompletionBlock: { error, result in
                            if error != nil {
                                let error1 = error as! NSError
                                self.CheckErrorType(error: error1)
                            } else {
                                UserDefaults.standard.setValue(result?[KEY_UID], forKey: KEY_UID)
                                DataService.ds.REF_BASE.authUser(email, password: pass, withCompletionBlock: { (error, authData) in
                                    if error != nil{
                                        self.CheckErrorType(error: error as! NSError)
                                    }
                                    else{
                                        let user = ["Provider" : (authData?.provider)!,"UserName":userName]
                                        DataService.ds.CreateFireBaseUser(uid: (authData?.uid)!, user: user)
                                    }
                                })
                                
                                self.performSegue(withIdentifier: SEGUE_LOGGED_IN, sender: nil)
                            }
            })
        }else{
            showErrorAlert(title: "فیلد الزامی", msg: "لطفا ایمیل و پسورد را وارد نمایید.")
        }
    }

    
    
    
    
}


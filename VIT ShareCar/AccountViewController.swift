//
//  AccountViewController.swift
//  VIT ShareCar
//
//  Created by Mridul Agarwal on 18/12/18.
//  Copyright © 2018 Techifuzz. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class AccountViewController: UIViewController {

    var databaseRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageacoount.layer.borderWidth = 1
        imageacoount.layer.masksToBounds = false
        imageacoount.layer.borderColor = UIColor.black.cgColor
        imageacoount.clipsToBounds = true
        
        
        self.databaseRef = Database.database().reference()
        let uid = Auth.auth().currentUser!.uid
        self.databaseRef.child("user").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            
            if let dic = snapshot.value as? [String: AnyObject]{
                let n = dic["name"] as? String
                self.nametext?.text = n
                let imag = dic["image"] as! String
                let rl = NSURL(string: imag)!
                self.imageacoount.image = UIImage(data: NSData(contentsOf: rl as URL)! as Data)
                let ne = dic["number"] as? String
                self.numbertext?.text = ne
            }
        }
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var imageacoount: UIImageView!
    @IBOutlet weak var numbertext: UILabel!
    @IBOutlet weak var nametext: UILabel!
    @IBOutlet weak var likebutt: UIButton!
    @IBAction func likebuttob(_ sender: Any) {
        if let url = URL(string: "\("https://www.facebook.com/VIT-ShareCar-840521829447868/")") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func Logout_button(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signinvs = storyboard.instantiateViewController(withIdentifier: "signinviewcon")
        self.present(signinvs, animated: true, completion: nil)
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

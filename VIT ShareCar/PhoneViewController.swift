//
//  PhoneViewController.swift
//  VIT ShareCar
//
//  Created by Mridul Agarwal on 19/12/18.
//  Copyright © 2018 Techifuzz. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class PhoneViewController: UIViewController {
    
     var databaseRef: DatabaseReference!

    @IBOutlet weak var buttonsubmitphone: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBOutlet weak var Number_text: UITextField!
    @IBOutlet weak var WhatsappNum_text: UITextField!
    @IBAction func Upon_submit(_ sender: Any) {
        dismissKeyboard()
        if(Number_text.text != "" && WhatsappNum_text.text != "" && Number_text.text!.count == 10 && WhatsappNum_text.text!.count == 10){
            let num = Number_text.text!
            let wnum = WhatsappNum_text.text!
            let uid = Auth.auth().currentUser!.uid
            
            self.databaseRef = Database.database().reference()
            self.databaseRef.child("user").child(uid).observeSingleEvent(of: .value) {(snapshot) in
                
                let snapshot = snapshot.value as? NSDictionary
                
                if(snapshot != nil){
                    self.databaseRef.child("user").child(uid).child("number").setValue(num)
                    self.databaseRef.child("user").child(uid).child("number_whatsapp").setValue(wnum)
                    self.performSegue(withIdentifier: "numbersignin", sender: nil)
                    
                }
            }
            
        }
        else{
            SVProgressHUD.showError(withStatus: "Check the number and try again")
            SVProgressHUD.dismiss(withDelay: 2)
            
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func initilize(){
        WhatsappNum_text.keyboardType = UIKeyboardType.numberPad
        Number_text.keyboardType = UIKeyboardType.numberPad
    }
}

//
//  HomeViewController.swift
//  VIT ShareCar
//
//  Created by Mridul Agarwal on 18/12/18.
//  Copyright © 2018 Techifuzz. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class HomeViewController: UIViewController , UIPickerViewDelegate , UIPickerViewDataSource , UITextFieldDelegate {
    
    let pickerData = [String] (arrayLiteral: "VIT-VELLORE", "VIT-CHENNAI", "CHENNAI-AIRPORT", "BANGLORE-AIRPORT", "CHENNAI-RAILWAY-STATION", "VELLORE-RAILWAY-STATION")
    let pickerData2 = [String] (arrayLiteral: "VIT-VELLORE", "VIT-CHENNAI", "CHENNAI-AIRPORT", "BANGLORE-AIRPORT", "CHENNAI-RAILWAY-STATION", "VELLORE-RAILWAY-STATION")
    var currenttextfield = UITextField()
    var pickerfield = UIPickerView()
    var databaseref: DatabaseReference!
    var databaseRef: DatabaseReference!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if currenttextfield == fromtext {
            return pickerData.count
        }
        else if currenttextfield == totext{
            return pickerData2.count
        } else {
            return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if currenttextfield == fromtext {
            return pickerData[row]
        }
        else if currenttextfield == totext{
            return pickerData2[row]
        } else{
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if currenttextfield == fromtext {
           fromtext.text = pickerData[row]
            self.view.endEditing(true)
        }
        else if currenttextfield == totext {
            totext.text = pickerData2[row]
            self.view.endEditing(true)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Date Picker
        let datePicker = UIDatePicker()
         datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        datePicker.addTarget(self, action: #selector(HomeViewController.dateChanged(sender:)), for: .valueChanged)
        let guest = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(guest)
        datetext.inputView = datePicker
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let donebut = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneclicked))
        toolbar.setItems([donebut], animated: true)
        datetext.inputAccessoryView = toolbar
        timetext.inputAccessoryView = toolbar
        
        //time
        let timepicker = UIDatePicker()
        timepicker.datePickerMode = .time
        timepicker.addTarget(self, action: #selector(HomeViewController.timeChanged(sender:)), for: .valueChanged)
        timetext.inputView = timepicker
        
        
        // check number
        self.databaseRef = Database.database().reference()
        let uid = Auth.auth().currentUser!.uid
        self.databaseRef.child("user").child(uid).observeSingleEvent(of: .value) {(snapshot) in
            if let dic = snapshot.value as? [String: AnyObject]{
                let n = dic["number"] as? String
                let w = dic["number_whatsapp"] as? String
                if(n == "default" || w == "default"){
                    SVProgressHUD.show(withStatus: "Phone Number not entered")
                    SVProgressHUD.dismiss(withDelay: 2)
                    self.performSegue(withIdentifier: "reversephone", sender: nil)
                }
            }
        }
    
    }
    @objc func doneclicked(){
        self.view.endEditing(true)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickerfield.dataSource = self
        self.pickerfield.delegate = self
        currenttextfield = textField
        if currenttextfield == fromtext {
            currenttextfield.inputView = pickerfield
        } else if currenttextfield == totext {
            currenttextfield.inputView = pickerfield
        }
    }
    @IBOutlet weak var fromtext: UITextField!
    @IBOutlet weak var totext: UITextField!
    @IBOutlet weak var datetext: UITextField!
    @IBOutlet weak var timetext: UITextField!
    
    
    @objc func dateChanged(sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "d-MMM-YYYY"
        
        datetext.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func timeChanged(sender : UIDatePicker){
        
    
        let timeFormatter = DateFormatter()
        
        timeFormatter.dateFormat = "HH:mm"
        
        timetext.text = timeFormatter.string(from: sender.date)
    }
  @objc func viewTapped(gestureRecognizer : UITapGestureRecognizer) {
        
        view.endEditing(true)
        
}
    
    @IBOutlet weak var butsub: UIButton!
    
    @IBAction func Submitbutton(_ sender: Any) {
        
        
        if(totext.text != "" && fromtext.text != "" && datetext.text != "" && timetext.text != "" && totext.text != fromtext.text){
            let from = fromtext.text!
            let to = totext.text!
            let date = datetext.text!
            let time = timetext.text!
            let uid = Auth.auth().currentUser!.uid
        
            self.databaseref = Database.database().reference()
            databaseref.child("user").child(uid).observeSingleEvent(of: .value) {(snapshot) in
                
                if snapshot.exists()
                {
                    let value = snapshot.value as? NSDictionary
                    let name = value?["name"] as? String ?? ""
                    let email = value?["email"] as? String ?? ""
                    let num = value?["number"] as? String ?? ""
                    let wnum = value?["number_whatsapp"] as? String ?? ""
                    let image = value?["image"] as? String ?? ""
                    let token = value?["token"] as? String ?? ""
                    
                    self.databaseref.child("travel").child(uid).observeSingleEvent(of: .value) {(snapshot) in
            
                        _ = snapshot.value as? NSDictionary
            
                    self.databaseref.child("travel").child(uid).child("to").setValue(from)
                    self.databaseref.child("travel").child(uid).child("from").setValue(to)
                    self.databaseref.child("travel").child(uid).child("date").setValue(date)
                    self.databaseref.child("travel").child(uid).child("time").setValue(time)
                    self.databaseref.child("travel").child(uid).child("name").setValue(name)
                    self.databaseref.child("travel").child(uid).child("email").setValue(email)
                    self.databaseref.child("travel").child(uid).child("number").setValue(num)
                    self.databaseref.child("travel").child(uid).child("wnumber").setValue(wnum)
                    self.databaseref.child("travel").child(uid).child("image").setValue(image)
                    self.databaseref.child("travel").child(uid).child("token").setValue(token)
                        
            }
            
                }}
            SVProgressHUD.showSuccess(withStatus: "Request Sent")
            SVProgressHUD.dismiss(withDelay: 2)
            fromtext.text = ""
            timetext.text = ""
            datetext.text = ""
            totext.text = ""
        }
        else{
            SVProgressHUD.showError(withStatus: "Check all the fields")
            SVProgressHUD.dismiss(withDelay: 2)
        }
        
    }
}

//
//  RideViewController.swift
//  VIT ShareCar
//
//  Created by Mridul Agarwal on 18/12/18.
//  Copyright © 2018 Techifuzz. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class RideViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modellist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewControllerTableViewCell
        
        let model: Modelclass
       
        
        model = modellist[indexPath.row]
         let rl = NSURL(string: model.image ?? "")!
        
        cell.datetext.text = model.date
        cell.timetext.text = model.time
        cell.nametext.text = model.name
        cell.totext.text = model.to
        cell.fromtext.text = model.from
        cell.imageview.image = UIImage(data: NSData(contentsOf: rl as URL)! as Data)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewControllerTableViewCell
        
        let model: Modelclass
        model = modellist[indexPath.row]
        let phoneNumber =  model.number
        let appURL = NSURL(string: "https://api.whatsapp.com/send?phone=\(phoneNumber ?? "9007853935")")!
        if UIApplication.shared.canOpenURL(appURL as URL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL as URL, options: [:], completionHandler: nil)
            }
            else {
                UIApplication.shared.openURL(appURL as URL)
            }
        }
        else {
            print("Whatsapp Not installed")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblemodel.delegate = self
        tblemodel.dataSource = self
        databaseref = Database.database().reference().child("travel")
        databaseref.observe(.value, with:{(snapshot) in
            if snapshot.childrenCount>0 {
                self.modellist.removeAll()
                
                for model in snapshot.children.allObjects as![DataSnapshot]{
                    
                    let modelobj = model.value as? [String: AnyObject]
                    let name = modelobj?["name"]
                    let to = modelobj?["to"]
                    let from = modelobj?["from"]
                    let date = modelobj?["date"]
                    let time = modelobj?["time"]
                    let image = modelobj?["image"]
                    let number = modelobj?["wnumber"]
                    
                    let model = Modelclass(name: name as! String?, date: date as! String?, time: time as! String?, image: image as! String?, to: to as! String?, from: from as! String?,number: number as! String?)
                    
                    self.modellist.append(model)
                    
                }
                self.tblemodel.reloadData()
            }
            
        })
        databaseref.keepSynced(true)
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(RideViewController.dateChanged(sender:)), for: .valueChanged)
        let guest = UITapGestureRecognizer(target: self, action: #selector(RideViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(guest)
        datetes.inputView = datePicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let donebut = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneclicked))
        toolbar.setItems([donebut], animated: true)
        
        datetes.inputAccessoryView = toolbar
    }
    @objc func doneclicked(){
        self.view.endEditing(true)
    }
    
    @IBOutlet weak var tblemodel: UITableView!
    var databaseref: DatabaseReference!
    var modellist = [Modelclass]()
    @IBOutlet weak var datetes: UITextField!
    
    @IBAction func subbutton(_ sender: Any) {
        let abc = datetes.text!
        let text = butfilter.titleLabel?.text
        
        if (abc == ""){
            SVProgressHUD.show(withStatus: "No Date Selected")
            SVProgressHUD.dismiss(withDelay: 1)
        }
        else if(text == "Filter" && abc != ""){
            databaseref = Database.database().reference().child("travel")
            databaseref.queryOrdered(byChild: "date").queryStarting(atValue: abc).queryEnding(atValue: abc).observe(.value, with:{(snapshot) in
                if snapshot.childrenCount>0 {
                    self.modellist.removeAll()
                    
                    for model in snapshot.children.allObjects as![DataSnapshot]{
                        
                        let modelobj = model.value as? [String: AnyObject]
                        let name = modelobj?["name"]
                        let to = modelobj?["to"]
                        let from = modelobj?["from"]
                        let date = modelobj?["date"]
                        let time = modelobj?["time"]
                        let image = modelobj?["image"]
                        let number = modelobj?["wnumber"]
                        
                        let model = Modelclass(name: name as! String?, date: date as! String?, time: time as! String?, image: image as! String?, to: to as! String?, from: from as! String?,number: number as! String?)
                        
                        self.modellist.append(model)
                        
                    }
                    self.tblemodel.reloadData()
                }
                else{
                    SVProgressHUD.show(withStatus: "No Query")
                    SVProgressHUD.dismiss(withDelay: 1)
                    self.butfilter.setTitle("Filter",for: .normal)
                    self.datetes.text = ""
                }
                
            })
            butfilter.setTitle("Clear",for: .normal)
            
        }
        else if(text == "Clear"){
            databaseref = Database.database().reference().child("travel")
            databaseref.observe(.value, with:{(snapshot) in
                if snapshot.childrenCount>0 {
                    self.modellist.removeAll()
                    
                    for model in snapshot.children.allObjects as![DataSnapshot]{
                        
                        let modelobj = model.value as? [String: AnyObject]
                        let name = modelobj?["name"]
                        let to = modelobj?["to"]
                        let from = modelobj?["from"]
                        let date = modelobj?["date"]
                        let time = modelobj?["time"]
                        let image = modelobj?["image"]
                        let number = modelobj?["wnumber"]
                        
                        let model = Modelclass(name: name as! String?, date: date as! String?, time: time as! String?, image: image as! String?, to: to as! String?, from: from as! String?,number: number as! String?)
                        
                        self.modellist.append(model)
                        
                    }
                    self.tblemodel.reloadData()
                }
                
            })
            databaseref.keepSynced(true)
            butfilter.setTitle("Filter",for: .normal)
            datetes.text = ""
        }

    }
    
    @objc func dateChanged(sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "d-MMM-YYYY"
        
        datetes.text = dateFormatter.string(from: sender.date)
    }
    @objc func viewTapped(gestureRecognizer : UITapGestureRecognizer) {
        
        view.endEditing(true)
        
    }
    @IBOutlet weak var butfilter: UIButton!
}



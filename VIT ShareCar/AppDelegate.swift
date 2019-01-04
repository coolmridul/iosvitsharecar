//
//  AppDelegate.swift
//  VIT ShareCar
//
//  Created by Mridul Agarwal on 17/12/18.
//  Copyright © 2018 Techifuzz. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , GIDSignInDelegate {
    
    var window: UIWindow?
    var databaseRef: DatabaseReference!
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        SVProgressHUD.show()
        SVProgressHUD.setBackgroundColor(UIColor.white)
        if error != nil {
            print("Error in google")
            return
        }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if error != nil {
                print("Error in firebase")
                return
            }
            print("User signed into firebase")
            self.databaseRef = Database.database().reference()
            let uid = Auth.auth().currentUser!.uid
            let user = Auth.auth().currentUser
            self.databaseRef.child("user").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                
                let snapshot = snapshot.value as? NSDictionary
                
                if(snapshot == nil){
                    self.databaseRef.child("user").child(uid).child("name").setValue(user?.displayName)
                    self.databaseRef.child("user").child(uid).child("email").setValue(user?.email)
                    self.databaseRef.child("user").child(uid).child("number").setValue("default")
                    self.databaseRef.child("user").child(uid).child("number_whatsapp").setValue("default")
                    self.databaseRef.child("user").child(uid).child("thumb_image").setValue("default")
                    self.databaseRef.child("user").child(uid).child("token").setValue(user?.refreshToken)
                    self.databaseRef.child("user").child(uid).child("image").setValue(user?.photoURL?.absoluteString)
                    SVProgressHUD.dismiss()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let rootcontrol = storyboard.instantiateViewController(withIdentifier: "phonesigninview")
                    if let window = self.window {
                        window.rootViewController = rootcontrol
                    }
                }
                else{
                    SVProgressHUD.dismiss()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let rootcontrol = storyboard.instantiateViewController(withIdentifier: "mainviewcontroller")
                    if let window = self.window {
                        window.rootViewController = rootcontrol
                    }
        
                }
            })
        }
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        // Override point for customization after application launch.
        UITabBar.appearance().tintColor = UIColor.black
        
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: [:])
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

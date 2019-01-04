
//  VIT ShareCar
//
//  Created by Mridul Agarwal on 17/12/18.
//  Copyright © 2018 Techifuzz. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import SVProgressHUD

class SignInViewController: UIViewController , GIDSignInUIDelegate {
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let googlesignIn = GIDSignInButton()
        googlesignIn.frame = CGRect(x: 0, y: 0, width: 180, height: 48)
        googlesignIn.center = view.center
        view.addSubview(googlesignIn)
        
        GIDSignIn.sharedInstance()?.uiDelegate = self
        
    }
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "signinsegue", sender: nil)
            }
    }
}

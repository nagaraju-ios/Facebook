//
//  ViewController.swift
//  Facebook
//
//  Created by THOTA NAGARAJU on 1/21/20.
//  Copyright © 2020 THOTA NAGARAJU. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import FacebookShare


class ViewController: UIViewController {

    override func viewDidLoad() {
       super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func loginManagerDidComplte(_ result: LoginResult){
        
        switch result {
        case .cancelled:
            print("cancel")
        case .failed( let error):
            print("Failed")
        case .success(let grantedPermissions, _, _):
                  
               
    var pvc = self.storyboard?.instantiateViewController(identifier: "SecondVC")
               
    present(pvc!, animated: true, completion: nil)
               
        }

    }
    @IBAction func FBloginBtn(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: [.publicProfile , .userFriends,.userVideos], viewController: self) { result  in self.loginManagerDidComplte(result)
            
        }
        
        
    }
    
}


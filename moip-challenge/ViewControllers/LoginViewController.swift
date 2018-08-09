//
//  LoginViewController.swift
//  moip-challenge
//
//  Created by Luiza Collado Garofalo on 07/08/18.
//  Copyright © 2018 Luiza Garofalo. All rights reserved.
//

import SwiftKeychainWrapper
import UIKit

class LoginViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func login(_ sender: UIButton) {
        NetworkRequest.makeRequest(.POST) { (response: Result<Login>) in
            switch response {
            case .positive(let login):
                if let accessToken = login.accessToken {
                    KeychainWrapper.standard.set(accessToken, forKey: "access_token")
                }
            case .negative(let error):
                print(error)
            }
        }
    }
}

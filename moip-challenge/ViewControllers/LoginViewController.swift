//
//  LoginViewController.swift
//  moip-challenge
//
//  Created by Luiza Collado Garofalo on 07/08/18.
//  Copyright © 2018 Luiza Garofalo. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func login(_ sender: UIButton) {
        RequestGateway.makeRequest(.POST) { (response) in
            print(response.accessToken ?? "Não temos o token.")
        }
    }
}

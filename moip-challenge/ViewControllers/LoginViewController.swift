import SwiftKeychainWrapper
import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!

    override func viewWillAppear(_ varmated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func login(_ sender: UIButton) {
        NetworkRequest.makeRequest(.POST(self.username.text!, self.password.text!)) { (response: Result<Login>) in
            switch response {
            case .positive(let login):
                if let token = login.accessToken {
                    KeychainWrapper.standard.set(token, forKey: "access_token")
                }
            case .negative(let error):
                print(error)
            }
        }
    }
}

import SwiftKeychainWrapper
import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!

    override func viewWillAppear(_ varmated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        if KeychainWrapper.standard.string(forKey: "access_token") != nil {
            self.performSegue(withIdentifier: "showOrdersSegue", sender: nil)
        }
    }

    @IBAction func login(_ sender: UIButton) {
        let onSuccess: (Login) -> Void = { login in
            if let token = login.accessToken {
                KeychainWrapper.standard.set(token, forKey: "access_token")
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "showOrdersSegue", sender: nil)
                }
            }
        }

        let onComplete: (Result<Login>) -> Void = { response in
            switch response {
            case .positive(let login): onSuccess(login)
            case .negative(let error): print(error)
            }
        }

        NetworkRequest.makeRequest(.POST(self.username.text!, self.password.text!), onComplete: onComplete)
    }
}

import SwiftKeychainWrapper
import UIKit

class OrdersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    lazy var token = KeychainWrapper.standard.string(forKey: "access_token")
    @IBOutlet weak var ordersTableView: UITableView!
    private var orders: [Order] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.ordersTableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        ordersTableView.register(UINib(nibName: "OrderTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.loadData()
        }
    }

    private func loadData() {
        NetworkRequest.makeRequest(.GET(token!), onComplete: updateOrders)
    }

    private func updateOrders(response: Result<Orders>) {
        switch response {
        case .positive(let orders):
            DispatchQueue.main.async {
                self.orders += orders.orders!
            }

        case .negative(let error):
            print(">> Error:", error.localizedDescription)

        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                       for: indexPath) as? OrderTableViewCell else {
                                                        return UITableViewCell()
        }

        cell.date.text = self.orders[indexPath.row].createdAt
        cell.email.text = self.orders[indexPath.row].customer?.email
        cell.status.text = self.orders[indexPath.row].status
        cell.token.text = self.orders[indexPath.row].id
        cell.value.text = String(describing: self.orders[indexPath.row].amount?.total)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showOrderDetailsSegue", sender: indexPath.row)
    }
}

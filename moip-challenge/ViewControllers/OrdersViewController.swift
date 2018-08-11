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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.loadData()
        }
    }
    
    private func loadData() {
        NetworkRequest.makeRequest(.GET(token!, nil), onComplete: updateOrders)
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
        
        let firstFormatter = DateFormatter()
        let secondFormatter = DateFormatter()
        firstFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        secondFormatter.dateFormat = "dd/MM/yyyy"
        
        if let date = firstFormatter.date(from: self.orders[indexPath.row].createdAt) {
            let formattedDate = secondFormatter.string(from: date)
            cell.date.text = formattedDate
        }
        
        if let status = self.orders[indexPath.row].status {
            cell.status.text = status
            
            switch status {
            case "PAID":
                cell.status.textColor = UIColor(red: 0.4157, green: 0.6902, blue: 0.298, alpha: 1.0)
            case "WAITING":
                cell.status.textColor = UIColor(red: 0.9765, green: 0.7922, blue: 0.1412, alpha: 1.0)
            default:
                cell.status.textColor = UIColor(red: 0.9216, green: 0.302, blue: 0.2941, alpha: 1.0)
            }
        }
        
        cell.email.text = self.orders[indexPath.row].customer?.email
        cell.token.text = self.orders[indexPath.row].id
        cell.value.text = "R$ " + self.orders[indexPath.row].amount.total.currency
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let order = self.orders[indexPath.row]
        self.performSegue(withIdentifier: "showOrderDetailsSegue", sender: order)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let orderDetailsViewController = segue.destination as? OrderDetailsViewController {
            if let order = sender as? Order {
                orderDetailsViewController.order = order.id
            }
        }
    }
}

extension Int {
    var currency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSize = 2
        formatter.secondaryGroupingSize = 3
        return formatter.string(from: self as NSNumber)!
    }
}

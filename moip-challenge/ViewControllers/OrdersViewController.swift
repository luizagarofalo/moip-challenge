import SwiftKeychainWrapper
import UIKit

class OrdersViewController: UIViewController {
    lazy var token = KeychainWrapper.standard.string(forKey: "access_token")
    @IBOutlet weak var ordersTableView: UITableView!
    private var orders: [Order] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.ordersTableView.reloadData()
            }
        }
    }

    private var isLoadingNext = false
    private var limit = 10
    private var offset = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        ordersTableView.register(UINib(nibName: "OrderTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        if self.token != nil {
            self.loadData()
        } else {
            self.handleError()
        }
    }

    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
        if parent == nil {
            KeychainWrapper.standard.removeObject(forKey: "access_token")
        }
    }

    private func loadData() {
        NetworkRequest.makeRequest(.GET(.orders(token!, limit, offset)), onComplete: updateOrders)
    }

    private func updateOrders(response: Result<Orders>) {
        switch response {
        case .success(let orders):
            if orders.orders != nil {
                self.orders += orders.orders!
            } else {
                self.handleError()
            }

        case .failure(let error):
            print(error.localizedDescription)
            self.handleError()
        }
    }

    private func handleError() {
        DispatchQueue.main.async {
            _ = self.navigationController?.popToRootViewController(animated: false)
            self.showError(title: "Oops!", message: "Something went wrong. Please, try again.")
        }
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isLoadingNext = false
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (ordersTableView.contentOffset.y + ordersTableView.frame.size.height)
            >= ordersTableView.contentSize.height {
            if !isLoadingNext {
                isLoadingNext = true
                self.offset += self.limit
                loadData()
            }
        }
    }
}

extension OrdersViewController: UITableViewDataSource {
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

        cell.status.textColor = self.orders[indexPath.row].statusColor
        cell.status.text = self.orders[indexPath.row].statusText
        cell.email.text = self.orders[indexPath.row].customer?.email
        cell.token.text = self.orders[indexPath.row].id
        cell.value.text = "R$ " + self.orders[indexPath.row].amount.total.currency

        return cell
    }
}

extension OrdersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let order = self.orders[indexPath.row]
        self.performSegue(withIdentifier: "showOrderDetailsSegue", sender: order)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let orderDetailsViewController = segue.destination as? OrderDetailsViewController else {
            self.handleError()
            return
        }

        if let order = sender as? Order {
            orderDetailsViewController.order = order.id
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

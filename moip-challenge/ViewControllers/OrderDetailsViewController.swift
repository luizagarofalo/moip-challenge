import SwiftKeychainWrapper
import UIKit

class OrderDetailsViewController: UIViewController {
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var ownID: UILabel!
    @IBOutlet weak var operationType: UILabel!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var buyerName: UILabel!
    @IBOutlet weak var buyerEmail: UILabel!
    @IBOutlet weak var creationDate: UILabel!
    @IBOutlet weak var currentStatus: UILabel!
    @IBOutlet weak var currentStatusDate: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var tax: UILabel!
    @IBOutlet weak var liquidValue: UILabel!
    @IBOutlet weak var numberOfPayments: UILabel!
    
    lazy var token = KeychainWrapper.standard.string(forKey: "access_token")
    var order = ""
    let firstFormatter = DateFormatter()
    let secondFormatter = DateFormatter()
    
    override func viewWillAppear(_ animated: Bool) {
        firstFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        secondFormatter.dateFormat = "dd/MM/yyyy"
        loadData()
    }
    
    private func loadData() {
        NetworkRequest.makeRequest(.GET(token!, self.order), onComplete: updateOrders)
    }
    
    private func updateOrders(response: Result<Order>) {
        switch response {
        case .positive(let order):
            DispatchQueue.main.async {
                self.value.text = "R$ " + order.amount.total.currency
                self.ownID.text = order.ownID
                self.id.text = order.id
                self.operationType.text = order.payments?[0].fundingInstrument?.method
                self.buyerName.text = order.customer?.fullname
                self.buyerEmail.text = order.customer?.email
                self.currentStatus.text = order.status
                self.totalAmount.text = "+ R$ " + order.amount.total.currency
                self.tax.text = "- R$ " + (order.amount.fees?.currency ?? "0")
                self.liquidValue.text = "R$ " + (order.amount.liquid?.currency ?? order.amount.total.currency)
                
                if let date = self.firstFormatter.date(from: order.createdAt) {
                    let formattedDate = self.secondFormatter.string(from: date)
                    self.creationDate.text = formattedDate
                }
                
                if let date = self.firstFormatter.date(from: order.updatedAt) {
                    let formattedDate = self.secondFormatter.string(from: date)
                    self.currentStatusDate.text = formattedDate
                }
                
                if let payments = order.payments?.count {
                    self.numberOfPayments.text = String(payments)
                }
            }
            
        case .negative(let error):
            print(">> Error:", error.localizedDescription)
        }
    }
}

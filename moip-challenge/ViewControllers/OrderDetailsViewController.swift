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

    var order = ""
    lazy var token = KeychainWrapper.standard.string(forKey: "access_token")
    private let firstFormatter = DateFormatter()
    private let secondFormatter = DateFormatter()

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Voltar"
        loadData()
    }

    private func loadData() {
        NetworkRequest.makeRequest(.GET(.order(token!, self.order)), onComplete: updateOrder)
    }

    private func updateOrder(response: Result<Order>) {
        switch response {
        case .positive(let order):
            DispatchQueue.main.async {
                self.updateValues(from: order)
            }

        case .negative(let error):
            print(">> Error:", error.localizedDescription)
        }
    }

    private func updateValues(from order: (Order)) {
        self.firstFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        self.secondFormatter.dateFormat = "dd/MM/yyyy"

        self.value.text = "R$ " + order.amount.total.currency
        self.ownID.text = order.ownID
        self.id.text = order.id
        self.operationType.text = order.payments?[0].fundingInstrument?.method
        self.buyerName.text = order.customer?.fullname
        self.buyerEmail.text = order.customer?.email
        self.totalAmount.text = "+ R$ " + order.amount.total.currency
        self.tax.text = "- R$ " + (order.amount.fees?.currency ?? "0")
        self.liquidValue.text = "R$ " + (order.amount.liquid?.currency ?? order.amount.total.currency)

        if let operationType = order.payments?[0].fundingInstrument?.method {
            switch operationType {
            case "CREDIT_CARD":
                self.operationType.text = "Cartão de crédito"
            default:
                self.operationType.text = "Boleto"
            }
        }

        if let status = order.status {
            switch status {
            case "PAID":
                self.currentStatus.text = "Pago"
                self.currentStatus.textColor = UIColor(red: 0.4157, green: 0.6902, blue: 0.298, alpha: 1.0)
            case "WAITING":
                self.currentStatus.text = "Aguardando"
                self.currentStatus.textColor = UIColor(red: 0.9765, green: 0.7922, blue: 0.1412, alpha: 1.0)
            default:
                self.currentStatus.text = "Não Pago"
                self.currentStatus.textColor = UIColor(red: 0.9216, green: 0.302, blue: 0.2941, alpha: 1.0)
            }
        }

        if let date = self.firstFormatter.date(from: order.createdAt) {
            let formattedDate = self.secondFormatter.string(from: date)
            print(formattedDate)
            self.creationDate.text = formattedDate
        }

        if let payments = order.payments?.count {
            self.numberOfPayments.text = String(payments)
        }
    }
}

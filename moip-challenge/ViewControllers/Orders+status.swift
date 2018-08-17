import Foundation
import UIKit

extension Order {
    var statusColor: UIColor {
        guard let status = status else { return UIColor(red: 0.9216, green: 0.302, blue: 0.2941, alpha: 1.0) }

        switch status {
        case "PAID":
            return UIColor(red: 0.4157, green: 0.6902, blue: 0.298, alpha: 1.0)
        case "WAITING":
            return UIColor(red: 0.9765, green: 0.7922, blue: 0.1412, alpha: 1.0)
        default:
            return UIColor(red: 0.9216, green: 0.302, blue: 0.2941, alpha: 1.0)
        }
    }

    var statusText: String {
        guard let status = status else { return "" }

        switch status {
        case "PAID":
            return "Pago"
        case "WAITING":
            return "Aguardando"
        default:
            return "Não Pago"
        }
    }
}

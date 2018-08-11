import UIKit

class OrderTableViewCell: UITableViewCell {
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var token: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

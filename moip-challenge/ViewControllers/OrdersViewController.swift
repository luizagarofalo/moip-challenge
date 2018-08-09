//
//  OrdersViewController.swift
//  moip-challenge
//
//  Created by Luiza Collado Garofalo on 07/08/18.
//  Copyright © 2018 Luiza Garofalo. All rights reserved.
//

import SwiftKeychainWrapper
import UIKit

class OrdersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
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
        self.loadData()
    }

    private func loadData() {
        NetworkRequest.makeRequest(.GET) { (response: Result<Orders>) in
            switch response {
            case .positive(let orders):
                DispatchQueue.main.async {
                    if orders.orders != nil {
                        self.orders += orders.orders!
                        self.ordersTableView.reloadData()
                        print(orders)
                    } else {
                        print("No orders found for this account.")
                    }
                }

            case .negative(let error):
                print(">> Error:", error.localizedDescription)
            }
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

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showOrderDetailsSegue", sender: indexPath.row)
    }
}

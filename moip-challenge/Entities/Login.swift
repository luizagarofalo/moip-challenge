//
//  Login.swift
//  moip-challenge
//
//  Created by Luiza Garofalo on 08/08/18.
//  Copyright © 2018 Luiza Garofalo. All rights reserved.
//

import Foundation

struct Login: Codable {
    let accessToken: String?
    let moipAccount: MoipAccount?

    enum CodingKeys: String, CodingKey {
        case accessToken, moipAccount
    }
}

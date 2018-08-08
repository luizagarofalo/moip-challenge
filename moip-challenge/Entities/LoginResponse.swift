//
//  LoginResponse.swift
//  moip-challenge
//
//  Created by Luiza Collado Garofalo on 07/08/18.
//  Copyright © 2018 Luiza Garofalo. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    let accessToken: String?
    let moipAccount: MoipAccount?
    
    enum CodingKeys: String, CodingKey {
        case accessToken, moipAccount
    }
}

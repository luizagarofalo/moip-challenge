//
//  LoginRequest.swift
//  moip-challenge
//
//  Created by Luiza Collado Garofalo on 07/08/18.
//  Copyright © 2018 Luiza Garofalo. All rights reserved.
//

import Foundation

struct LoginRequest: Codable {
    let clientID, clientSecret, grantType, username: String?
    let password, deviceID, scope: String?
    
    enum CodingKeys: String, CodingKey {
        case clientID = "client_id"
        case deviceID = "deviceId"
        case clientSecret, grantType, username, password, scope
    }
}

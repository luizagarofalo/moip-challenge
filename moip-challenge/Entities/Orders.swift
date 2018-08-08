//
//  Orders.swift
//  moip-challenge
//
//  Created by Luiza Collado Garofalo on 07/08/18.
//  Copyright © 2018 Luiza Garofalo. All rights reserved.
//

import Foundation

struct Orders: Codable {
    let summary: Summary?
    let orders: [Order]?
}

struct Order: Codable {
    let id, ownID, status: String?
    let amount: Amount?
    let receivers: [Receiver]?
    let customer: Customer?
    let payments: [Payment]?
    let events: [Event]?
    let createdAt, updatedAt: String?
}

struct Amount: Codable {
    let paid, total, addition, fees, deduction: Int?
    let refunds, liquid, otherReceivers: Int?
    let currency: String?
}

struct Customer: Codable {
    let id, ownId, fullname, email: String?
}

struct Event: Codable {
    let type, createdAt: String?
}

struct Payment: Codable {
    let id: String?
    let installmentCount: Int?
    let fundingInstrument: FundingInstrument?
}

struct FundingInstrument: Codable {
    let method, brand: String?
}

struct Receiver: Codable {
    let type: String?
    let moipAccount: MoipAccount?
}

struct MoipAccount: Codable {
    let id: String?
}

struct Summary: Codable {
    let count, amount: Int?
}
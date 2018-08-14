import Foundation

struct Orders: Codable {
    let summary: Summary?
    let orders: [Order]?
}

struct Order: Codable {
    let id: String
    let ownID, status: String?
    let amount: Amount
    let customer: Customer?
    let payments: [Payment]?
    let events: [Event]?
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case ownID = "ownId"
        case status, amount, customer, payments, events
        case createdAt, updatedAt
    }
}

struct Amount: Codable {
    let total: Int
    let fees, liquid: Int?
    let currency: String?
}

struct Customer: Codable {
    let fullname, email: String?
}

struct Event: Codable {
    let type, createdAt: String?
}

struct Payment: Codable {
    let id: String?
    let fundingInstrument: FundingInstrument?
}

struct FundingInstrument: Codable {
    let method, brand: String?
}

struct MoipAccount: Codable {
    let id: String?
}

struct Summary: Codable {
    let count, amount: Int?
}

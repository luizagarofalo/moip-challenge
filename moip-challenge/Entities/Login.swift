import Foundation

struct Login: Codable {
    let accessToken: String?
    let moipAccount: MoipAccount?

    enum CodingKeys: String, CodingKey {
        case accessToken, moipAccount
    }
}

//
//  NetworkRequest.swift
//  moip-challenge
//
//  Created by Luiza Garofalo on 08/08/18.
//  Copyright © 2018 Luiza Garofalo. All rights reserved.
//

import Foundation

class NetworkRequest {
    private static let path = "https://connect-sandbox.moip.com.br/oauth/token"
    private static let session = URLSession(configuration: .default)

    static func makeRequest(_ method: Method, onComplete: @escaping (LoginResponse) -> Void) {
        var request: URLRequest

        switch method {
        case .GET:
            request = URLRequest(url: URL(string: path)!)
            request.httpMethod = "GET"

        case .POST:
            request = URLRequest(url: URL(string: path)!)
            request.httpMethod = "POST"

            let body = "client_id=APP-H1DR0RPHV7SP&" +
                "client_secret=05acb6e128bc48b2999582cd9a2b9787&" +
                "grant_type=password&" +
                "username={INSERT_USERNAME}&" +
                "password={INSERT_PASSWORD}&" +
                "device_id=111111&" +
                "scope=APP_ADMIN"

            request.httpBody = body.data(using: String.Encoding.utf8)

            self.session.dataTask(with: request)  { (data, response, error) in


                guard let data = data else {
                    print(">> Error:", error.debugDescription)
                    return
                }

                print(">> Response:", String(data: data, encoding: String.Encoding.utf8)!)

                do {
                    let login = try JSONDecoder().decode(LoginResponse.self, from: data)
                    onComplete(login)
                } catch {
                    print(">> Error:", error)
                }
                }.resume()
        }
    }
}

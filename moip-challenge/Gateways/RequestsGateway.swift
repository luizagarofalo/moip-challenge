//
//  RequestsGateway.swift
//  moip-challenge
//
//  Created by Luiza Collado Garofalo on 07/08/18.
//  Copyright © 2018 Luiza Garofalo. All rights reserved.
//

import Foundation

class RequestGateway {
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
            
            do {
                let body = try JSONEncoder().encode(LoginRequest(clientID: "APP-H1DR0RPHV7SP",
                                                                 clientSecret: "05acb6e128bc48b2999582cd9a2b9787",
                                                                 grantType: "password",
                                                                 username: "{USER_MOIP_LOGIN}",
                                                                 password: "{USER_MOIP_PASSWORD}",
                                                                 deviceID: "111111",
                                                                 scope: "APP_ADMIN"))
                request.httpBody = body
                let bodyString = String(data: body, encoding: .utf8)
                print(bodyString!)
            } catch {
                print(error)
            }
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        self.session.dataTask(with: request)  { (data, response, error) in
            
            
            guard let data = data else {
                print(">> Error:", error.debugDescription)
                return
            }
            
            print(">> Response:", String(data: data, encoding: String.Encoding.utf8)!)
            
            do {
                let login = try JSONDecoder().decode(LoginResponse.self, from: data)
                print(">> Login:", login)
                onComplete(login)
            } catch {
                print(">> Error:", error)
            }
            }.resume()
    }
}

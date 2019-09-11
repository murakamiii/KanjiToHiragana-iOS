//
//  GooAPI.swift
//  StringToHiraganaiOS
//
//  Created by murakami Taichi on 2019/09/09.
//  Copyright © 2019 murakammm. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Reachability

enum APIError: Error {
    case client
    case network
    case server(info: ErrorResponse?)
    case unknown(error: Error?)
    
    func message() -> String {
        switch self {
        case .client:
            return "アプリ側に問題があります（ごめんなさい）。"
        case .network:
            return "ネットワーク環境に問題があります。"
        case .server(let info):
            return info?.error.message ?? "サーバー側に問題が発生しているようです。"
        case .unknown(error: let err):
            return err?.localizedDescription ?? "原因不明のエラーです。"
        }
    }
}

extension APIError: Equatable {
    static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.client, .client):
            return true
        case (.network, .network):
            return true
        case (.server(info: let lhsInfo), .server(info: let rhsInfo)):
            return lhsInfo == rhsInfo
        case (.unknown(error: let lhsErr), .unknown(error: let rhsErr)):
            return lhsErr?.localizedDescription == rhsErr?.localizedDescription
        default:
            return false
        }
    }
}

struct ErrorResponse: Decodable, Equatable {
    struct Info: Decodable, Equatable {
        let code: Int
        let message: String
    }
    
    let error: ErrorResponse.Info
}

struct Response: Decodable {
    let requestId: String
    let outputType: String
    let converted: String
}

class GooAPI {
    private static func gooAPIKeyFromPlist() -> String? {
        if let path = Bundle.main.path(forResource: "key", ofType: "plist"),
            let ndic = NSDictionary.init(contentsOfFile: path),
            let value = ndic["goo_api"] as? String {
            return value
        }
        return nil
    }
    
    private let apiKey: String
    init?() {
        guard let key = GooAPI.gooAPIKeyFromPlist() else {
            return nil
        }
        
        apiKey = key
    }
    
    func transrate(sentence: String) -> Observable<Response> {
        if Reachability.init()!.connection == .none {
            return Observable.error(APIError.network)
        }
        
        let body = ["app_id": apiKey, "sentence": sentence, "output_type": "hiragana"]
        guard let json = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            return Observable.error(APIError.client)
        }
        
        let session = URLSession.shared
        let url = URL(string: "https://labs.goo.ne.jp/api/hiragana")!
        
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = json
        
        return session.rx.response(request: req).map { resp, data in
            if resp.statusCode != 200 {
                let resp = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                throw APIError.server(info: resp)
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            if let decoded = try? decoder.decode(Response.self, from: data) {
                return decoded
            } else {
                throw APIError.client
            }
        }
    }
}

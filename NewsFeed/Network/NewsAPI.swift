//
//  NewsAPI.swift
//  NewsFeed
//
//  Created by Tran Minh Tung on 1/7/18.
//  Copyright © 2018 TungTM. All rights reserved.
//

import Moya
import RxSwift
import Alamofire

let NEWS_API_KEY = "2464a5f9e7ff4d909edbbd7ee7c477eb"

// MARK: - Provider setup
private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data // fallback to original data if it can't be serialized.
    }
}

let endpointClosure = { (target: NewsAPI) -> Endpoint<NewsAPI> in
    let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
    
    // Sign all non-authenticating requests
    switch target {
    case .headlines:
        return defaultEndpoint.adding(newHTTPHeaderFields: ["Content-type": "application/json",
                                                            "X-Api-Key": NEWS_API_KEY])
    }
}

let NewsAPIProvider = MoyaProvider<NewsAPI>(endpointClosure: endpointClosure,
                                        manager: DefaultAlamofireManager.sharedManager,
                                        plugins: [
                                            NetworkLoggerPlugin(verbose: true,
                                                                responseDataFormatter: JSONResponseDataFormatter)])

// MARK: - Provider support

private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

public enum NewsAPI {
    case headlines
}

extension NewsAPI: TargetType {
    public var baseURL: URL { return URL(string: "https://newsapi.org/v2")! }
    public var path: String {
        switch self {
        case .headlines:
            return "/top-headlines"
        }
    }
    public var method: Moya.Method {
        return .get
    }
    public var task: Task {
        switch self {
        case .headlines:
            return .requestParameters(parameters: ["sources": "bbc-sport"], encoding: URLEncoding.default)
        }
    }
    public var validate: Bool {
        switch self {
        case .headlines:
            return true
        }
    }
    public var sampleData: Data {
        switch self {
        case .headlines:
            return "{\"status\": \"error\",\"code\": \"apiKeyInvalid\",\"message\": \"Your API key is invalid or incorrect. Check your key, or go to https://newsapi.org to create a free API key.\"}".data(using: String.Encoding.utf8)!
        }
    }
    public var headers: [String: String]? {
        return nil
    }
}

public func url(_ route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}

// MARK: - Response Handlers
extension Moya.Response {
    func mapNSArray() throws -> NSArray {
        let any = try self.mapJSON()
        guard let array = any as? NSArray else {
            throw MoyaError.jsonMapping(self)
        }
        return array
    }
}

// MARK: - Session Manager
class DefaultAlamofireManager: Alamofire.SessionManager {
    static let sharedManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 10 // as seconds, you can set your request timeout
        configuration.timeoutIntervalForResource = 10 // as seconds, you can set your resource timeout
        configuration.requestCachePolicy = .useProtocolCachePolicy
        return DefaultAlamofireManager(configuration: configuration)
    }()
}

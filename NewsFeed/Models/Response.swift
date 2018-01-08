//
//  Response.swift
//  NewsFeed
//
//  Created by Tran Minh Tung on 1/7/18.
//  Copyright © 2018 TungTM. All rights reserved.
//

import Foundation
import ObjectMapper
import RxCocoa

// MARK: - Results
enum ApiResult<T> {
    case success(T)
    case failure(String)
    case unauthorized(String)
}

extension ApiResult: Error {}

typealias HeadlinesResult = ApiResult<HeadlinesResponse>

struct HeadlinesResponse: Mappable {
    var success: Bool = false
    var totalResults: Int?
    var articles: [ArticleItem]?
    
    init() {}
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        success <- map["success"]
        totalResults <- map["totalResults"]
        articles <- map["articles"]
    }
}

enum Result<T, E: Error> {
    case success(T)
    case failure(E)
}

enum NewsServiceError: Error {
    case offline
    case unauthorized
}

extension NewsServiceError {
    var displayMessage: String {
        switch self {
        case .offline:
            return "Ups, no network connectivity"
        case .unauthorized:
            return "Unauthorized access"
        }
    }
}

typealias NewsFeedResponse = Result<(articles: [ArticleItem], nextURL: URL?), NewsServiceError>

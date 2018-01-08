//
//  NewsFeedState.swift
//  NewsFeed
//
//  Created by Tran Minh Tung on 1/8/18.
//  Copyright © 2018 TungTM. All rights reserved.
//

import Foundation

fileprivate struct State {
    var sources: String {
        didSet {
            if sources.isEmpty {
                self.nextPageURL = nil
                self.shouldLoadNextPage = false
                self.results = []
                self.lastError = nil
                return
            }
            self.nextPageURL = nil
            self.shouldLoadNextPage = true
            self.lastError = nil
        }
    }
    
    var nextPageURL: URL?
    var shouldLoadNextPage: Bool
    var results: [ArticleItem]
    var lastError: NewsServiceError?
}

fileprivate enum Event {
    case fetchHealines(String)
    case response(NewsFeedResponse)
    case startLoadingNextPage
}

// transitions
extension State {
    static var empty: State {
        return State(sources: "", nextPageURL: nil, shouldLoadNextPage: true, results: [], lastError: nil)
    }
    static func reduce(state: State, event: Event) -> State {
        switch event {
        case .fetchHealines(let sources):
            var result = state
            result.sources =  sources
            result.results = []
            return result
        case .startLoadingNextPage:
            var result = state
            result.shouldLoadNextPage = true
            return result
        case .response(.success(let response)):
            var result = state
            result.results += response.articles
            result.shouldLoadNextPage = false
            result.nextPageURL = response.nextURL
            result.lastError = nil
            return result
        case .response(.failure(let error)):
            var result = state
            result.shouldLoadNextPage = false
            result.lastError = error
            return result
        }
    }
}

// queries
extension State {
    var loadNextPage: URL? {
        return self.shouldLoadNextPage ? self.nextPageURL : nil
    }
}

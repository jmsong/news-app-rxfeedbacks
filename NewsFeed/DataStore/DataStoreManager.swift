//
//  DataStoreManager.swift
//  NewsFeed
//
//  Created by Tran Minh Tung on 1/7/18.
//  Copyright © 2018 TungTM. All rights reserved.
//

import Moya
import Moya_ObjectMapper
import RxSwift

// MARK: - Main
class DataStoreManager {
    static let shared = DataStoreManager()
    fileprivate let disposeBag = DisposeBag()
    
    func transformsError<T>(error: Swift.Error) -> Observable<ApiResult<T>> {
        let result = error as? ApiResult<Response>
        
        guard let unwrapResult = result else {
            return Observable.just(ApiResult<T>.failure(Localizer.something_wrong.description))
        }
        
        switch unwrapResult {
        case .unauthorized(let msg):
            return Observable.just(ApiResult<T>.unauthorized(msg))
        default:
            return Observable.just(ApiResult<T>.failure(Localizer.something_wrong.description))
        }
    }
}

extension DataStoreManager {
    func fetchHeadlines() {
        NewsAPIProvider.rx.request(.headlines)
            .filterSuccessfulStatusCodes()
            .mapObject(HeadlinesResponse.self)
//            return NewsAPIProvider.rx.request(.headlines)
//                .map({ response in
//                    var failed = false
//                    var headlinesResponse = HeadlinesResponse()
//                    do {
//                        let feedResponse = try response.mapObject(HeadlinesResponse.self)
//                        headlinesResponse = self.transforms(from: feedResponse)
//                    } catch(let err) {
//                        LOGGER.error("error: \(err.localizedDescription)")
//                        failed = true
//                    }
//
//                    if failed {
//                        return HeadlinesResult.failure(Localizer.something_wrong.description)
//                    } else {
//                        return HeadlinesResult.success(headlinesResponse)
//                    }
//                })
            
                /*.catchError({ [weak self] error -> Observable<HeadlinesResult> in
                    return (self?.transformsError(error: error))!
                })*/
    }
}

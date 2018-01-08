//
//  Observable+ErrorHandler.swift
//  NewsFeed
//
//  Created by Tran Minh Tung on 1/7/18.
//  Copyright © 2018 TungTM. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import SVProgressHUD

extension Observable where E == Response {
    func filterSuccessCases() -> Observable<E> {
        return flatMap { (response) -> Observable<E> in
            switch response.statusCode {
            case 200...299:
                return Observable.just(response)
            case 401:
                return Observable.error(ApiResult<E>.unauthorized("Unauthorized access"))
            default:
                return Observable.error(ApiResult<E>.failure(response.description))
            }
        }
    }
}

//
//  Observable+ObjectMapper.swift
//  RxSwiftMoya
//
//  Created by monkey on 2017/3/29.
//  Copyright © 2017年 Coder. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import ObjectMapper

public extension ObservableType where E == Response {
    public func mapResult<T: BaseMappable>(_ type: T.Type, context: MapContext? = nil) -> Observable<[T]> {
        return flatMap { response -> Observable<[T]> in
            return Observable.just(try response.mapResult(T.self, context: context))
        }
    }
}

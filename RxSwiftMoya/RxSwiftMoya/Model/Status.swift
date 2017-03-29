//
//  Status.swift
//  RxSwiftMoya
//
//  Created by monkey on 2017/3/29.
//  Copyright © 2017年 Coder. All rights reserved.
//

import Foundation
import ObjectMapper

struct Status : Mappable{
    var code : Int!
    var message : String?
    var result : Any?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        code    <-      map["code"]
        message <-      map["message"]
        result  <-      map["result"]
    }
}

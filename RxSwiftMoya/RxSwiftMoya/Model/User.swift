//
//  User.swift
//  RxSwiftMoya
//
//  Created by monkey on 2017/3/29.
//  Copyright © 2017年 Coder. All rights reserved.
//

import Foundation
import ObjectMapper

struct User : Mappable{
    var name: String!
    var age: Int!
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map){
        name <- map["name"]
        age  <- map["age"]
    }
}

//
//  Repository.swift
//  RxSwiftMultithreading
//
//  Created by monkey on 2017/4/6.
//  Copyright © 2017年 Coder. All rights reserved.
//

import ObjectMapper

class Repository: Mappable {
    var identifier: Int!
    var language: String!
    var url: String!
    var name: String!
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        identifier <- map["id"]
        language <- map["language"]
        url <- map["url"]
        name <- map["name"]
    }
}

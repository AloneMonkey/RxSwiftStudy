//
//  UserAPI.swift
//  RxSwiftMoya
//
//  Created by monkey on 2017/3/29.
//  Copyright © 2017年 Coder. All rights reserved.
//

import Foundation
import Moya

let UserProvider = RxMoyaProvider<UserAPI>(stubClosure: MoyaProvider.immediatelyStub)

enum UserAPI{
    case list(Int,Int)
}

extension UserAPI : TargetType{
    var baseURL : URL{
        return URL(string: "http://www.alonemonkey.com")!
    }
    
    var path: String{
        switch self {
        case .list:
            return "userlist"
        }
    }
    
    var method: Moya.Method{
        switch self {
        case .list:
            return .get
        }
    }
    
    var parameters: [String: Any]?{
        switch self{
        case .list(let start, let size):
            return ["start": start, "size": size]
        }
    }
    
    var parameterEncoding: ParameterEncoding{
        return URLEncoding.default
    }
    
    var task: Task{
        return .request
    }
    
    var sampleData: Data{
        switch self {
        case .list(_, _):
            if let path = Bundle.main.path(forResource: "UserListError", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                    return data
                } catch let error {
                    print(error.localizedDescription)
                }
            }
            return Data()
        }
    }
}

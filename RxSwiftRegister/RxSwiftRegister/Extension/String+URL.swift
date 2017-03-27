//
//  String+URL.swift
//  RxSwiftRegister
//
//  Created by monkey on 2017/3/27.
//  Copyright © 2017年 Coder. All rights reserved.
//

extension String {
    var URLEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
}

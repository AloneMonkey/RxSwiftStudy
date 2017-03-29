//
//  ViewController.swift
//  RxSwiftMoya
//
//  Created by monkey on 2017/3/29.
//  Copyright © 2017年 Coder. All rights reserved.
//

import UIKit
import RxSwift
import Moya_ObjectMapper

class ViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserProvider
            .request(.list(0, 10))
            .mapResult(User.self)
            .subscribe{
                event in
                switch event{
                case .next(let users):
                    for user in users{
                        print("\(user.name)  \(user.age)")
                    }
                case .error(let error):
                    var message = "出错了!"
                    if let amerror = error as? AMError, let msg = amerror.message{
                        message = msg
                    }
                    print(message)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}


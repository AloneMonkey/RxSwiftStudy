//
//  LoginViewModel.swift
//  RxSwiftRegister
//
//  Created by monkey on 2017/3/26.
//  Copyright © 2017年 Coder. All rights reserved.
//

import RxSwift

class LoginViewModel {
    let validatedUsername: Observable<ValidationResult>
    let validatedPassword: Observable<ValidationResult>
    let validatedPasswordRepeated: Observable<ValidationResult>
    
    init(input:(
        username: Observable<String>,
        password: Observable<String>,
        repeatedPassword: Observable<String>,
        registerTap: Observable<Void>
        )){
        
        validatedUsername = input.username.map{
            username in
            return username == "" ? .empty : .ok(message: "验证通过")
        }.shareReplay(1)
        
        validatedPassword = input.password.map{
            password in
            return password == "" ? .empty : .ok(message: "验证通过")
        }.shareReplay(1)
        
        validatedPasswordRepeated = Observable.combineLatest(input.password, input.repeatedPassword){
            password, repeatedPassword in
            if repeatedPassword == ""{
                return .empty
            }
            
            if password != repeatedPassword{
                return .failed(message:"两次输入的密码不一致")
            }
            
            return .ok(message: "验证通过")
        }.shareReplay(1)
    }
}

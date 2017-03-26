//
//  LoginViewModel.swift
//  RxSwiftRegister
//
//  Created by monkey on 2017/3/26.
//  Copyright © 2017年 Coder. All rights reserved.
//

import RxSwift

class LoginViewModel {
    let validatedUsername: Observable<Bool>
    let validatedPassword: Observable<Bool>
    let validatedPasswordRepeated: Observable<Bool>
    
    init(input:(
        username: Observable<String>,
        password: Observable<String>,
        repeatedPassword: Observable<String>,
        registerTap: Observable<Void>
        )){
        
        validatedUsername = input.username.map{
            username in
            print(username)
            return username == "" ? false : true
        }.shareReplay(1)
        
        validatedPassword = input.password.map{
            password in
            return password == "" ? false : true
        }
        
        validatedPasswordRepeated = Observable.combineLatest(input.password, input.repeatedPassword){
            password, repeatedPassword in
            if repeatedPassword == ""{
                return false
            }
            
            if password != repeatedPassword{
                return false
            }
            
            return true
        }
    }
}

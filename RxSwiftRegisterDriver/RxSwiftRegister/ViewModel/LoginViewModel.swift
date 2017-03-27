//
//  LoginViewModel.swift
//  RxSwiftRegister
//
//  Created by monkey on 2017/3/26.
//  Copyright © 2017年 Coder. All rights reserved.
//

import RxSwift
import RxCocoa

class LoginViewModel {
    let validatedUsername: Driver<ValidationResult>
    let validatedPassword: Driver<ValidationResult>
    let validatedPasswordRepeated: Driver<ValidationResult>
    
    let registerEnabled: Driver<Bool>
    let registered: Driver<Bool>
    let registering: Driver<Bool>
    
    let registerTap = Variable<Void>()
    
    init(input:(
        username: Driver<String>,
        password: Driver<String>,
        repeatedPassword: Driver<String>,
        registerTap: Driver<Void>
        )){
        
        let API = GitHubAPI.sharedAPI
        let minPasswordCount = 5
        
        //flatMapLatest 如果有新的值发射出来，则会取消原来发出的网络请求
        //flatMap 则不会
        validatedUsername = input.username
            .flatMapLatest{
            username -> Driver<ValidationResult> in
            //是否为空
            if username.characters.count == 0{
                return Driver.just(.empty)
            }
            
            //是否是数字和字母
            if username.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil {
                return  Driver.just(.failed(message: "Username can only contain numbers or digits"))
            }
            
            let loadingValue = ValidationResult.validating
            
            return API.usernameAvailable(username)
                    .map{
                        available in
                        if available {
                            return .ok(message: "Username available")
                        }
                        else {
                            return .failed(message: "Username already taken")
                        }
                    }
                    .startWith(loadingValue)    //开始发射一个正在验证的值
                    .asDriver(onErrorJustReturn: .failed(message: "Error contacting server"))
        }
        
        validatedPassword = input.password.map{
            password in
            let numberOfCharacters = password.characters.count
            if numberOfCharacters == 0 {
                return .empty
            }
            
            if numberOfCharacters < minPasswordCount {
                return .failed(message: "Password must be at least \(minPasswordCount) characters")
            }
            
            return .ok(message: "Password acceptable")
        }
        
        validatedPasswordRepeated = Driver.combineLatest(input.password, input.repeatedPassword){
            password, repeatedPassword in
            if repeatedPassword.characters.count == 0 {
                return .empty
            }
            
            if repeatedPassword == password {
                return .ok(message: "Password repeated")
            }
            else {
                return .failed(message: "Password different")
            }
        }
        
        let registering = ActivityIndicator()
        
        self.registering = registering.asDriver()
        
        registerEnabled = Driver.combineLatest(validatedUsername, validatedPassword, validatedPasswordRepeated, self.registering){
            username, password, repeatedPassword, registering in
            username.isValid &&
            password.isValid &&
            repeatedPassword.isValid &&
            !registering
            }
            .distinctUntilChanged()
        
        let usernameAndPassword = Driver.combineLatest(input.username, input.password) { ($0, $1) }
        
        //合并注册点击和账号密码序列，每次注册点击，从第二个序列取最新的值
        registered = self.registerTap.asDriver().withLatestFrom(usernameAndPassword)
            .flatMapLatest{
                (username, password) in
                return API.register(username, password: password)
                        .trackActivity(registering)  //用于监控序列是计算中还是结束
                        .asDriver(onErrorJustReturn: false)
            }
    }
}

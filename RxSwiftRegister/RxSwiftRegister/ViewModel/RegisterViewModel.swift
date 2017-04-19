//
//  LoginViewModel.swift
//  RxSwiftRegister
//
//  Created by monkey on 2017/3/26.
//  Copyright © 2017年 Coder. All rights reserved.
//

import RxSwift

class RegisterViewModel {
    let validatedUsername: Observable<ValidationResult>
    let validatedPassword: Observable<ValidationResult>
    let validatedPasswordRepeated: Observable<ValidationResult>
    
    let registerEnabled: Observable<Bool>
    let registered: Observable<Bool>
    let registering: Observable<Bool>
    
    let registerTap = PublishSubject<Void>()
    
    init(input:(
        username: Observable<String>,
        password: Observable<String>,
        repeatedPassword: Observable<String>,
        registerTap: Observable<Void>
        )){
        
        let API = GitHubAPI.sharedAPI
        let minPasswordCount = 5
        
        //flatMapLatest 如果有新的值发射出来，则会取消原来发出的网络请求
        //flatMap 则不会
        validatedUsername = input.username
            .flatMapLatest{
            username -> Observable<ValidationResult> in
            //是否为空
            if username.characters.count == 0{
                return Observable.just(.empty)
            }
            
            //是否是数字和字母
            if username.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil {
                return  Observable.just(.failed(message: "Username can only contain numbers or digits"))
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
                    .observeOn(MainScheduler.instance)   //将监听事件绑定到主线程
                    .catchErrorJustReturn(.failed(message: "Error contacting server"))
        }.shareReplay(1)
        
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
        }.shareReplay(1)
        
        validatedPasswordRepeated = Observable.combineLatest(input.password, input.repeatedPassword){
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
        }.shareReplay(1)
        
        let registering = ActivityIndicator()
        
        self.registering = registering.asObservable()
        
        registerEnabled = Observable.combineLatest(validatedUsername, validatedPassword, validatedPasswordRepeated, self.registering){
            username, password, repeatedPassword, registering in
            username.isValid &&
            password.isValid &&
            repeatedPassword.isValid &&
            !registering
            }
            .distinctUntilChanged()
            .shareReplay(1)
        
        let usernameAndPassword = Observable.combineLatest(input.username, input.password) { ($0, $1) }
        
        //合并注册点击和账号密码序列，每次注册点击，从第二个序列取最新的值
        registered = self.registerTap.asObservable().withLatestFrom(usernameAndPassword)
            .flatMapLatest{
                (username, password) in
                return API.register(username, password: password)
                        .observeOn(MainScheduler.instance)
                        .catchErrorJustReturn(false)
                        .trackActivity(registering)  //用于监控序列是计算中还是结束
            }.shareReplay(1)
    }
}

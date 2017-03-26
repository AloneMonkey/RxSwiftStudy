//
//  ViewController.swift
//  RxSwiftRegister
//
//  Created by monkey on 2017/3/26.
//  Copyright © 2017年 Coder. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class LoginViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var usernameValidation: UILabel!
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordValidation: UILabel!
    
    @IBOutlet weak var repoatedPassword: UITextField!
    @IBOutlet weak var repeatedPasswordValidation: UILabel!
    
    @IBOutlet weak var registerIndicator: UIActivityIndicatorView!
    @IBOutlet weak var register: UIButton!
    
    let disposed = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewModel = LoginViewModel(input:(
            username: username.rx.text.orEmpty.asObservable(),
            password: password.rx.text.orEmpty.asObservable(),
            repeatedPassword: repoatedPassword.rx.text.orEmpty.asObservable(),
            registerTap: register.rx.tap.asObservable()
        ))
        
        viewModel.validatedUsername.subscribe(
            onNext:{
                valid in
                print("username is \(valid)")
            }
        ).disposed(by: disposed)
        
        viewModel.validatedUsername.subscribe(
            onNext:{
                valid in
                print("username 2 is \(valid)")
            }
        ).disposed(by: disposed)
        
        viewModel.validatedPassword.subscribe(
            onNext:{
                valid in
                print("password is \(valid)")
            }
        ).disposed(by: disposed)
        
        viewModel.validatedPasswordRepeated.subscribe(
            onNext:{
                valid in
                print("repoatedPassword is \(valid)")
            }
        ).disposed(by: disposed)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}


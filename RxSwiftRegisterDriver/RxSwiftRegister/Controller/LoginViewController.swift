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
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewModel = LoginViewModel(input:(
            username: username.rx.text.orEmpty.asDriver(),
            password: password.rx.text.orEmpty.asDriver(),
            repeatedPassword: repoatedPassword.rx.text.orEmpty.asDriver(),
            registerTap: register.rx.tap.asDriver()
        ))
        
        register.rx.tap.asDriver()
            .drive(viewModel.registerTap)
            .disposed(by: disposeBag)
        
        viewModel.validatedUsername
            .drive(usernameValidation.rx.validationResult)
            .disposed(by: disposeBag)
        
        viewModel.validatedPassword
            .drive(passwordValidation.rx.validationResult)
            .disposed(by: disposeBag)
        
        viewModel.validatedPasswordRepeated
            .drive(repeatedPasswordValidation.rx.validationResult)
            .disposed(by: disposeBag)
        
        viewModel.registerEnabled.drive(
            onNext:{
                [unowned self] valid in
                self.register.isEnabled = valid
                self.register.alpha = valid ? 1.0 : 0.5
            }
        ).disposed(by: disposeBag)
        
        viewModel.registering
            .drive(registerIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.registered.drive(
            onNext:{
                registered in
                print("User register is \(registered)")
            }
        ).disposed(by: disposeBag)
        
        //点击背景收起键盘
        let tapBackground = UITapGestureRecognizer()
        tapBackground.rx.event
            .subscribe(onNext: { [unowned self] _ in
                self.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        view.addGestureRecognizer(tapBackground)
        
        username.rx.controlEvent(.editingDidEnd)
            .subscribe{
                [unowned self] _ in
                self.password.becomeFirstResponder()
            }
            .disposed(by: disposeBag)
        
        password.rx.controlEvent(.editingDidEnd)
            .subscribe{
                [unowned self] _ in
                self.repoatedPassword.becomeFirstResponder()
            }
            .disposed(by: disposeBag)
        
        repoatedPassword.rx.controlEvent(.editingDidEnd)
            .bind(to: viewModel.registerTap)
            .disposed(by: disposeBag)
    }
    
    
}


//
//  ViewController.swift
//  RxSwiftAction
//
//  Created by monkey on 2017/4/8.
//  Copyright © 2017年 Coder. All rights reserved.
//

import UIKit
import Action
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var tap: UIButton!
    @IBOutlet weak var login: UIButton!
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let items = Observable.just(
            (0...20).map{ "\($0)" }
        )
        
        items.bindTo(tableview.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)){
            (row, elememt, cell) in
            
            let title = cell.viewWithTag(100) as! UILabel
            
            title.text = elememt
            
            var button = cell.viewWithTag(101) as! UIButton
            
            button.rx.action = CocoaAction {
                print("to do something \(elememt)")
                return .empty()
            }
            
        }.disposed(by: disposeBag)
        
        let buttonAction: Action<Void, Void> = Action {
            print("Doing some work")
            return Observable.empty()
        }
        
        let loginAction: Action<(String,String), Bool> = Action{
            (username, password) in
            print("\(username) \(password)")
            return Observable.just(true)
        }
        
        loginAction.execute(("admin","password"))
            .subscribe{
                print($0)
            }
            .disposed(by: disposeBag)
        
        tap.rx.action = buttonAction
        
        let usernameCount = username.rx.text
            .orEmpty
            .asObservable()
            .map{
                $0.characters.count > 6
            }
        
        let validateUsername:Action<String, Bool> = Action(enabledIf: usernameCount, workFactory: { input in
            print("username validating.....")
            return Observable.just(true)
        })
        
        username.rx.controlEvent(.editingDidEnd)
            .subscribe(
                onNext:{
                    [unowned self] _ in
                    validateUsername.execute(self.username.text ?? "")
                }
            )
            .disposed(by: disposeBag)
        
        validateUsername.elements
            .observeOn(MainScheduler.instance)
            .subscribe{
                [unowned self] _ in
                print("username validate ok")
                let alertController = UIAlertController(title: "validate", message: "username validate is ok!", preferredStyle: .alert)
                var ok = UIAlertAction.Action("OK", style: .default)
                ok.rx.action = CocoaAction {
                    print("Alert's OK button was pressed")
                    return .empty()
                }
                alertController.addAction(ok)
                self.present(alertController, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
        let usernameAndPassword = Observable.combineLatest(username.rx.text.orEmpty, password.rx.text.orEmpty)
        
        login.rx.tap.asObservable()
            .withLatestFrom(usernameAndPassword)
            .bindTo(loginAction.inputs)
            .disposed(by: disposeBag)
        
        loginAction.elements
            .filter{ $0 }
            .subscribe(
                onNext:{
                    _ in
                    print("login ok!")
                }
            )
            .disposed(by: disposeBag)
        
        loginAction.errors
            .subscribe(
                onError:{
                    error in
                    print("error")
                }
            )
            .disposed(by: disposeBag)
    }
}


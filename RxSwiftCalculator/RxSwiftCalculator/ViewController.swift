//
//  ViewController.swift
//  RxSwiftCalculator
//
//  Created by monkey on 2017/3/25.
//  Copyright © 2017年 Coder. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var numberOne: UITextField!
    @IBOutlet weak var numberTwo: UITextField!
    @IBOutlet weak var numberThree: UITextField!
    @IBOutlet weak var result: UILabel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberOne.rx.text.orEmpty.asObservable()
            .filter{
                return $0 != ""
            }
            .subscribe{
            print($0)
        }.disposed(by: disposeBag)
        
        Observable.combineLatest(numberOne.rx.text.orEmpty,numberTwo.rx.text.orEmpty,numberThree.rx.text.orEmpty) { (numberOneText, numberTwoText, numberThreeText) -> Int in
                return (Int(numberOneText) ?? 0) + (Int(numberTwoText) ?? 0) + (Int(numberThreeText) ?? 0)
            }.map{
                $0.description
            }.bindTo(result.rx.text)
            .disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}


//
//  ViewController.swift
//  RxSwiftTwoWayBinding
//
//  Created by monkey on 2017/3/30.
//  Copyright © 2017年 Coder. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension UILabel {
    public var rx_text: ControlProperty<String> {
        // 观察text
        let source: Observable<String> = self.rx.observe(String.self, "text").map { $0 ?? "" }
        let setter: (UILabel, String) -> Void = { $0.text = $1 }
        let bindingObserver = UIBindingObserver(UIElement: self, binding: setter)
        return ControlProperty<String>(values: source, valueSink: bindingObserver)
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textview: UITextView!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let text = Variable("双向绑定")
        
        _  = textfield.rx.textInput <-> text
        
        textfield.rx.text
            .asObservable()
            .subscribe{
                print("textfield: \($0)")
            }
            .disposed(by: disposeBag)
        
        textfield.text = "这是我修改的值"
        
        label.rx_text
            .asObservable()
            .subscribe{
                print("label:\($0)")
            }
            .disposed(by: disposeBag)
        
        label.text = "修改label"
        
        textview.rx.text
            .asObservable()
            .subscribe{
                print("textview: \($0)")
            }
            .disposed(by: disposeBag)
        
        textview.text = "这是我修改的值"
    }
}


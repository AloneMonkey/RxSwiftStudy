//
//  ViewController.swift
//  RxSwiftSimpleTableView
//
//  Created by monkey on 2017/3/28.
//  Copyright © 2017年 Coder. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let items = Observable.just(
            (0...20).map{ "\($0)" }
        )
        
        items
            .bindTo(tableview.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)){
                (row, elememt, cell) in
                cell.textLabel?.text = "\(elememt) @row \(row)"
            }.disposed(by: disposeBag)
        
        tableview.rx
            .modelSelected(String.self)
            .subscribe(
                onNext:{
                    value in
                    print("click \(value)")
                }
            )
            .disposed(by: disposeBag)
    }
}


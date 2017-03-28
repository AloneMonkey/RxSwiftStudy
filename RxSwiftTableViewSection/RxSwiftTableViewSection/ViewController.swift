//
//  ViewController.swift
//  RxSwiftTableViewSection
//
//  Created by monkey on 2017/3/28.
//  Copyright © 2017年 Coder. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Double>>()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataSource = self.dataSource
        
        let items = Observable.just([
            SectionModel(model: "First", items:[
                    1.0,
                    2.0,
                    3.0
                ]),
            SectionModel(model: "Second", items:[
                1.0,
                2.0,
                3.0
                ]),
            SectionModel(model: "Third", items:[
                1.0,
                2.0,
                3.0
                ])
            ])
        
        dataSource.configureCell = {
            (_, tv, indexPath, element) in
            let cell = tv.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(element) @ row \(indexPath.row)"
            return cell
        }
        
        dataSource.titleForHeaderInSection = { dataSource, sectionIndex in
            return dataSource[sectionIndex].model
        }
        
        items
            .bindTo(tableview.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableview.rx
            .itemSelected
            .map { indexPath in
                return (indexPath, dataSource[indexPath])
            }
            .subscribe(onNext: { indexPath, model in
                print("Tapped `\(model)` @ \(indexPath)")
            })
            .disposed(by: disposeBag)
        
        tableview.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension ViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}


//
//  ViewController.swift
//  RxSwiftSearch
//
//  Created by monkey on 2017/4/5.
//  Copyright © 2017年 Coder. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ViewController: UIViewController {
    
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var tableview: UITableView!
    
    let disposeBag = DisposeBag()
    
    //mock数据
    var shownCities = [String]() // Data source for UITableView
    
    let allCities = ["ChangSha",
                     "HangZhou",
                     "ShangHai",
                     "BeiJing",
                     "ShenZhen",
                     "New York",
                     "London",
                     "Oslo",
                     "Warsaw",
                     "Berlin",
                     "Praga"] // Our mocked API data source

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //数据源
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, String>>()

        dataSource.configureCell = {
            (_, tv, indexPath, element) in
            let cell = tv.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(element)"
            return cell
        }
        
        //获取输入
        let searchResult = searchbar.rx
                                .text
                                .orEmpty
                                .debounce(0.5, scheduler: MainScheduler.instance)
                                .distinctUntilChanged()
                                .filter{ !$0.isEmpty }
                                .flatMapLatest{
                                    [unowned self] query -> Observable<[String]> in
                                    print("\(query)")
                                    return Observable.just(self.allCities.filter{ $0.hasPrefix(query)})
                                }
                                .shareReplay(1)
        
        searchResult
            .map{ [SectionModel(model:"",items:$0)] }
            .bindTo(tableview.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableview.rx
            .modelSelected(String.self)
            .subscribe(
                onNext:{
                    value in
                    if let selectedRowIndexPath = self.tableview.indexPathForSelectedRow {
                        self.tableview.deselectRow(at: selectedRowIndexPath, animated: true)
                    }
            }
            )
            .disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


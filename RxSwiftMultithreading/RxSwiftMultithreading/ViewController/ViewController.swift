//
//  ViewController.swift
//  RxSwiftMultithreading
//
//  Created by monkey on 2017/4/6.
//  Copyright © 2017年 Coder. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class ViewController: UIViewController {

    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var tableview: UITableView!
    
    let disposeBag = DisposeBag()
    var searchViewModel:SearchViewModel!
    
    var rx_searchBarText: Observable<String> {
        return searchbar
            .rx.text
            .orEmpty
            .filter { $0.characters.count > 0 } // notice the filter new line
            .throttle(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchViewModel = SearchViewModel(searchText: rx_searchBarText)
        
        searchViewModel
            .rx_repositories
            .drive(tableview.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, repository, cell) in
                cell.textLabel?.text = repository.name
            }
            .disposed(by: disposeBag)
        
        searchViewModel
            .rx_repositories
            .drive(
                onNext: {
                    repositories in
                    if repositories.count == 0 {
                        let alert = UIAlertController(title: "sorry!", message: "No repositories for this user.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        if self.navigationController?.visibleViewController?.isMember(of: UIAlertController.self) != true {
                            self.present(alert, animated: true, completion: nil)
                        }
                    }

                }
            )
            .disposed(by: disposeBag)
    }
}


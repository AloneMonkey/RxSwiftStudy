//
//  ViewController.swift
//  RxSwiftResult
//
//  Created by monkey on 2017/3/29.
//  Copyright © 2017年 Coder. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxSwiftExt

struct SampleError: Swift.Error {}

enum Result<T>{
    case success(T)
    case failure(Swift.Error)
}

extension Result {
    func filterValue() -> Observable<T> {
        switch self {
        case .success(let value):
            return Observable.just(value)
        case .failure(_):
            return Observable.empty()
        }
    }
    
    func filterError() -> Observable<Swift.Error> {
        switch self {
        case .success(_):
            return Observable.empty()
        case .failure(let error):
            return Observable.just(error)
        }
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var success: UIButton!
    @IBOutlet weak var failure: UIButton!
    
    
    @IBOutlet weak var successCount: UILabel!
    @IBOutlet weak var failureCount: UILabel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testThree()
    }
    
    func testOne(){
        let successCount = Observable
            .of(success.rx.tap.map { true }, failure.rx.tap.map { false })
            .merge()
            .flatMap {
                [unowned self] performWithSuccess in
                return self.performAPICall(shouldEndWithSuccess: performWithSuccess)
            }.scan(0) { accumulator, _ in
                return accumulator + 1
            }.map { "\($0)" }
        
        successCount.bindTo(self.successCount.rx.text)
            .disposed(by: disposeBag)
        
        successCount.subscribe(
            onDisposed:{
                print("dispose")
            }
        ).disposed(by: disposeBag)
    }
    
    func testTwo(){
        let successCount = Observable
            .of(success.rx.tap.map { true }, failure.rx.tap.map { false })
            .merge()
            .flatMap {
                [unowned self] performWithSuccess in
                return self.performAPICall2(shouldEndWithSuccess: performWithSuccess)
            }
        
        successCount
            .flatMap{
                $0.filterValue()
            }
            .scan(0) { accumulator, _ in
                return accumulator + 1
            }
            .map { "\($0)" }
            .bindTo(self.successCount.rx.text)
            .disposed(by: disposeBag)
        
        successCount
            .flatMap{
                $0.filterError()
            }
            .scan(0) { accumulator, _ in
                return accumulator + 1
            }
            .map { "\($0)" }
            .bindTo(self.failureCount.rx.text)
            .disposed(by: disposeBag)
        
        successCount.subscribe(
            onDisposed:{
                print("dispose")
            }
        ).disposed(by: disposeBag)
    }
    
    func testThree(){
        let result = Observable
            .of(success.rx.tap.map { true }, failure.rx.tap.map { false })
            .merge()
            .flatMap { [unowned self] performWithSuccess in
                return self.performAPICall(shouldEndWithSuccess: performWithSuccess)
                    .materialize()
        }.share()
        
        result.elements()
            .scan(0) { accumulator, _ in
                return accumulator + 1
            }.map { "\($0)" }
            .bindTo(successCount.rx.text)
            .disposed(by: disposeBag)
        
        result.errors()
            .scan(0) { accumulator, _ in
                return accumulator + 1
            }.map { "\($0)" }
            .bindTo(failureCount.rx.text)
            .disposed(by: disposeBag)
        
        result.subscribe(
            onDisposed:{
                print("dispose")
            }
        ).disposed(by: disposeBag)
    }

    private func performAPICall(shouldEndWithSuccess: Bool) -> Observable<Void> {
        print("123")
        if shouldEndWithSuccess {
            return .just(())
        } else {
            return .error(SampleError())
        }
    }
    
    private func performAPICall2(shouldEndWithSuccess: Bool) -> Observable<Result<Void>> {
        if shouldEndWithSuccess {
            return .just(Result.success())
        } else {
            return .just(Result.failure(SampleError()))
        }
    }
}


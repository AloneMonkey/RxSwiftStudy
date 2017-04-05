//
//  ViewController.swift
//  RxSwiftShareOrReplay
//
//  Created by monkey on 2017/3/31.
//  Copyright © 2017年 Coder. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

func delay(_ delay: Double, closure: @escaping (Void) -> Void) {
    
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        closure()
    }
}

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    var results:Observable<String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //模拟用户不断输出的文本
        results = Observable<Int>
                    .interval(1, scheduler: MainScheduler.instance)
                    .map{
                        "\($0)"
                    }
                    .flatMapLatest{
                        query in
                        self.request(query)
                    }
        
        //unexcepted()
        //publish()
        //replayAll()
        //replay()
        //share()
        //shareReplay()
        shareReplayLatestWhileConnected()
    }
    
    //模拟网络请求操作
    func request(_ query:String) -> Observable<String>{
        return Observable.create{
            observer in
            print("搜索 \(query)  发送网络请求")
            observer.onNext("\(query) 请求成功!")
            return Disposables.create {
                
            }
        }
    }
    
    func unexcepted(){
        results.subscribe{
                print("订阅者 one: \($0)")
            }.disposed(by: disposeBag)
        
        results.subscribe{
                print("订阅者 two: \($0)")
            }.disposed(by: self.disposeBag)
    }
    
    func publish(){
        let results = self.results.publish()
        
        results.subscribe{
                print("订阅者 one: \($0)")
            }.disposed(by: disposeBag)
        
        results.subscribe{
                print("订阅者 two: \($0)")
            }.disposed(by: disposeBag)
        
        _ = results.connect()
        
        delay(4){
            print("three 订阅")
            results.subscribe{
                print("订阅者 three: \($0)")
            }.disposed(by: self.disposeBag)
        }
    }
    
    func replayAll(){
        
        let results = self.results.replayAll()
        
        results.subscribe{
            print("订阅者 one: \($0)")
            }.disposed(by: disposeBag)
        
        results.subscribe{
            print("订阅者 two: \($0)")
            }.disposed(by: disposeBag)
        
        _ = results.connect()
        
        delay(4){
            print("three 订阅")
            results.subscribe{
                print("订阅者 three: \($0)")
            }.disposed(by: self.disposeBag)
        }
    }
    
    func replay(){
        let results = self.results.replay(2)
        
        results.subscribe{
            print("订阅者 one: \($0)")
            }.disposed(by: disposeBag)
        
        results.subscribe{
            print("订阅者 two: \($0)")
            }.disposed(by: disposeBag)
        
        _ = results.connect()
        
        delay(4){
            print("three 订阅")
            results.subscribe{
                print("订阅者 three: \($0)")
            }.disposed(by: self.disposeBag)
        }
    }
    
    func share(){
        let results = self.results.share()
        
        let sub = results.subscribe{
            
                print("订阅者 one: \($0)")
            }
        
        delay(4){
            //订阅者从1变成0
            //可被观察序列重新发射
            print("订阅者 one被销毁")
            
            sub.dispose()
            
            results.subscribe{
                print("订阅者 two: \($0)")
            }.disposed(by: self.disposeBag)
        }
    }
    
    func shareReplay(){
        let results = self.results.shareReplay(2)
        
        let sub1 = results.subscribe{
            print("订阅者 one: \($0)")
            }
        
        let sub2 = results.subscribe{
            print("订阅者 two: \($0)")
            }
        
        delay(4){
            sub1.dispose()
            sub2.dispose()
            
            print("three 订阅")
            results.subscribe{
                print("订阅者 three: \($0)")
            }.disposed(by: self.disposeBag)
        }
    }
    
    func shareReplayLatestWhileConnected(){
        let results = self.results.shareReplayLatestWhileConnected() // test  shareReplay(1)
        
        let sub = results.subscribe{
                    print("订阅者 one: \($0)")
                }
        
        delay(4){
            sub.dispose()
            //订阅者从1变成0， 缓存的一个值被清掉了，所以不会收到最后一个值
            print("two 订阅")
            results.subscribe{
                print("订阅者 two: \($0)")
            }.disposed(by: self.disposeBag)
        }
    }
}


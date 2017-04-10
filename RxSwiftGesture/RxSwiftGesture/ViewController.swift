//
//  ViewController.swift
//  RxSwiftGesture
//
//  Created by monkey on 2017/4/10.
//  Copyright © 2017年 Coder. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class ViewController: UIViewController {

    @IBOutlet weak var tapView: UIView!
    
    @IBOutlet weak var label: UILabel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        //点击
        tapView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(
                onNext:{
                    _ in
                    print("tapped!!!")
                }
            )
            .disposed(by: disposeBag)
        
        //双击
        tapView.rx
            .tapGesture(numberOfTapsRequired: 2)
            .when(.recognized)
            .subscribe(
                onNext:{
                    _ in
                    print("double tapped!!!")
                }
            )
            .disposed(by: disposeBag)
        
        //下划
        tapView.rx
            .swipeGesture(.down)
            .when(.recognized)
            .subscribe(
                onNext:{
                    _ in
                    print("swipe down!!!")
                }
            )
            .disposed(by: disposeBag)
        
        //水平划动
        tapView.rx
            .swipeGesture([.left, .right])
            .when(.recognized)
            .subscribe(
                onNext:{
                    _ in
                    print("swipe left or right!!!")
                }
            )
            .disposed(by: disposeBag)
        
        //长按
        tapView.rx
            .longPressGesture()
            .when(.began)
            .subscribe(
                onNext:{
                    _ in
                    print("long press")
                }
            )
            .disposed(by: disposeBag)
        
        //拖动
        let panGesture = tapView.rx.panGesture().shareReplay(1)
        
        panGesture
            .when(.changed)
            .asTranslation()
            .subscribe(
                onNext: {
                    [unowned self] translation, _ in
                    self.label.text = String(format: "(%.2f, %.2f)",translation.x, translation.y)
                    self.tapView.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
                }
            )
            .disposed(by: disposeBag)
        
        panGesture
            .when(.ended)
            .subscribe(
                onNext: { _ in
                    print("panGesture end")
                }
            )
            .disposed(by: disposeBag)
        
        //旋转
        let rotationGesture = tapView.rx.rotationGesture().shareReplay(1)
        
        rotationGesture
            .when(.changed)
            .asRotation()
            .subscribe(
                onNext: {
                    [unowned self] rotation, _ in
                    self.label.text = String(format: "%.2f rad", rotation)
                    self.tapView.transform = CGAffineTransform(rotationAngle: rotation)
                }
            )
            .disposed(by: disposeBag)
        
        rotationGesture
            .when(.ended)
            .subscribe(
                onNext: { _ in
                    print("rotationGesture end")
                }
            )
            .disposed(by: disposeBag)
        
        //缩放
        let pinchGesture = view.rx.pinchGesture().shareReplay(1)
        
        pinchGesture
            .when(.changed)
            .asScale()
            .subscribe(
                onNext: {
                    [unowned self] scale, _ in
                    self.label.text = String(format: "x%.2f", scale)
                    self.tapView.transform = CGAffineTransform(scaleX: scale, y: scale)
                }
            )
            .disposed(by: disposeBag)
        
        pinchGesture
            .when(.ended)
            .subscribe(
                onNext: { _ in
                    print("pinchGesture end")
                }
            )
            .disposed(by: disposeBag)
        */
        
        //变换
        /*
        let transformGestures = view.rx.transformGestures().shareReplay(1)
        
        transformGestures
            .when(.changed)
            .asTransform()
            .subscribe(
                onNext: {
                    [unowned self] transform, _ in
                    self.label.numberOfLines = 3
                    self.label.text = String(format: "[%.2f, %.2f,\n%.2f, %.2f,\n%.2f, %.2f]", transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty)
                    self.tapView.transform = transform
                }
            )
            .disposed(by: disposeBag)
        
        transformGestures
            .when(.ended)
            .subscribe(
                onNext: {
                    [unowned self] _ in
                    self.label.numberOfLines = 1
                    print("transformGestures end")
                }
            )
            .disposed(by: disposeBag)
        */
        
        view.rx
            .screenEdgePanGesture(edges: .right)
            .when(.recognized)
            .subscribe(
                onNext: {
                    _ in
                    print("right edge")
                }
            )
            .disposed(by: disposeBag)
        
        tapView.rx
            .anyGesture(.tap(), .swipe([.up, .down]))
            .when(.recognized)
            .subscribe(
                onNext: {
                    _ in
                    print("tap or up down")
                }
            ).disposed(by: disposeBag)
        
        tapView.rx
            .anyGesture(
                (.tap(), when: .recognized),
                (.pan(), when: .ended)
            )
            .subscribe(onNext: { gesture in
                // Called whenever:
                // - a tap is recognized (state == .recognized)
                // - or a pan is ended (state == .ended)
                print("tap is recognized or pan is ended")
            })
            .disposed(by: disposeBag)
    }
}


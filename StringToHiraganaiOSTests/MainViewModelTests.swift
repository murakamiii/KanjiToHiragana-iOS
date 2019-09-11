//
//  StringToHiraganaiOSTests.swift
//  StringToHiraganaiOSTests
//
//  Created by murakami Taichi on 2019/09/09.
//  Copyright © 2019 murakammm. All rights reserved.
//

import XCTest
import RxSwift
import RxTest

@testable import StringToHiraganaiOS

class MainViewModelTests: XCTestCase {
    let bag = DisposeBag()

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_converted() {
        let scheduler = TestScheduler(initialClock: 0)
        
        let textInput = scheduler.createColdObservable([
            Recorded.next(10, "テスト文章"),
            Recorded.next(20, "テスト文章その2")
        ]).asObservable()
        let buttonTap = scheduler.createColdObservable([
            Recorded.next(15, ()),
            Recorded.next(25, ())
        ]).asObservable()
        
        let vm = MainViewModel(textInput: textInput,
                               buttonEvent: buttonTap,
                               service: MockTranslateService(suffix: "suffix"))
        
        let conv = scheduler.createObserver(String.self)
        vm.converted
            .subscribe(conv)
            .disposed(by: bag)
        
        scheduler.start()
        XCTAssertEqual(conv.events, [.next(15, "テスト文章suffix"), .next(25, "テスト文章その2suffix")])
    }
    
    func test_error() {
        let scheduler = TestScheduler(initialClock: 0)
        
        let textInput = scheduler.createColdObservable([
            Recorded.next(10, "テスト文章")
            ]).asObservable()
        let buttonTap = scheduler.createColdObservable([
            Recorded.next(15, ())
            ]).asObservable()
        
        let vm = MainViewModel(textInput: textInput,
                               buttonEvent: buttonTap,
                               service: ErrorMockTranslateService(error: .server(info: .init(error: .init(code: 500,
                                                                                                          message: "Server Error.")))))
        
        let err = scheduler.createObserver(APIError.self)
        vm.error
            .subscribe(err)
            .disposed(by: bag)
        
        scheduler.start()
        XCTAssertEqual(err.events, [
            .next(15, APIError.server(info: .init(error: .init(code: 500,
                                                               message: "Server Error."))))
        ])
    }
    
    func test_isLoading() {
        let scheduler = TestScheduler(initialClock: 0)
        
        let textInput = scheduler.createColdObservable([
            Recorded.next(10, "テスト文章"),
            Recorded.next(20, "テスト文章その2")
            ]).asObservable()
        let buttonTap = scheduler.createColdObservable([
            Recorded.next(15, ()),
            Recorded.next(25, ())
            ]).asObservable()
        
        let vm = MainViewModel(textInput: textInput,
                               buttonEvent: buttonTap,
                               service: MockTranslateService(suffix: "suffix"))
        
        let isLoad = scheduler.createObserver(Bool.self)
        vm.isLoading
            .subscribe(isLoad)
            .disposed(by: bag)
        
        scheduler.start()
        XCTAssertEqual(isLoad.events, [.next(0, false)])
    }
}

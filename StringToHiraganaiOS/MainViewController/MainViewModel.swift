//
//  MainViewModel.swift
//  StringToHiraganaiOS
//
//  Created by murakami Taichi on 2019/09/11.
//  Copyright © 2019 murakammm. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MainViewModel {
    let error: Observable<APIError>
    let converted: Observable<String>
    let isLoading: BehaviorRelay<Bool>
    
    init(textInput: Observable<String>, buttonEvent: Observable<Void>, service: TranslateServiceProtocol) {
        let load = BehaviorRelay<Bool>(value: false)
        
        let res = buttonEvent.withLatestFrom(textInput)
            .do(onNext: { _ in
                load.accept(true)
            })
            .flatMapLatest {
                service.translate(sentence: $0)
                    .materialize()
            }
            .do(onNext: { _ in
                load.accept(false)
            })
            .share(replay: 1)
        
        converted = res.elements()
        error = res.errors()
            .map { $0 as? APIError ?? APIError.unknown(error: $0) }
        isLoading = load
    }
}

fileprivate extension ObservableType where Element: EventConvertible {
    func errors() -> Observable<Error> {
        return filter { $0.event.error != nil }.map { $0.event.error! }
    }
    
    func elements() -> Observable<Element.Element> {
        return filter { $0.event.element != nil }.map { $0.event.element! }
    }
}

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
    
    init(textInput: Observable<String>, buttonEvent: Observable<Void>, service: TranslateServiceProtocol) {
        let res = buttonEvent.withLatestFrom(textInput).flatMapLatest {
            service.translate(sentence: $0)
        }.materialize().share(replay: 1)
        
        converted = res.elements()
        error = res.errors()
            .map { $0 as? APIError ?? APIError.unknown(error: $0) }
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

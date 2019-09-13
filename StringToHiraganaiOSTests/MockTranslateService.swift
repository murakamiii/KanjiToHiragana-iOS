//
//  MockTranslateService.swift
//  StringToHiraganaiOSTests
//
//  Created by murakami Taichi on 2019/09/13.
//  Copyright © 2019 murakammm. All rights reserved.
//

import Foundation
import RxSwift

@testable import StringToHiraganaiOS

class MockTranslateService: TranslateServiceProtocol {
    let mockSuffix: String
    init(suffix: String) {
        mockSuffix = suffix
    }
    
    func translate(sentence: String) -> Observable<String> {
        return Observable.of(sentence + mockSuffix)
    }
}

class ErrorMockTranslateService: TranslateServiceProtocol {
    let mockErr: APIError
    init(error: APIError) {
        mockErr = error
    }
    
    func translate(sentence: String) -> Observable<String> {
        return Observable.error(mockErr)
    }
}

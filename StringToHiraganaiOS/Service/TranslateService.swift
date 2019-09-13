//
//  TranslateService.swift
//  StringToHiraganaiOS
//
//  Created by murakami Taichi on 2019/09/10.
//  Copyright © 2019 murakammm. All rights reserved.
//

import Foundation
import RxSwift

protocol TranslateServiceProtocol {
    func translate(sentence: String) -> Observable<String>
}

class TranslateService: TranslateServiceProtocol {
    func translate(sentence: String) -> Observable<String> {
        let url = URL(string: Bundle.main.object(forInfoDictionaryKey: "hiragana_url") as! String)!
        
        return GooAPI(url: url)?
            .transrate(sentence: sentence, outputType: .hiragana)
            .map { $0.converted.replacingOccurrences(of: " ", with: "") } ?? Observable.of("")
    }
}

//
//  ResultViewController.swift
//  StringToHiraganaiOS
//
//  Created by murakami Taichi on 2019/09/11.
//  Copyright © 2019 murakammm. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ResultViewController: UIViewController {
    @IBOutlet private weak var resultTextView: UITextView!
    @IBOutlet private weak var backButton: BorderedButton!

    var convertedText: String!
    let disposeBag = DisposeBag()
    
    static func make(converted: String) -> ResultViewController {
        let storyboard = UIStoryboard(name: "Result", bundle: .main)
        let vc = storyboard.instantiateInitialViewController() as! ResultViewController
        vc.convertedText = converted
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        resultTextView.text = convertedText
        backButton.rx.tap.subscribe(onNext: { _ in
            self.dismiss(animated: true, completion: nil)
        })
        .disposed(by: disposeBag)
    }
}

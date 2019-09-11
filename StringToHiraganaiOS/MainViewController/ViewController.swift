//
//  ViewController.swift
//  StringToHiraganaiOS
//
//  Created by murakami Taichi on 2019/09/09.
//  Copyright © 2019 murakammm. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PKHUD

class ViewController: UIViewController {
    @IBOutlet private weak var inputTextView: UITextView!
    @IBOutlet private weak var translateButton: UIButton!
    
    var viewModel: MainViewModel!
    let disposebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bindUI()
    }
    
    private func bindUI() {
        let input = inputTextView.rx
            .text
            .orEmpty
            .asObservable()
        let tapEvent = translateButton.rx.tap.asObservable()
        
        let vm = MainViewModel(textInput: input, buttonEvent: tapEvent, service: TranslateService())
        
        vm.converted.asObservable().subscribe(onNext: { str in
            DispatchQueue.main.async {
                self.showResultVC(converted: str)
            }
        })
        .disposed(by: disposebag)
        
        vm.error.subscribe(onNext: { err in
            self.showAlert(error: err)
        })
        .disposed(by: disposebag)
        
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        vm.isLoading.subscribe(onNext: { isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    PKHUD.sharedHUD.show()
                } else {
                    PKHUD.sharedHUD.hide()
                }
            }
        })
        .disposed(by: disposebag)
        
        viewModel = vm
    }
    
    private func showResultVC(converted: String) {
        let vc = ResultViewController.make(converted: converted)
        self.present(vc, animated: true, completion: nil)
    }
    
    private func showAlert(error: APIError) {
        let alert = UIAlertController(title: "エラー", message: error.message(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

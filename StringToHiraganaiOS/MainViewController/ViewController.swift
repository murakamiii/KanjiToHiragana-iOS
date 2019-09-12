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
    @IBOutlet private weak var translateButton: BorderedButton!
    @IBOutlet private weak var btnBottomConstraint: NSLayoutConstraint!
    let btnBottomDefaultValue: CGFloat = 64.0

    var viewModel: MainViewModel!
    let disposebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindUI()
    }
    
    private func setupUI() {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillShowNotification)
            .subscribe(onNext: {[weak self] notif in
                if let self = self,
                    let frame = notif.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                    self.btnBottomConstraint.constant = self.btnBottomDefaultValue + frame.cgRectValue.height
                }
            })
            .disposed(by: disposebag)
        
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillHideNotification)
            .subscribe(onNext: {[weak self] _ in
                if let self = self {
                    self.btnBottomConstraint.constant = self.btnBottomDefaultValue
                }
            })
            .disposed(by: disposebag)
    }
    
    private func bindUI() {
        let textInput = inputTextView.rx.text.orEmpty.asObservable()
        let tapEvent = translateButton.rx.tap.asObservable()
            .do(onNext: { _ in
                _ = self.view.endEditing(true)
            })
        
        let vm = MainViewModel(textInput: textInput, buttonEvent: tapEvent, service: TranslateService())
        
        vm.converted.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { str in
                self.showResultVC(converted: str)
            })
            .disposed(by: disposebag)
        
        vm.error
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { err in
                self.showAlert(error: err)
            })
            .disposed(by: disposebag)
        
        vm.isLoading
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { isLoading in
                isLoading ? PKHUD.sharedHUD.show() : PKHUD.sharedHUD.hide()
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

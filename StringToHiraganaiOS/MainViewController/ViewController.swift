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
    private let btnBottomDefaultValue: CGFloat = 64.0

    private lazy var viewModel: MainViewModel = bindedViewModel()
    private let disposebag = DisposeBag()
    
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
    
    private func bindedViewModel() -> MainViewModel {
        let textInput = inputTextView.rx.text.orEmpty.asObservable().share(replay: 1)
        let tapEvent = translateButton.rx.tap.asObservable()
            .do(onNext: { _ in
                _ = self.view.endEditing(true)
            })
        
        textInput.map { !$0.isEmpty }
            .bind(to: translateButton.rx.isEnabled)
            .disposed(by: disposebag)
        
        return MainViewModel(textInput: textInput, buttonEvent: tapEvent, service: TranslateService())
    }
    
    private func bindUI() {
        viewModel.converted.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { str in
                self.showResultVC(converted: str)
            })
            .disposed(by: disposebag)
        
        viewModel.error
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { err in
                self.showAlert(error: err)
            })
            .disposed(by: disposebag)
        
        viewModel.isLoading
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { isLoading in
                isLoading ? PKHUD.sharedHUD.show() : PKHUD.sharedHUD.hide()
            })
            .disposed(by: disposebag)
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

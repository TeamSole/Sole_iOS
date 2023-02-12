//
//  SignUpFirstStepViewController.swift
//  SoleApp
//
//  Created by SUN on 2023/02/10.
//

import UIKit
import SwiftUI
import SnapKit

final class SignUpFirstStepViewController: UIViewController {
    
    @ObservedObject var viewModel: SignUpFirstStepViewModel = SignUpFirstStepViewModel()
    
    private let greetingLabel: UILabel = {
        let label = UILabel()
        label.text = "안녕하세요.\n지도 위의 발자국, SOLE입니다."
        label.font = .pretendardRegular(size: 18.0)
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    private let askAgreeTermsLabel: UILabel = {
        let label = UILabel()
        label.text = "회원가입을 위해 약관에 동의해주세요."
        label.font = .pretendardMedium(size: 18.0)
        label.textColor = .black
        return label
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .gray_F2F2F2
        return view
    }()
    
    private lazy var allCheckButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "radio_button_unchecked"), for: .normal)
        button.setImage(UIImage(named: "check_circle"), for: .selected)
        button.setTitle("약관 전체 동의", for: .normal)
        button.setTitle("약관 전체 동의", for: .selected)
        button.setTitleColor(.black, for: .selected)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .pretendardBold(size: 16.0)
        button.contentHorizontalAlignment = .leading
        button.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 6.0, bottom: 0.0, right: 0.0)
        button.adjustsImageWhenHighlighted = false
        return button
    }()
    
    private lazy var firstCheckBoxView: CheckBoxView = CheckBoxView(isSelected: self.$viewModel.isSelectedFirstTerm,
                                                               title: "서비스 이용약관 동의 (필수)",
                                                                    didTapArrowButton: { self.allCheckButton.isSelected = false})
    
    private lazy var secondCheckBoxView: CheckBoxView = CheckBoxView(isSelected: self.$viewModel.isSelectedSecondTerm,
                                                               title: "개인정보 처리방침 동의 (필수)",
                                                               didTapArrowButton: {})
    
    private lazy var thirdCheckBoxView: CheckBoxView = CheckBoxView(isSelected: self.$viewModel.isSelectedThirdTerm,
                                                               title: "마케팅 정보 제공 및 수신 동의 (선택)",
                                                               didTapArrowButton: {})
    private lazy var continueLabel: UILabel = {
        let label = UILabel()
        label.text = "동의하고 계속하기"
//        label.
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationUI(title: "회원가입")
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        [greetingLabel,
         askAgreeTermsLabel,
         allCheckButton,
         divider,
         firstCheckBoxView,
         secondCheckBoxView,
         thirdCheckBoxView].forEach({ view.addSubview($0) })
        let horizontalInset: CGFloat = 16.0
        
        greetingLabel.snp.makeConstraints({
            $0.horizontalEdges.equalToSuperview().inset(horizontalInset)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(30.0)
        })
        
        askAgreeTermsLabel.snp.makeConstraints({
            $0.horizontalEdges.equalToSuperview().inset(horizontalInset)
            $0.top.equalTo(greetingLabel.snp.bottom).offset(28.0)
        })
        
        allCheckButton.snp.makeConstraints({
            $0.horizontalEdges.equalToSuperview().inset(horizontalInset)
            $0.top.equalTo(askAgreeTermsLabel.snp.bottom).offset(20.0)
        })
        
        divider.snp.makeConstraints({
            $0.horizontalEdges.equalToSuperview().inset(horizontalInset)
            $0.top.equalTo(allCheckButton.snp.bottom).offset(12.0)
        })
        
        firstCheckBoxView.snp.makeConstraints({
            $0.horizontalEdges.equalToSuperview().inset(horizontalInset)
            $0.top.equalTo(divider.snp.bottom).offset(12.0)
        })
        
        secondCheckBoxView.snp.makeConstraints({
            $0.horizontalEdges.equalToSuperview().inset(horizontalInset)
            $0.top.equalTo(firstCheckBoxView.snp.bottom).offset(10.0)
        })
        
        thirdCheckBoxView.snp.makeConstraints({
            $0.horizontalEdges.equalToSuperview().inset(horizontalInset)
            $0.top.equalTo(secondCheckBoxView.snp.bottom).offset(10.0)
        })
    }
    
    private func checkAllBox() {
        firstCheckBoxView.didTapCheckBox()
    }
}


struct SignUpFirstStepViewController_Previews: PreviewProvider {
    static var previews: some View{
        ViewControllerPreview {
            SignUpFirstStepViewController()
        }
    }
}

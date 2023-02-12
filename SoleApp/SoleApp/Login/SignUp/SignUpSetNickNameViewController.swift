//
//  SignUpSetNickNameViewController.swift
//  SoleApp
//
//  Created by SUN on 2023/02/12.
//

import UIKit
import SnapKit
import Combine

final class SignUpSetNickNameViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()
    
    private let profileImageView: UIImageView = {
        let image = UIImage(named: "Group 2196")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    private let addImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "add_circle"), for: .normal)
        return button
    }()
    
    private let nickNameTextField: UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .done
        textField.textColor = .black
        textField.placeholder = "닉네임을 입력해주세요. (최대 10자)"
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder ?? "", attributes: [.foregroundColor: UIColor.gray_999999])
        return textField
    }()
    
    private let validImageView: UIImageView = {
        let image = UIImage(named: "")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .gray_F2F2F2
        return view
    }()
    
    private lazy var continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("시작하기", for: .normal)
        button.setTitle("시작하기", for: .disabled)
        button.isEnabled = false
        button.titleLabel?.font = .pretendardRegular(size: 16.0)
        button.setTitleColor(.white, for: .disabled)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setBackgroundColor(.yellow_E9FF4B , for: .normal)
        button.setBackgroundColor(.gray_D3D4D5 , for: .disabled)
        button.layer.cornerRadius = 10.0
        button.clipsToBounds = true
        button.adjustsImageWhenHighlighted = false
        button.addTarget(self, action: #selector(moveToNextStep), for: .touchUpInside)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationUI(title: "회원가입")
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        [profileImageView,
         addImageButton,
         nickNameTextField,
         validImageView,
         divider,
         continueButton].forEach({ view.addSubview($0) })
        
        profileImageView.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(63.0)
        })
        
        addImageButton.snp.makeConstraints({
            $0.trailing.equalTo(profileImageView.snp.trailing).offset(-7.0)
            $0.bottom.equalTo(profileImageView.snp.bottom).offset(-7.0)
        })
        
        nickNameTextField.snp.makeConstraints({
            $0.top.equalTo(profileImageView.snp.bottom).offset(56.0)
            $0.leading.equalToSuperview().inset(16.0)
            $0.trailing.equalTo(validImageView.snp.leading).offset(10.0)
        })
        
        validImageView.snp.makeConstraints({
            $0.centerY.equalTo(nickNameTextField.snp.centerY)
            $0.trailing.equalToSuperview().inset(24.0)
        })
        divider.snp.makeConstraints({
            $0.horizontalEdges.equalToSuperview().inset(16.0)
            $0.top.equalTo(nickNameTextField.snp.bottom).offset(5.0)
            $0.height.equalTo(1.0)
        })
        
        continueButton.snp.makeConstraints({
            $0.horizontalEdges.equalToSuperview().inset(16.0)
            $0.height.equalTo(48.0)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(57.0)
        })
    }
    
    private func bind() {
        nickNameTextField.textPublisher(for: .editingDidEndOnExit)
            .sink(receiveValue: { [weak self] nickName in
                self?.continueButton.isEnabled = !nickName.isEmpty
            })
            .store(in: &cancellables)
    }
    
    @objc private func moveToNextStep() {
        let vc = SignUpCompleteVIewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

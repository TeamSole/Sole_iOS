//
//  SignUpCompleteVIewController.swift
//  SoleApp
//
//  Created by SUN on 2023/02/12.
//

import UIKit
import SnapKit
import SwiftUI

final class SignUpCompleteVIewController: UIViewController {
    private let logoImageView: UIImageView = {
        let image = UIImage(named: "sole_splash")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let completeSignUpTitlelabel: UILabel = {
        let label = UILabel()
        label.text = "회원가입 완료!"
        label.textColor = .yellow_E9FF4B
        label.font = .pretendardMedium(size: 24.0)
        label.textAlignment = .center
        return label
    }()
    
    private let completeSignUpSubTitlelabel: UILabel = {
        let label = UILabel()
        label.text = "쏠과 함께 지도 위에\n나만의 발자국을 남겨봐요!"
        label.numberOfLines = 0
        label.textColor = .white
        label.font = .pretendardRegular(size: 16.0)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("쏠 시작하기", for: .normal)
        button.titleLabel?.font = .pretendardRegular(size: 16.0)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setBackgroundColor(.yellow_E9FF4B , for: .normal)
        button.layer.cornerRadius = 10.0
        button.clipsToBounds = true
        button.adjustsImageWhenHighlighted = false
        button.addTarget(self, action: #selector(moveToNextStep), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .black
        
        [logoImageView,
         completeSignUpTitlelabel,
         completeSignUpSubTitlelabel,
         continueButton].forEach({ view.addSubview($0) })
        
        logoImageView.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.verticalEdges.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.6)
        })
        
        continueButton.snp.makeConstraints({
            $0.horizontalEdges.equalToSuperview().inset(16.0)
            $0.height.equalTo(48.0)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(57.0)
            $0.top.equalTo(completeSignUpSubTitlelabel.snp.bottom).offset(80.0)
        })
        
        completeSignUpTitlelabel.snp.makeConstraints({
            $0.horizontalEdges.equalToSuperview()
        })
        
        completeSignUpSubTitlelabel.snp.makeConstraints({
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(completeSignUpTitlelabel.snp.bottom).offset(24.0)
        })
        
        
        
    }
    
    @objc private func moveToNextStep() {
        let vc = SignUpSetNickNameViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

struct SignUpCompleteVIewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            SignUpCompleteVIewController()
        }
    }
}

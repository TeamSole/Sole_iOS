//
//  CheckBoxView.swift
//  SoleApp
//
//  Created by SUN on 2023/02/10.
//

import UIKit
import SwiftUI
import SnapKit

final class CheckBoxView: UIStackView {
    @Binding var isSelected: Bool {
        didSet {
            checkBoxButton.isSelected = isSelected
        }
    }
    var title: String
    var url: String
    init(isSelected: Binding<Bool>, title: String, url: String) {
        self._isSelected = isSelected
        self.title = title
        self.url = url
        super.init(frame: .zero)
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var checkBoxButton: UIButton = {
        let button = UIButton()
        button.adjustsImageWhenHighlighted = false
        button.setImage(UIImage(named: "radio_button_unchecked"), for: .normal)
        button.setImage(UIImage(named: "check_circle"), for: .selected)
        button.setTitle(title, for: .normal)
        button.setTitle(title, for: .selected)
        button.setTitleColor(.black, for: .selected)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .pretendardRegular(size: 14.0)
        button.contentHorizontalAlignment = .leading
        button.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 6.0, bottom: 0.0, right: 0.0)
        button.addTarget(self, action: #selector(checkBox), for: .touchUpInside)
        return button
    }()
    
    private lazy var linkButton: UIButton = {
        let button = UIButton()
        button.adjustsImageWhenHighlighted = false
        button.setImage(UIImage(named: "arrow_right"), for: .normal)
        button.addTarget(self, action: #selector(moveToLink), for: .touchUpInside)
        return button
    }()
    
    private func setupUI() {
        distribution = .fill
        contentMode = .center
        axis = .horizontal
        isUserInteractionEnabled = true
        
        [checkBoxButton,
         linkButton].forEach({ addArrangedSubview($0) })
        
        linkButton.snp.makeConstraints({
            $0.width.equalTo(40.0)
        })
        
        checkBoxButton.snp.makeConstraints({
            $0.leading.equalToSuperview()
        })
        
    }
    
    @objc private func checkBox() {
        isSelected.toggle()
    }
    
    @objc private func moveToLink() {
        let url = URL(string: url)!
        UIApplication.shared.open(url)
    }
}

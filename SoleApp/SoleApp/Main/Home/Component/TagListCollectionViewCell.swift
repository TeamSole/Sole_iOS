//
//  TagListCollectionViewCell.swift
//  SoleApp
//
//  Created by SUN on 2023/03/11.
//

import UIKit
import SnapKit

final class TagListCollectionViewCell: UICollectionViewCell {
    static let height: CGFloat = 18.0
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        print("fjewifjiowejfio")
//        label.sizeToFit()
        label.snp.makeConstraints({
            $0.edges.equalToSuperview()
            $0.height.equalTo(18.0)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  UITextField.swift
//  SoleApp
//
//  Created by SUN on 2023/02/12.
//

import UIKit
import Combine

extension UITextField {
    func textPublisher(for event: UIControl.Event) -> AnyPublisher<String, Never> {
        return controlPublisher(for: event)
            .map({ $0 as? UITextField })
            .map({ $0?.text ?? "" })
            .eraseToAnyPublisher()
    }
}

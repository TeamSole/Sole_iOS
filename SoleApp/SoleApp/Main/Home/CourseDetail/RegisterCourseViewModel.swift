//
//  RegisterCourseViewModel.swift
//  SoleApp
//
//  Created by SUN on 2023/03/21.
//

import SwiftUI

final class RegisterCourseViewModel: ObservableObject {
    @Published var thumbnailImage: UIImage? = nil
    @Published var selectedImages: [[UIImage]] = [[]]
}

//
//  NavigationButton.swift
//  CustomNavigationBar
//
//  Created by J_Min on 2022/11/27.
//

import UIKit

final class NavigationButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
    }
    
    init(image: UIImage?) {
        super.init(frame: .zero)
        let configuration = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular, scale: .default)
        setImage(image, for: .normal)
        setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        tintColor = .label
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//
//  CustomButton.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 07.02.2023.
//

import UIKit

class CustomButton: UIButton {

    typealias Action = () -> Void

    var tapAction: Action

    init(title: String,
         titleColor: UIColor,
         backgroundColor: UIColor?,
         shadowRadius: CGFloat,
         shadowOpacity: Float,
         shadowOffset: CGSize,
         action: @escaping Action) {

        tapAction = action
        super.init(frame: .zero)

        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffset
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addTarget(self, action:  #selector(buttonTapped), for: .touchUpInside)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func buttonTapped() {
        tapAction()
    }

}

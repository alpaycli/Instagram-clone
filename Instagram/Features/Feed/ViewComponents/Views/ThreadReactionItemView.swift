//
//  ThreadReactionItemView.swift
//  Instagram
//
//  Created by Alpay Calalli on 30.10.25.
//

import UIKit

class ThreadReactionItemView: UIView {
   
   private let stackView = UIStackView()
   
   private var buttonAction: () -> Void = {}
   
   private lazy var actionButton: UIButton = {
      let btn = UIButton()
      btn.tintColor = .label
      btn.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
      
      btn.translatesAutoresizingMaskIntoConstraints = false
      return btn
   }()
   
   private lazy var label: UILabel = {
      let l = UILabel()
      l.textColor = .label
      l.adjustsFontSizeToFitWidth = true
      l.minimumScaleFactor = 0.9
      l.lineBreakMode = .byTruncatingTail
      l.translatesAutoresizingMaskIntoConstraints = false

      return l
   }()
   
   override init(frame: CGRect) {
       super.init(frame: frame)
      stackView.axis = .horizontal
      stackView.spacing = 8
      addSubview(stackView)
      stackView.addArrangedSubview(actionButton)
      stackView.addArrangedSubview(label)
      
      stackView.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
         stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
         stackView.topAnchor.constraint(equalTo: topAnchor),
         stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
         stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
      ])
//       configure()
   }
   
   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }
   
   func set(image: UIImage, label: String, buttonAction: @escaping () -> Void) {
      print("i got set on bottom too")
      self.actionButton.setImage(image, for: .normal)
      self.label.text = label
      self.buttonAction = buttonAction
   }
   
   private func configure() {
      addSubviews(actionButton, label)
      
      NSLayoutConstraint.activate([
         actionButton.topAnchor.constraint(equalTo: topAnchor),
         actionButton.leadingAnchor.constraint(equalTo: leadingAnchor),
         actionButton.bottomAnchor.constraint(equalTo: bottomAnchor),
         
//         actionButton.widthAnchor.constraint(equalToConstant: 34),
//         actionButton.heightAnchor.constraint(equalToConstant: 34),
//         label.widthAnchor.constraint(equalToConstant: 34),
//         label.heightAnchor.constraint(equalToConstant: 34),
//         
         
         label.topAnchor.constraint(equalTo: topAnchor),
         label.leadingAnchor.constraint(equalTo: actionButton.trailingAnchor, constant: 8),
         label.bottomAnchor.constraint(equalTo: bottomAnchor),
         label.trailingAnchor.constraint(equalTo: trailingAnchor)
      ])
   }
   
   @objc func buttonTapped() {
       buttonAction()
   }
}

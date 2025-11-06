//
//  ThreadReactionItemView.swift
//  Instagram
//
//  Created by Alpay Calalli on 30.10.25.
//

import UIKit

class ThreadReactionItemView: UIView {
   
   private lazy var stackView: UIStackView = {
      let sv = UIStackView()
      sv.axis = .horizontal
      sv.spacing = 8
      sv.addArrangedSubview(actionButton)
      sv.addArrangedSubview(label)
      
      sv.translatesAutoresizingMaskIntoConstraints = false
      return sv
   }()
      
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
   
   private var buttonAction: () -> Void = {}
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      layoutUI()
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   func set(image: UIImage, label: String, buttonAction: @escaping () -> Void) {
      self.actionButton.setImage(image, for: .normal)
      self.label.text = label
      self.buttonAction = buttonAction
   }
   
   private func layoutUI() {
      addSubview(stackView)
      NSLayoutConstraint.activate([
         stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
         stackView.topAnchor.constraint(equalTo: topAnchor),
         stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
         stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
      ])
   }
   
   @objc func buttonTapped() {
      buttonAction()
   }
}

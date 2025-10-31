//
//  ThreadsHeaderView.swift
//  Instagram
//
//  Created by Alpay Calalli on 30.10.25.
//


import UIKit

final class ThreadsHeaderView: UIView {
   
   // MARK: - External Action
   var onOptionsTapped: (() -> Void)?
   
   // MARK: - UI Components
   private let avatarImageView: GFAvatarImageView = {
      let iv = GFAvatarImageView(frame: .zero)
      iv.contentMode = .scaleAspectFill
      iv.layer.cornerRadius = 16
      iv.layer.masksToBounds = true
      iv.backgroundColor = .systemGray5
      iv.translatesAutoresizingMaskIntoConstraints = false
      return iv
   }()
   
   private let titleLabel: IGTitleLabel = {
      let l = IGTitleLabel(textAlignment: .left, fontSize: 13)
      
      return l
   }()
   
   private let subtitleLabel: IGSecondaryTitleLabel = {
      let lbl = IGSecondaryTitleLabel(fontSize: 11)
      
      return lbl
   }()
   
   private lazy var textStack: UIStackView = {
      let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
      stack.axis = .vertical
      stack.spacing = 2
      return stack
   }()
   
   private lazy var optionsButton: UIButton = {
      let btn = UIButton(type: .system)
      btn.setImage(UIImage(systemName: "ellipsis"), for: .normal)
      btn.tintColor = .label
      btn.addTarget(self, action: #selector(optionsTapped), for: .touchUpInside)
      return btn
   }()
   
   private lazy var mainStack: UIStackView = {
      let stack = UIStackView(arrangedSubviews: [avatarImageView, textStack, UIView(), optionsButton])
      stack.axis = .horizontal
      stack.alignment = .center
      stack.spacing = 12
      return stack
   }()
   
   // MARK: - Init
   override init(frame: CGRect) {
      super.init(frame: frame)
      layoutUI()
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   private func layoutUI() {
      addSubview(mainStack)
      mainStack.translatesAutoresizingMaskIntoConstraints = false
      
      NSLayoutConstraint.activate([
         mainStack.topAnchor.constraint(equalTo: topAnchor, constant: 8),
         mainStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
         mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
         mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
         
         avatarImageView.widthAnchor.constraint(equalToConstant: 32),
         avatarImageView.heightAnchor.constraint(equalToConstant: 32)
      ])
   }
   
   func set(title: String, subtitle: String, avatar: UIImage?) {
      titleLabel.text = title
      subtitleLabel.text = subtitle
      avatarImageView.image = avatar
   }
   
   @objc private func optionsTapped() {
      onOptionsTapped?()
   }
}

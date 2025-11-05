//
//  PeopleSuggestionHeaderView.swift
//  Instagram
//
//  Created by Alpay Calalli on 05.11.25.
//

import UIKit

class PeopleSuggestionHeaderView: UIView {
   var onSeeAllButtonTapped: (() -> Void)?
   
   private lazy var titleLabel: IGTitleLabel = {
      let l = IGTitleLabel(textAlignment: .left, fontSize: 14, weight: .semibold)
      l.text = .init(localized: "Suggested for you")
      
      return l
   }()
   
   private lazy var actionButton: UIButton = {
      let btn = UIButton()
      btn.setTitle(.init(localized: "See all"), for: .normal)
      btn.setTitleColor(.blue, for: .normal)
      btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
      btn.addTarget(self, action: #selector(seeAllButtonTapped), for: .touchUpInside)
      
      btn.translatesAutoresizingMaskIntoConstraints = false
      return btn
   }()
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      layoutUI()
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   private func layoutUI() {
      addSubviews(titleLabel, actionButton)
      
      NSLayoutConstraint.activate([
         titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
         titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
         titleLabel.heightAnchor.constraint(equalToConstant: 19),
         
         actionButton.trailingAnchor.constraint(equalTo: trailingAnchor),
         actionButton.topAnchor.constraint(equalTo: topAnchor, constant: 4),
         actionButton.heightAnchor.constraint(equalToConstant: 19),
      ])
   }
   
   @objc func seeAllButtonTapped() {
      onSeeAllButtonTapped?()
   }
}

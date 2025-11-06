//
//  StoryLiveIndicatorView.swift
//  Instagram
//
//  Created by Alpay Calalli on 04.11.25.
//

import UIKit

class StoryLiveIndicatorView: UIView {
   
   private lazy var titleLabel: UILabel = {
      let l = UILabel()
      l.textAlignment = .center
      l.font = UIFont.systemFont(ofSize: 8, weight: .bold)
      l.textColor = .white
      l.adjustsFontSizeToFitWidth = true
      l.minimumScaleFactor = 0.9
      l.lineBreakMode = .byTruncatingTail
      l.text = "LIVE"
      l.translatesAutoresizingMaskIntoConstraints = false
      return l
   }()
   
   private var gradientLayer: CAGradientLayer?
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      setupUI()
      layoutUI()
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   override func layoutSubviews() {
      super.layoutSubviews()
      setupGradientBackground()
   }
   
   private func setupGradientBackground() {
      // remove old gradient if exists
      gradientLayer?.removeFromSuperlayer()
      
      let gradient = CAGradientLayer()
      gradient.frame = bounds
      gradient.colors = [
         UIColor(hexString: "#C90083").cgColor,
         UIColor(hexString: "#D22463").cgColor,
         UIColor(hexString: "#E10038").cgColor
      ]
      gradient.locations = [0, 0.5, 1]
      gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
      gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
      
      layer.insertSublayer(gradient, at: 0)
      gradientLayer = gradient
   }
   
   private func setupUI() {
      addSubview(titleLabel)
      clipsToBounds = true
      layer.cornerRadius = 3
      layer.borderWidth = 2
      layer.borderColor = UIColor(hexString: "#FEFEFE").cgColor
   }
   
   private func layoutUI() {
      NSLayoutConstraint.activate([
         titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
         titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      ])
   }
}

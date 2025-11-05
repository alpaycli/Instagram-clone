//
//  StoryBottomBarView.swift
//  Instagram
//
//  Created by Alpay Calalli on 05.11.25.
//

import UIKit

class StoryBottomBarView: UIView, UISearchTextFieldDelegate {
   
   var beginEditing: () -> () = {}
   var endEditing: () -> () = {}
    
    private let cameraButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.tintColor = .white
       btn.addTarget(StoryBottomBarView.self, action: #selector(cameraButtonTapped), for: .touchUpInside)
       
       let pointSize: CGFloat = 38.0
       let config = UIImage.SymbolConfiguration(pointSize: pointSize, weight: .regular, scale: .default)

       let image = UIImage(systemName: "camera.circle.fill", withConfiguration: config)
       btn.setImage(image, for: .normal)
       btn.tintColor = .systemGray

       btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.15, alpha: 1)
        view.layer.cornerRadius = 25
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let messageTextField: UITextField = {
        let tf = UITextField()
       tf.placeholder = .init(localized: "Send Message")
        tf.textColor = .white
        tf.font = .systemFont(ofSize: 17)
        tf.attributedPlaceholder = NSAttributedString(
            string: "Send Message",
            attributes: [.foregroundColor: UIColor.white]
        )
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let sendButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.tintColor = .white
       btn.addTarget(StoryBottomBarView.self, action: #selector(sendButtonTapped), for: .touchUpInside)
       btn.setImage(PostActionIcon.share, for: .normal)
       
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let moreButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.tintColor = .white
       btn.addTarget(StoryBottomBarView.self, action: #selector(moreButtonTapped), for: .touchUpInside)
       btn.setImage(.init(systemName: "ellipsis"), for: .normal)
       
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    // MARK: - Setup
   
    private func configure() {
        backgroundColor = .black
        
        addSubview(cameraButton)
        addSubview(containerView)
        addSubview(sendButton)
        addSubview(moreButton)
        
        containerView.addSubview(messageTextField)
       messageTextField.delegate = self
        
        layoutUI()
    }
    
    private func layoutUI() {
        NSLayoutConstraint.activate([
            // Container view
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 50),
            containerView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -13),
            
            // Camera button
            cameraButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5),
            cameraButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            cameraButton.widthAnchor.constraint(equalToConstant: 44),
            cameraButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Text field
            messageTextField.leadingAnchor.constraint(equalTo: cameraButton.trailingAnchor, constant: 13),
            messageTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            messageTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            // Send button
            sendButton.trailingAnchor.constraint(equalTo: moreButton.leadingAnchor, constant: -8),
            sendButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 44),
            sendButton.heightAnchor.constraint(equalToConstant: 44),
            
            // More button
            moreButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            moreButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            moreButton.widthAnchor.constraint(equalToConstant: 44),
            moreButton.heightAnchor.constraint(equalToConstant: 44)
        ])
       bringSubviewToFront(cameraButton)
    }
   
    // MARK: - Actions
   
    @objc private func cameraButtonTapped() {}
    
    @objc private func sendButtonTapped() {}
    
    @objc private func moreButtonTapped() {}
}

extension StoryBottomBarView: UITextFieldDelegate {
   func textFieldDidBeginEditing(_ textField: UITextField) {
      beginEditing()
   }
   
   func textFieldDidEndEditing(_ textField: UITextField) {
      endEditing()
   }
}

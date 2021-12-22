//
//  MeaningDetailHeader.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 22.12.2021.
//

import UIKit

final class MeaningDetailHeader: UIView {
    //MARK: Subviews
    private let meaningImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage.init(systemName: "photo.fill")
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.layer.masksToBounds = true
        iv.tintColor = Colors.background
        return iv
    }()
    private let meaningDetailView: UIView = {
        let v = UIView()
        v.backgroundColor = Colors.link
        v.clipsToBounds = true
        v.layer.masksToBounds = true
        return v
    }()
    private lazy var labelsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [wordLabel,translationLabel])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private let wordLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.text = "Word"
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return lbl
    }()
    private let speakerImage: UIImage? = {
        let config = UIImage.SymbolConfiguration(
            pointSize: 32, weight: .light, scale: .default)
        let image = UIImage(systemName: "speaker.wave.2.fill", withConfiguration: config)
        
        return image
    }()
    private lazy var speakerButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.setImage(speakerImage, for: .normal)
        button.contentMode = .scaleAspectFit
      
        return button
    }()
    private let translationLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "translation"
        lbl.textAlignment = .left
        lbl.textColor = .white
        return lbl
    }()
    private let transcriptionPartOfSpeechLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "translation"
        lbl.textAlignment = .left
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return lbl
    }()
    //MARK: Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        speakerButton.addTarget(self,
                             action: #selector(speakerButtonPressed(sender:)),
                             for: .touchUpInside)
        setupConstraints()
        
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
  
    //MARK: Actionis
    @objc private func speakerButtonPressed(sender: UIButton) {
        
    }
    //MARK: Constraints
    private func setupConstraints() {
        addSubviewsForAutolayout([
            meaningImageView,
            transcriptionPartOfSpeechLabel
            
        ])
        //meaning image view
        NSLayoutConstraint.activate([
            meaningImageView.topAnchor.constraint(equalTo: topAnchor,constant: 16),
            meaningImageView.widthAnchor.constraint(equalToConstant: frame.width - 20),
            meaningImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
//            meaningImageView.heightAnchor.constraint(equalTo: heightAnchor,multiplier: 0.6)
        ])
        meaningImageView.addSubviewsForAutolayout([
            meaningDetailView,
            labelsStack
        ])
        //meaning detail view
        NSLayoutConstraint.activate([
            meaningDetailView.leadingAnchor.constraint(equalTo: meaningImageView.leadingAnchor),
            meaningDetailView.trailingAnchor.constraint(equalTo: meaningImageView.trailingAnchor),
            meaningDetailView.bottomAnchor.constraint(equalTo: meaningImageView.bottomAnchor),
            meaningDetailView.heightAnchor.constraint(equalTo: meaningImageView.heightAnchor, multiplier: 0.3)
        ])
        //labeles stack
        meaningDetailView.addSubviewsForAutolayout([labelsStack])
        NSLayoutConstraint.activate([
            labelsStack.leadingAnchor.constraint(equalTo: meaningDetailView.leadingAnchor,constant: 16),
            labelsStack.centerYAnchor.constraint(equalTo: meaningDetailView.centerYAnchor),
            
        ])
        //speaker button
        insertSubviewForAutoLayout(speakerButton, aboveSubview: meaningDetailView)
        NSLayoutConstraint.activate([
            speakerButton.centerYAnchor.constraint(equalTo: meaningDetailView.centerYAnchor),
            speakerButton.trailingAnchor.constraint(equalTo: meaningDetailView.trailingAnchor,constant: -16)
        ])
        //transcription
        NSLayoutConstraint.activate([
            transcriptionPartOfSpeechLabel.leadingAnchor.constraint(equalTo: meaningImageView.leadingAnchor),
            transcriptionPartOfSpeechLabel.topAnchor.constraint(equalTo: meaningImageView.bottomAnchor,constant: 16),
            transcriptionPartOfSpeechLabel.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -16)
        ])
    }

}

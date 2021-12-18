//
//  MeaningHeaderCell.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 18.12.2021.
//

import UIKit


final class MeaningHeaderCell: UITableViewCell, ReuseIdentifiable {
    
   // encrease cell width. this is to use with table viwe style inset grouped
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            let inset: CGFloat = -10
            var frame = newFrame
            frame.origin.x += inset
            frame.size.width -= 2 * inset
            super.frame = frame
        }
    }
    
    var viewModel: Word! {
        didSet {
            fillContent(with: viewModel)
        }
    }
    //MARK: Other Properties
    var expandAction: (() -> Void)?
    
    //MARK: System  images
    private let chevron: UIImage? = {
        let config = UIImage.SymbolConfiguration(
            pointSize: 32, weight: .light, scale: .default)
        let image = UIImage(systemName: "chevron.down.circle", withConfiguration: config)
        return image
    }()
 
    //MARK: Subviews
    private let previewImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage.init(systemName: "rectangle.stack.fill")
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 10
        iv.layer.masksToBounds = true
        iv.tintColor = Colors.background
        return iv
    }()
    
    private lazy var labelsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [wordLabel,translationLabel])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .equalSpacing
        return stack
    }()
    
    let wordLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return lbl
    }()
    
    let wordsCountLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.text = "3"
        lbl.backgroundColor = .white.withAlphaComponent(0)
        lbl.font = UIFont.systemFont(ofSize: 26, weight: .regular)
        return lbl
    }()
    let translationLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        return lbl
    }()
    
    private lazy var expandButton: UIButton = {
        let button = UIButton()
        button.tintColor = Colors.link
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(expandButtonPressed(sender:)), for: .touchUpInside)
        button.setImage(chevron, for: .normal)
        return button
    }()
    //MARK: Constraints
    private func setupConstraints() {
        contentView.addSubviewsForAutolayout([
            expandButton,
            labelsStack,
            previewImageView,
            
        ])
        contentView.insertSubviewForAutoLayout(wordsCountLabel, aboveSubview: previewImageView)
        //preview image
        NSLayoutConstraint.activate([
            previewImageView.topAnchor.constraint(equalTo: topAnchor,constant: 6),
            previewImageView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 16),
            previewImageView.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -16),
            previewImageView.widthAnchor.constraint(equalTo: widthAnchor,multiplier: 0.2)
        ])
        //words count lavel
        NSLayoutConstraint.activate([
            wordsCountLabel.centerXAnchor.constraint(equalTo: previewImageView.centerXAnchor),
            wordsCountLabel.centerYAnchor.constraint(equalTo: previewImageView.centerYAnchor,constant: 8)
        ])
        //labels stack
        NSLayoutConstraint.activate([
            labelsStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            labelsStack.leadingAnchor.constraint(equalTo: previewImageView.trailingAnchor,constant: 8),
            labelsStack.trailingAnchor.constraint(equalTo: expandButton.leadingAnchor, constant: -2)
            
        ])
        //saveButton
        NSLayoutConstraint.activate([
            expandButton.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -16),
            expandButton.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -8),
            expandButton.topAnchor.constraint(equalTo: topAnchor,constant: 8),
            expandButton.widthAnchor.constraint(equalTo: widthAnchor,multiplier: 0.1)
        ])
    }
    
  //MARK: Actions
    @objc private func expandButtonPressed(sender: UIButton) {
        
        
    }
    
    //MARK: Life cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        backgroundColor = .green
    }
  
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
}

extension MeaningHeaderCell: ViewModelConfigurable {
    
    //MARK: Sepcial methods
    func reset() {
        //rotate chavron
    }
    
    func fillContent(with viewModel: Word) {
        wordLabel.text = viewModel.text
        wordsCountLabel.text = viewModel.meaningsCount
        translationLabel.text = viewModel.joinTranslationsIntoOneString(length: 30)

    }
    
    
}

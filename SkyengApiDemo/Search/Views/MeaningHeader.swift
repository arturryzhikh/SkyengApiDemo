//
//  MeaningHeaderCell.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 18.12.2021.
//

import UIKit


final class MeaningHeader: UITableViewHeaderFooterView, ReuseIdentifiable {

    var viewModel: MeaningsHeaderViewModel! {
        didSet {
            fillContent(with: viewModel)
            }
        }
    //MARK: Other Properties
    var expandAction: (() -> Void)?
    //MARK: System  images
    private let chevronDown: UIImage? = {
        let config = UIImage.SymbolConfiguration(
            pointSize: 32, weight: .light, scale: .default)
        let image = UIImage(systemName: "chevron.down.circle", withConfiguration: config)
        return image
    }()
    private let chevronUp: UIImage? = {
        let config = UIImage.SymbolConfiguration(
            pointSize: 32, weight: .light, scale: .default)
        let image = UIImage(systemName: "chevron.up.circle", withConfiguration: config)
        return image
    }()
    //MARK: Subviews
    private let previewImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
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
    
    private lazy var expandImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = Colors.link
        iv.clipsToBounds = true
        iv.layer.masksToBounds = true
        iv.image = chevronDown
        return iv
    }()
    //MARK: Constraints
    private func setupConstraints() {
        addSubviewsForAutolayout([
            expandImageView,
            labelsStack,
            previewImageView,
            
        ])
        insertSubviewForAutoLayout(wordsCountLabel, aboveSubview: previewImageView)
        //preview image
        NSLayoutConstraint.activate([
            previewImageView.topAnchor.constraint(equalTo: topAnchor),
            previewImageView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 16),
            previewImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            previewImageView.widthAnchor.constraint(equalTo: widthAnchor,multiplier: 0.2)
        ])
        //words count label
        NSLayoutConstraint.activate([
            wordsCountLabel.centerXAnchor.constraint(equalTo: previewImageView.centerXAnchor),
            wordsCountLabel.centerYAnchor.constraint(equalTo: previewImageView.centerYAnchor,constant: 8)
        ])
        //labels stack
        NSLayoutConstraint.activate([
            labelsStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            labelsStack.leadingAnchor.constraint(equalTo: previewImageView.trailingAnchor,constant: 8),
            labelsStack.trailingAnchor.constraint(equalTo: expandImageView.leadingAnchor, constant: -2)
            
        ])
        //expand button
        NSLayoutConstraint.activate([
            expandImageView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -16),
            expandImageView.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -8),
            expandImageView.topAnchor.constraint(equalTo: topAnchor,constant: 8),
            expandImageView.widthAnchor.constraint(equalTo: widthAnchor,multiplier: 0.1)
        ])
    }
   
  //MARK: Actions
    @objc private func didTapHeader() {
        expandAction?()
    }
    
    
    //MARK: Life cycle
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                    action: #selector(didTapHeader)))
        contentView.backgroundColor = Colors.selected
        setupConstraints()
        
       
    }
   
   
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
   
    
}

extension MeaningHeader: ViewModelConfigurable {
    //MARK: Sepcial methods
    
    func fillContent(with viewModel: MeaningsHeaderViewModel) {
        wordLabel.text = viewModel.word
        translationLabel.text = viewModel.translations
        wordsCountLabel.text = viewModel.wordsCount
        expandImageView.image = viewModel.collapsed ? chevronDown : chevronUp
        
    }
    
    
}

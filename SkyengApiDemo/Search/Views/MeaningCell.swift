//
//  MeaningCell.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 18.12.2021.
//

import UIKit


class MeaningCell: UITableViewCell, ReuseIdentifiable {
    

    var viewModel: MeaningViewModel! {
        didSet {
            fillContent(with: viewModel)
        }
    }
    //MARK: Other Properties
    var saveAction: (() -> Void)?
    
    //MARK: System  images
    private let saveImage: UIImage? = {
        let config = UIImage.SymbolConfiguration(
            pointSize: 32, weight: .light, scale: .default)
        let image = UIImage(systemName: "plus.circle", withConfiguration: config)
        
        return image
    }()
    
    private let savedImage: UIImage? = {
        let config = UIImage.SymbolConfiguration(
            pointSize: 28, weight: .light, scale: .default)
        let image = UIImage(systemName: "star.circle",withConfiguration: config)
        return image
    }()
 
    //MARK: Subviews
    private let previewImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage.init(systemName: "photo.fill")
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 10
        iv.layer.masksToBounds = true
        iv.tintColor = .tertiarySystemBackground
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
    
    
    let translationLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        return lbl
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.tintColor = Colors.link
        button.contentMode = .scaleAspectFit
        return button
    }()
    //MARK: Constraints
    private func setupConstraints() {
        
        addSubviewsForAutolayout([
            saveButton,
            previewImageView,
            labelsStack
        ])
        //meaning image view
        NSLayoutConstraint.activate([
            previewImageView.topAnchor.constraint(equalTo: topAnchor,constant: 6),
            previewImageView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 16),
            previewImageView.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -6),
            previewImageView.widthAnchor.constraint(equalTo: widthAnchor,multiplier: 0.2)
        ])
        //labels stack
        NSLayoutConstraint.activate([
            labelsStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            labelsStack.leadingAnchor.constraint(equalTo: previewImageView.trailingAnchor,constant: 8),
            labelsStack.trailingAnchor.constraint(equalTo: saveButton.leadingAnchor, constant: -2)
            
        ])
        //saveButton
        NSLayoutConstraint.activate([
            saveButton.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -16),
            saveButton.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -8),
            saveButton.topAnchor.constraint(equalTo: topAnchor,constant: 8),
            saveButton.widthAnchor.constraint(equalTo: widthAnchor,multiplier: 0.1)
        ])
    }
    
  //MARK: Actions
    @objc private func saveButtonPressed(sender: UIButton) {
        saveAction?()
        
    }
    
    //MARK: Life cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        saveButton.addTarget(self,
                             action: #selector(saveButtonPressed(sender:)),
                             for: .touchUpInside)
        contentView.backgroundColor = .systemGroupedBackground
        setupConstraints()
      
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
}

extension MeaningCell: ViewModelConfigurable {
    //MARK: Sepcial methods
    func reset() {
        //make this to set image properly when cell is reused
        saveButton.isHidden = false
    }
    
    
    func fillContent(with viewModel: MeaningViewModel) {
        //assign image to plus button depending on view model is saved propertie
        let saveButtonImage = viewModel.isSaved ? savedImage : saveImage
        saveButton.setImage(saveButtonImage, for: .normal)
        //lock button if vm is saved
        saveButton.isUserInteractionEnabled = !viewModel.isSaved
        wordLabel.text = viewModel.word
        translationLabel.text = viewModel.translation
        viewModel.previewImage { [weak self] image in
            guard let self = self else {return}
            self.previewImageView.image = image
        }
    }
    
    
}

//
//  MeaningCell.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 18.12.2021.
//

import UIKit

protocol ViewModelConfigurable {
    
    associatedtype CellViewModel
    
    var viewModel: CellViewModel! { get set }
    
    func fillContent(with: CellViewModel)
    
    func reset()
    
}


protocol ReuseIdentifiable {
    static var reuseId: String { get }
}

extension ReuseIdentifiable {
    static var reuseId: String {
        return String(describing: self)
    }
}

class MeaningCell: UITableViewCell, ReuseIdentifiable {
    
    //encrease cell width. this is to use with table viwe style inset grouped
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
    
    var viewModel: Meaning2! {
        didSet {
            fillContent(with: viewModel)
        }
    }
    //MARK: Other Properties
    var saveAction: (() -> Void)?
    
    //MARK: System  images
    private let plusImage: UIImage? = {
        let config = UIImage.SymbolConfiguration(
            pointSize: 32, weight: .light, scale: .default)
        let image = UIImage(systemName: "plus.circle.fill", withConfiguration: config)
        
        return image
    }()
    
    private let starImage: UIImage? = {
        let config = UIImage.SymbolConfiguration(
            pointSize: 28, weight: .light, scale: .default)
        let image = UIImage(systemName: "star.fill",withConfiguration: config)
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
        iv.tintColor = Colors.background
        return iv
    }()
    let translationLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return lbl
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.tintColor = Colors.link
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
        return button
    }()
    //MARK: Constraints
    private func setupConstraints() {
        self.contentView.addSubviewsForAutolayout([
            plusButton,
            previewImageView,
            translationLabel
        ])
        //meaning image view
        NSLayoutConstraint.activate([
            previewImageView.topAnchor.constraint(equalTo: topAnchor,constant: 6),
            previewImageView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 16),
            previewImageView.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -16),
            previewImageView.widthAnchor.constraint(equalTo: widthAnchor,multiplier: 0.2)
        ])
        //translation label
        NSLayoutConstraint.activate([
            translationLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            translationLabel.leadingAnchor.constraint(equalTo: previewImageView.trailingAnchor,constant: 8),
            translationLabel.trailingAnchor.constraint(equalTo: plusButton.leadingAnchor, constant: -2)
            
        ])
        //saveButton
        NSLayoutConstraint.activate([
            plusButton.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -16),
            plusButton.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -8),
            plusButton.topAnchor.constraint(equalTo: topAnchor,constant: 8),
            plusButton.widthAnchor.constraint(equalTo: widthAnchor,multiplier: 0.1)
        ])
    }
    
  //MARK: Actions
    @objc private func buttonPressed(sender: UIButton) {
        saveAction?()
        print(#function)
        
    }
    
    //MARK: Life cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        plusButton.isHidden = false
    }
    
    
    func fillContent(with viewModel: Meaning2) {
        //assign image to plus button depending on view model is saved propertie
        let saveButtonImage = viewModel.isSaved ? starImage : plusImage
        plusButton.setImage(saveButtonImage, for: .normal)
        //lock button if vm is saved
        plusButton.isUserInteractionEnabled = viewModel.isSaved
        translationLabel.text = viewModel.translation?.text
        //get images from network or local
        if viewModel.isSaved {
            let previewImage = FileStoreManager
                .shared
                .loadImage(named: viewModel.previewUrl)
            previewImageView.image = previewImage
        } else {
            ImageFetcher
                .shared
                .setImage(from: viewModel.previewUrl,
                          placeholderImage: nil) { [weak self] image in
                    self?.previewImageView.image = image
                    
                }
        }
    }
    
    
}

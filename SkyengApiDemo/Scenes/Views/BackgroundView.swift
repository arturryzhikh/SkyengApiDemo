//
//  BackgroundView.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 18.12.2021.
//

import UIKit

final class BackgroundView: UIView {
    //MARK: properties
    var searchFailed = false {
        didSet {
            label.text = searchFailed ? "Nothing Found" : "Search words and word set, add them for study"
            imageView.image = searchFailed ? searchFailedImage : searchImage
        }
    }
    
    //MARK: Subviews
    //images
    private let searchImage: UIImage? = {
        let name = "rectangle.and.text.magnifyingglass"
        let config = UIImage.SymbolConfiguration(
            pointSize: 60,
            weight: .light,
            scale: .default)
        return UIImage(systemName:name, withConfiguration: config)
        
    }()
    private let searchFailedImage: UIImage? = {
        let name = "folder.badge.questionmark"
        let config = UIImage.SymbolConfiguration(
            pointSize: 60,
            weight: .light,
            scale: .default)
        return UIImage(systemName:name, withConfiguration: config)
        
    }()
   
    private let label: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 20)
        l.textColor = .lightGray
        l.text = "Search words and word set, add them to dictionary"
        return l
    }()
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.layer.masksToBounds = true
        iv.tintColor = Colors.link
        iv.image = searchImage
        return iv
    }()
   
    //MARK: constraints
    
    private func setupConstraints() {
        addSubviewsForAutolayout([imageView,label])
        NSLayoutConstraint.activate([
            //image view
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor,constant: -100),
           //Label
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor,constant: +16),
            label.widthAnchor.constraint(equalTo: widthAnchor,multiplier: 0.8),
            label.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    //MARK: life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        searchFailed = false
        backgroundColor = Colors.background
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

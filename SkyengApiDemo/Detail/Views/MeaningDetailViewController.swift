//
//  MeaningDetailViewController.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 22.12.2021.
//

import UIKit
import AVFoundation

protocol MeaningDetailDelegate: AnyObject {
    
    func didManage(meaning: Meaning2, at indexPath: IndexPath)
    
}


final class MeaningDetailViewController: UIViewController, ViewModelConfigurable {
    var player: AVAudioPlayer?
    weak var delegate: MeaningDetailDelegate?
    private var coordinator: MeaningDetaiCoordinator?
    //MARK: properties
    var viewModel: MeaningDetailViewModel!
    
    //MARK: Life Cycle
    init(viewModel: MeaningDetailViewModel, coordinator: MeaningDetaiCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    private func setupButton(isSaved: Bool) {
        let saveButtonTitle = isSaved ? "Delete from favorites" : "Add to favorites"
        let borderColor = isSaved ? Colors.delete : Colors.link
        saveButton.setTitle(saveButtonTitle, for: .normal)
        saveButton.layer.borderColor = borderColor.cgColor
    }
    
    func fillContent(with: MeaningDetailViewModel) {
        wordLabel.text = viewModel.word.text
        translationLabel.text = viewModel.translation
        noteLabel.text = viewModel.note
        transcriptionLabel.text = viewModel.transcription
        partOfSpeechLabel.text = viewModel.partOfSpeech
        setupButton(isSaved: viewModel.isSaved)
        viewModel.image { [weak self] image in
            guard let self = self else {return}
            self.meaningImageView.image = image
        }
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        speakerButton.addTarget(self,
                                action: #selector(speakerButtonPressed(sender:)),
                                for: .touchUpInside)
        saveButton.addTarget(self,
                             action: #selector(saveButtonPressed(sender:)),
                             for: .touchUpInside)
        fillContent(with: viewModel)
        setupNavigationController(title: viewModel.word.text)
        setupConstraints()
    }
    
    private func playSound(data: Data) {
        do {
            player = try AVAudioPlayer(data: data)
            guard let player = player else { return }
            player.prepareToPlay()
            player.volume = 1.0
            player.play()
        } catch {
            print(error)
        }
    }
    //MARK: Actionis
    
    @objc private func speakerButtonPressed(sender: UIButton) {
        
        viewModel.soundData { [weak self] data in
            guard let data = data , let self = self else {
                return
            }
            self.playSound(data: data)
            
        }
    }
    @objc private func saveButtonPressed(sender: UIButton) {
        viewModel.manageModel { [weak self] meaning in
            guard
                let meaning = meaning ,
                let self = self else {
                    return
                }
            self.setupButton(isSaved: self.viewModel.isSaved)
            self.delegate?.didManage(meaning: meaning, at: self.viewModel.indexPath)
            self.coordinator?.popViewController(animated: true)
            
        }
        
        
        
    }
    //MARK: Subviews
    private let meaningImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage.init(systemName: "photo.fill")
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.layer.masksToBounds = true
        iv.tintColor = .secondarySystemBackground
        return iv
    }()
    
    private lazy var labelsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            horizontalStack,
            translationLabel,
            noteLabel,
            transcriptionLabel,
            partOfSpeechLabel
        ])
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fillProportionally
        return stack
    }()
    
    private let wordLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.text = "Word"
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        return lbl
    }()
    
    private let translationLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        lbl.sizeToFit()
        return lbl
    }()
    private let noteLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.font = UIFont.systemFont(ofSize: 18, weight: .light)
        return lbl
    }()
    private let speakerImage: UIImage? = {
        let config = UIImage.SymbolConfiguration(
            pointSize: 24, weight: .light, scale: .default)
        let image = UIImage(systemName: "speaker.wave.2", withConfiguration: config)
        
        return image
    }()
    private lazy var horizontalStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [wordLabel,speakerButton])
        stack.spacing = 10
        stack.axis = .horizontal
        return stack
    }()
    private lazy var speakerButton: UIButton = {
        let button = UIButton()
        button.tintColor = Colors.link
        button.setImage(speakerImage, for: .normal)
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    private let transcriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return lbl
    }()
    private let partOfSpeechLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return lbl
    }()
    private func setupNavigationController(title: String) {
        navigationItem.title = title
        navigationController?.navigationBar.backgroundColor = .systemGroupedBackground
        navigationController?.navigationBar.prefersLargeTitles = false
        
    }
    private lazy var saveButton: UIButton = {
        let b = UIButton()
        b.setTitleColor(.label, for: .normal)
        b.setTitleColor(.secondaryLabel, for: .highlighted)
        b.backgroundColor = .clear
        b.layer.cornerRadius = 20
        b.layer.borderWidth = 1
        b.layer.cornerRadius = 12
        return b
    }()
    
    //MARK: Constraints
    private func setupConstraints() {
        view.addSubviewsForAutolayout([
            meaningImageView,
            labelsStack,
            saveButton,
           
            
        ])
        //meaning image view
        NSLayoutConstraint.activate([
            meaningImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 30),
            meaningImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            meaningImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            meaningImageView.heightAnchor.constraint(equalTo: view.heightAnchor,multiplier: 0.4)
        ])
        NSLayoutConstraint.activate([
            labelsStack.leadingAnchor.constraint(equalTo: meaningImageView.leadingAnchor),
            labelsStack.trailingAnchor.constraint(equalTo: meaningImageView.trailingAnchor),
            labelsStack.topAnchor.constraint(equalTo: meaningImageView.bottomAnchor,constant: 16),
            labelsStack.bottomAnchor.constraint(equalTo: saveButton.topAnchor,constant: -16)
        ])
     
        //save button
        NSLayoutConstraint.activate([
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -16),
            saveButton.heightAnchor.constraint(equalTo: view.heightAnchor,multiplier: 0.064)
        ])
        
        
    }
}


//
//  CollectionCell.swift
//  CoreDataa
//
//  Created by Shyngys Saktagan on 7/31/20.
//  Copyright © 2020 ShyngysSaktagan. All rights reserved.
//

import UIKit
import SnapKit

class CollectionCell: UITableViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let recordingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    private let iconImage : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.layer.cornerRadius = 16
        return imageView
    } ()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, recordingLabel])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [iconImage, infoStackView])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.layer.cornerRadius = 16
        stackView.backgroundColor = .green
        stackView.spacing = 16
        return stackView
    }()
    
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupUI() {
        addSubview(mainStackView)
                
        iconImage.snp.makeConstraints { make in
            make.height.width.equalTo(50)
        }
        
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
    
    
//    func configureType(data: CollectionType) {
//        switch data {
//        case .history:
//            set(nameLabel: "История", recordCount: 0, iconImage: "")
//        case .favorite:
//            set(nameLabel: "Избранные", recordCount: 0, iconImage: "")
//        }
//    }
    
    
    func set(nameLabel: String, recordCount: Int, iconImage: String) {
        self.titleLabel.text = nameLabel
        self.recordingLabel.text = "\(recordCount) запись"
        self.iconImage.image = UIImage(named: iconImage)
    }
}

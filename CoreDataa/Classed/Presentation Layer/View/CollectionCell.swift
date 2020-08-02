//
//  CollectionCell.swift
//  CoreDataa
//
//  Created by Shyngys Saktagan on 7/31/20.
//  Copyright © 2020 ShyngysSaktagan. All rights reserved.
//

import UIKit
import SnapKit

enum CollectionType {
    case favorite
    case history
}

class CollectionCell: UITableViewCell {
    
    private let mainView: UIView = {
        let view                = UIView()
        view.backgroundColor    = .white
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label               = UILabel()
        label.font              = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let recordingLabel: UILabel = {
        let label               = UILabel()
        label.font              = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    private let iconImage : UIImageView = {
        let imageView           = UIImageView()
        return imageView
    } ()
    
    private lazy var infoStackView: UIStackView = {
        let stackView           = UIStackView(arrangedSubviews: [titleLabel, recordingLabel])
        stackView.axis          = .vertical
        stackView.spacing       = 8
        stackView.alignment     = .fill
        stackView.distribution  = .fill
        return stackView
    }()
    
    
    private lazy var mainStackView: UIStackView = {
        let stackView                   = UIStackView(arrangedSubviews: [iconImage, infoStackView])
        stackView.axis                  = .horizontal
        stackView.spacing               = 16
        stackView.alignment             = .fill
        stackView.distribution          = .fill
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
        contentView.addSubview(mainView)
        mainView.addSubview(mainStackView)
        
        mainView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(8)
        }
    
        mainStackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(16)
        }
        
        iconImage.snp.makeConstraints { make in
            make.height.width.equalTo(50)
        }
    }
    
    
    func configureType(data: CollectionType) {
        switch data {
        case .history:
            set(nameLabel: "История", recordCount: 0, iconImage: "")
        case .favorite:
            set(nameLabel: "Избранные", recordCount: 0, iconImage: "")
        }
    }
    
    
    func set(nameLabel: String, recordCount: Int, iconImage: String) {
        self.iconImage.image        = UIImage(named: iconImage)
        self.titleLabel.text        = nameLabel
        self.recordingLabel.text    = set(recordCount: recordCount)
    }
    
    
    func set(recordCount: Int) -> String {
        if recordCount == 1 {
            return "\(recordCount) запись"
        } else if recordCount > 1 {
          return "\(recordCount) записи"
        } else {
            return "Нет записей"
        }
    }
}

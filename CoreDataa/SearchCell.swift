//
//  SearchCell.swift
//  CoreDataa
//
//  Created by Shyngys Saktagan on 7/31/20.
//  Copyright © 2020 ShyngysSaktagan. All rights reserved.
//

import UIKit
import SnapKit

class SearchCell: UITableViewCell {
    
    private let titleLabel : UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 24)
        return title
    } ()
    
    private let descriptionLabel : UILabel = {
        let description = UILabel()
        description.font = .systemFont(ofSize: 16)
        description.textColor = .gray
        return description
    } ()
    
    lazy private var stackView : UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .fill
        stack.alignment = .fill
        return stack
    } ()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupUI() {
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
    
    
    func set(title: String, description: String) {
        titleLabel.text = title
        descriptionLabel.text = description
    }
}

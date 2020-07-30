//
//  SearchResultVC.swift
//  CoreDataa
//
//  Created by Shyngys Saktagan on 7/31/20.
//  Copyright © 2020 ShyngysSaktagan. All rights reserved.
//

import UIKit
import SnapKit

class SearchResultVC: UIViewController {
    
    private let descriptionLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        return label
    } ()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configureBarButtonItem()
    }
    
    
    func configureBarButtonItem() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(addBookMark))
        navigationItem.rightBarButtonItem = addButton
    }
    
    
    @objc func addBookMark() {
        print("ehl")
    }
    
    
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
    
    
    func setDescription(text: String) {
        descriptionLabel.text = text
    }
}


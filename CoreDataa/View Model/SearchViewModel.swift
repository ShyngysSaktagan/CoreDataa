//
//  SearchViewModel.swift
//  CoreDataa
//
//  Created by Shyngys Saktagan on 7/31/20.
//  Copyright © 2020 ShyngysSaktagan. All rights reserved.
//

import UIKit

class SearchViewModel {
    private let wordService: WordService
    
    var words: [WordInfo] = []
    
    var didLoadTableItems: (() -> Void)?
    
    init(movieService: WordService) {
        self.wordService = movieService
    }
    
    func searchMovie(by title: String) {
        wordService.searchWord(by: title, success: { [weak self] (word) in
            self?.words.removeAll()
            word.list.forEach { self?.words.append($0) }
            self?.didLoadTableItems?()
        }, failure: { (error) in
            debugPrint(error)
        })
    }
}

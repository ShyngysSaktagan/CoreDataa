//
//  DescriptionService.swift
//  CoreDataa
//
//  Created by Shyngys Saktagan on 7/31/20.
//  Copyright © 2020 ShyngysSaktagan. All rights reserved.
//

import Alamofire

protocol WordService {
    func searchWord(by title: String, success: @escaping (Word) -> Void, failure: @escaping (Error) -> Void)
}


class WordServiceImpl: WordService {
    func searchWord(by title: String, success: @escaping (Word) -> Void, failure: @escaping (Error) -> Void) {
        let urlString = String(format: "%@%@", Api.baseUrl, title)
        guard let url = URL(string: urlString) else { return }

        AF.request(url, method: .get).responseDecodable { (dataResponse: DataResponse<Word, AFError>) in
            switch dataResponse.result {
            case .success(let word): success(word)
            case .failure(let error): failure(error)
            }
        }
    }
}

//
//  Word.swift
//  CoreDataa
//
//  Created by Shyngys Saktagan on 7/31/20.
//  Copyright © 2020 ShyngysSaktagan. All rights reserved.
//

import Foundation

struct WordInfo: Decodable {
    let definition: String
    let word: String
}

struct Word: Decodable {
    let list: [WordInfo]
}

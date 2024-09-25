//
//  EatCategoryModel.swift
//  userAppSUI
//
//  Created by Владимир Кацап on 25.09.2024.
//

import Foundation


// MARK: - Cafe
struct Cafe: Codable, Identifiable {
    let id: Int
    let img: String
    let title: String
    let address: String
    let number: String
    var image: Data?
}

// MARK: - CafeResponse
struct CafeResponse: Codable {
    var cafes: [Cafe]
}

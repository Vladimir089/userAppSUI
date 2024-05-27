//
//  Model.swift
//  userAppSUI
//
//  Created by Владимир Кацап on 25.05.2024.
//

import Foundation

struct Dish: Codable {
    let id: Int
    let name: String
    var category: String
    let price: Int
    let img: String?
}

struct DishesResponse: Codable {
    var dishes: [Dish]
}

enum methodButton {
    case plus
    case minus
}

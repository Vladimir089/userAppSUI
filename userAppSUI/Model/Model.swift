//
//  Model.swift
//  userAppSUI
//
//  Created by Владимир Кацап on 25.05.2024.
//

import Foundation
import ActivityKit

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

struct Dost: ActivityAttributes{
    public struct ContentState: Codable, Hashable {
        var id: Int
        var isHighlighted: Bool
        var time: String
        var message: String
        var wasFirstStepCompleted: Bool
        var wasSecondStepCompleted: Bool
        var wasThirdStepCompleted: Bool
        var imageOne: String
        var imageTwo: String
        var imageThree: String
        var date: Date
        var step: Int
    }
    var id: Int
   
}


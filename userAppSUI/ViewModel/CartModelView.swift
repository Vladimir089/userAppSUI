//
//  CartModelView.swift
//  userAppSUI
//
//  Created by Владимир Кацап on 30.05.2024.
//

import Foundation
import Alamofire

var totalCoast = 0
var adressCoast = 0

class CartModelView: ObservableObject {
    
    func getTotalCoast(adress: String?, order: Order, completion: @escaping () -> Void) {
        let headers: HTTPHeaders = [.accept("application/json")]

        // Преобразовываем каждый OrderItem в строку в формате "name-quantity"
        let menuStrings = order.orderArr.map { item in
            return "\(item.name) - \(item.quantity)"
        }

        
        let menu = menuStrings.joined(separator: ", ")
       
        let adresText: String = adress ?? ""
        AF.request("http://arbamarket.ru/api/v1/main/get_total_cost/?menu=\(menu)&address=\(String(describing: adresText))", method: .get, headers: headers).responseJSON { response in
            debugPrint(response)
            print(menu)
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any] {
                    if let totalCost = json["total_cost"] as? Int,
                       let addressCost = json["address_cost"] as? Int {
                        totalCoast = totalCost
                        adressCoast = addressCost
                        
                        print(adressCoast)
                        print(totalCoast)
                    }
                } else {
                    print("Invalid JSON format")
                }

            case .failure(let error):
                print("Request failed with error:", error)
            }
            completion()
        }
    }

}

//
//  ViewModelOnContentView.swift
//  userAppSUI
//
//  Created by Владимир Кацап on 25.05.2024.
//

import Foundation
import Alamofire
import AlamofireImage


let cafeID = 2
let token  = "73d2b9b6a303857b5854479692b05bd01defb73fb86fc5350689de1b637b764859b8993cb6b66870b3bac0c933d4d273a2e9d7a1c8ba0eabc0e03d083171c095c3da671d85336cff9e0abe44324489c7188b6c91e74d8043fabaecf6b4df2b0ceeee4e9ba19887b6372e1c4f8e2fe55c2058ffdedd022af452d2dd9db698853a"


class Networking: ObservableObject {
    
    @Published var arrCategories = [String]()
    @Published var allDishes: [(Dish, Image)] = []
    @Published var isDataLoaded = false
    @Published var adress: String = ""
    @Published var pribor = 1
    @Published var commentOrder = ""
    @Published var summ = 0
    
    func getDishes(completion: @escaping(Error?)-> Void) {
        let headers: HTTPHeaders = [.authorization(bearerToken: token)]
        AF.request("http://arbamarket.ru/api/v1/main/get_dishes/?cafe_id=\(cafeID)", method: .get, headers: headers).response { response in
            debugPrint(response)
            switch response.result {
            case .success(_):
                if let status = response.response?.statusCode {
                    if status == 502 || status == 400 {
                        let error = NSError(domain: "", code: 502, userInfo: [NSLocalizedDescriptionKey : "Bad Gateway"])
                        completion(error)
                        return
                    }
                }
                if let data = response.data, let dishResponse = try? JSONDecoder().decode(DishesResponse.self, from: data) {
                    let dishes = dishResponse.dishes
                    
                    let group = DispatchGroup()
                    
                    for dish in dishes {
                        var modifiedDish = dish
                        let separatedStrings = dish.category.components(separatedBy: CharacterSet.decimalDigits.union(.punctuationCharacters))
                        modifiedDish.category = separatedStrings.joined(separator: "").trimmingCharacters(in: .whitespaces).uppercased()
                        self.checkCategory(category: modifiedDish.category)
                        group.enter()
                        self.getImage(d: modifiedDish) {
                            group.leave()
                        }
                    }
                    group.notify(queue: .main) {
                        self.isDataLoaded = true
                        completion(nil)
                        
                    }
                } else {
                    completion(nil)
                }
            case .failure(let error):
                print("error getDishes")
                completion(error)
            }
        }
    }
    
    func getImage(d: Dish, completion: @escaping () -> Void) {
        if let url = d.img {
            AF.request("http://arbamarket.ru\(url)").responseImage { response in
               print("http://arbamarket.ru\(url)")
                switch response.result {
                case .success(let image):
                    self.allDishes.append((d, image))
                case .failure(_):
                    self.allDishes.append((d, Image(resource: .standart)))
                }
                completion()
            }
        } else {
            completion()
        }
    }
    
   
    
    
    func checkCategory(category: String) {
        if !arrCategories.contains(category) {
            arrCategories.append(category)
        }
    }
    
    
    func getAdress(adres: String, completion: @escaping ([String]) -> Void) {
        let headers: HTTPHeaders = [.accept("application/json")]
        AF.request("http://arbamarket.ru/api/v1/main/get_similar_addresses/?value=\(adres)", method: .get, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                guard let json = value as? [String: Any] else {
                    print("Invalid JSON format")
                    return
                }
                if let fullAddresses = json["full_addresses"] as? [String] {
                    completion(fullAddresses)
                }
            case .failure(let error):
                print("Request failed with error:", error)
            }
        }
    }
    
    
    
}

struct OrderItem: Identifiable {
    var id = UUID()
    var name: String
    var quantity: Int
    var image: Image
    var price: Int
}

class Order: ObservableObject {
    @Published var orderArr: [OrderItem] = []
}

//
//  ViewModelOnContentView.swift
//  userAppSUI
//
//  Created by Владимир Кацап on 25.05.2024.
//

import Foundation
import Alamofire
import AlamofireImage
import Kingfisher
import UIKit



var orderID = ["orderId": Int(), "date": Date(), "message": "Начинаем готовить Ваш заказ...", "step": Int()] as [String : Any]


class Networking: ObservableObject {
    
    @Published var arrCategories = [String]()
    @Published var allDishes: [(Dish, Image)] = []
    @Published var isDataLoaded = false
    @Published var adress: String = ""
    @Published var pribor = 1
    @Published var commentOrder = ""
    @Published var summ = 0
    @Published var phoneNumber = ""
    @Published var totalCoast = 0
    @Published var adressCoast = 0
    
    //cafe info
    @Published var cafeID = 0
    @Published var token  = ""

    
    
    func checkuser() {
        if let phoneKey = UserDefaults.standard.string(forKey: "number")  {
            phoneNumber = phoneKey
        }
        if let adresKey = UserDefaults.standard.string(forKey: "adres")  {
            adress = adresKey
        }
        if UserDefaults.standard.object(forKey: "idd") != nil {
            let idKey = UserDefaults.standard.object(forKey: "idd")
            orderID = idKey as! [String : Any]
        }
    }
    
    func getDishes(completion: @escaping(Error?)-> Void) {
        
        let headers: HTTPHeaders = [.authorization(bearerToken: token)]
        AF.request("http://arbamarket.ru/api/v1/main/get_dishes/?cafe_id=\(cafeID)", method: .get, headers: headers).response { response in
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
            
            KingfisherManager.shared.retrieveImage(with: URL(string: "http://arbamarket.ru\(url)")!) { response in
                switch response {
                case .success(let image):
                    self.allDishes.append((d, image.image))
                case .failure(let error):
                    self.allDishes.append((d, .bairam ))
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
        AF.request("http://arbamarket.ru/api/v1/main/get_similar_addresses/?cafe_id=\(cafeID)&value=\(adres)", method: .get, headers: headers).responseJSON { response in
            //debugPrint(response)
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
    
    func adressCost(adres: String) {
        let headers: HTTPHeaders = [.accept("application/json")]
        let adresText: String = adress ?? ""
        AF.request("http://arbamarket.ru/api/v1/main/get_total_cost/?cafe_id=\(cafeID)&menu=\(0)&address=\(String(describing: adresText))", method: .get, headers: headers).responseJSON { response in
            //debugPrint(response)
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any] {
                    if let totalCost = json["total_cost"] as? Int,
                       let addressCost = json["address_cost"] as? Int {
                        self.adressCoast = addressCost
                        self.totalCoast += self.adressCoast
                    }
                } else {
                    print("Invalid JSON format")
                }

            case .failure(let error):
                print("Request failed with error:", error)
            }
        }
    }
    
    
    func getTotalCoast(adress: String?, order: Order, completion: @escaping () -> Void) {
        let headers: HTTPHeaders = [.accept("application/json")]

        // Преобразовываем каждый OrderItem в строку в формате "name-quantity"
        let menuStrings = order.orderArr.map { item in
            return "\(item.name) - \(item.quantity)"
        }

        
        let menu = menuStrings.joined(separator: ", ")
       
        let adresText: String = adress ?? ""
        AF.request("http://arbamarket.ru/api/v1/main/get_total_cost/?cafe_id=\(cafeID)&menu=\(menu)&address=\(String(describing: adresText))", method: .get, headers: headers).responseJSON { response in
            //debugPrint(response)
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any] {
                    if let totalCost = json["total_cost"] as? Int,
                       let addressCost = json["address_cost"] as? Int {
                        self.totalCoast = totalCost
                        self.adressCoast = addressCost
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
    
    
    func createNewOrder(phonee: String, menuItems: String, clientsNumber: Int, adres: String, totalCost: Int, paymentMethod: String, timeOrder: String, cafeID: Int, completion: @escaping (Bool) -> Void) {
        let headers: HTTPHeaders = [
            HTTPHeader.accept("application/json"),
            HTTPHeader.contentType("application/json"),
            HTTPHeader.authorization(bearerToken: token)
        ]
        
        
        let parameters: [String : Any] = [
            "phone": phonee,
            "menu_items": menuItems,
            "clients_number": commentOrder, //clientsNumbr
            "address": adress,
            "total_cost": totalCoast,
            "payment_method": "Наличка",
            //"order_on_time": timeOrder,  // к определенному времени
            "cafe_id": cafeID
            
        ]
        
        if phonee == "" || menuItems == "" || clientsNumber == 0 || adress == "" || totalCost == 0 {
            completion(false)
            return
        }
        
        AF.request("http://arbamarket.ru/api/v1/main/create_order/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let data):
                if let jsonData = data as? [String: Any] {
                    if let orderId = jsonData["order_id"] as? Int {
                        UserDefaults.standard.setValue(phonee, forKey: "number")
                        UserDefaults.standard.setValue(adres, forKey: "adres")
                        orderID = ["orderId": orderId, "date": Date.now, "message": "Начинаем готовить Ваш заказ...", "step": 1]
                        UserDefaults.standard.setValue(orderID, forKey: "idd")
                        //print(orderID)
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            case .failure(_):
                completion(false)
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

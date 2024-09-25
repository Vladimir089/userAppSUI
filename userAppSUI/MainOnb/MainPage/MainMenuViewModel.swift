//
//  MainMenuViewModel.swift
//  userAppSUI
//
//  Created by Владимир Кацап on 16.08.2024.
//

import Foundation
import SwiftUI
import UIKit
import Alamofire


class MainMenuViewModel: ObservableObject {
    @Published var selectedRegion = "Учкекен"
    @Published var profileImage: Data = (UIImage.elon.jpegData(compressionQuality:1) ?? Data())
    @Published var isAuth = true
    @Published var token = ""
    @Published var phoneNumber = ""
    
    
    
    
    //auth
    func authNumberPhone(phone: String, completion: @escaping (Bool) -> Void) {
        // Параметры для запроса
        let parameters: [String: Any] = [
            "phone": phone
        ]
        
        AF.request("http://arbamarket.ru/api/v1/accounts/login_client_app/",
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default)
        .validate()
        .responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any],
                   let authToken = json["auth_token"] as? String {
                    self.token = authToken
                    completion(true)
                }
            case .failure(let error):
                print("Error: \(error)")
                completion(false)
            }
        }
    }
    
    func verifyCode(code: String, token: String, completion: @escaping (Bool) -> Void) {
        // Параметры для запроса
        let parameters: [String: Any] = [
            "code": code,
        ]
        
        let headers: HTTPHeaders = [HTTPHeader.authorization(bearerToken: token)]
        
        AF.request("http://arbamarket.ru/api/v1/accounts/verify_code_client_app/",
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers)
        .validate()
        .responseJSON { response in
            //debugPrint(response)
            switch response.result {
            case .success(let value):
                print("Success with JSON: \(value)")
                completion(true) // Возвращаем true в случае успеха
            case .failure(let error):
                print("Error: \(error)")
                completion(false) // Возвращаем false в случае ошибки
            }
        }
    }
    
    func saveToken() {
        UserDefaults.standard.setValue(String(token), forKey: "TokenNew")
    }
    
    func savePhone(phone: String) {
        UserDefaults.standard.setValue(String(phone), forKey: "phoneNumber")
    }
    
    func checkToken() {
        if let token = UserDefaults.standard.object(forKey: "TokenNew") as? String {
            self.token = token
            isAuth = true
        } else {
            isAuth = false
        }
        
        if let phone = UserDefaults.standard.object(forKey: "phoneNumber") as? String {
            self.phoneNumber = phone
        }
    }
    
    
    
    
}

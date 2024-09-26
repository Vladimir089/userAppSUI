//
//  SelectCategoryNetWorking.swift
//  userAppSUI
//
//  Created by Владимир Кацап on 25.09.2024.
//

import Foundation
import Combine
import Alamofire
import Kingfisher
import UIKit

class SelectedEatCategory: ObservableObject {
    
    @Published var isLoading = true
    @Published var cafeArr: [Cafe] = []
    @Published var selectedCafe: Cafe?
    
    func loadCafeInfo(token: String) {
        cafeArr.removeAll()
        let headers = HTTPHeaders([.authorization(bearerToken: token)])
        
        AF.request("http://arbamarket.ru/api/v1/main/get_cafes_for_client_app/", method: .get, headers: headers).response { response in
            switch response.result {
            case .success(let data):
                if let data = data {
                    self.decodeCafeData(data)
                } else {
                    print("Ошибка: Получены пустые данные")
                    self.isLoading = false
                }
            case .failure(let error):
                print("Ошибка запроса: \(error.localizedDescription)")
                self.isLoading = false
            }
        }
    }

    private func decodeCafeData(_ data: Data) {
        do {
            let cafeResponse = try JSONDecoder().decode(CafeResponse.self, from: data)
            let cafes = cafeResponse.cafes
            self.loadCafeImages(for: cafes) { updatedCafes in
                self.cafeArr = updatedCafes
                self.isLoading = false
            }
        } catch {
            print("Ошибка декодирования данных: \(error.localizedDescription)")
            self.isLoading = false
        }
    }


    func loadCafeImages(for cafes: [Cafe], completion: @escaping ([Cafe]) -> Void) {
        var updatedCafes = cafes
        let group = DispatchGroup()
        
        for index in updatedCafes.indices {
            let imageFolderUrl = updatedCafes[index].img
            guard let url = URL(string: "http://arbamarket.ru\(imageFolderUrl)") else { continue }
            
            group.enter()
            
            KingfisherManager.shared.retrieveImage(with: url) { response in
                switch response {
                case .success(let result):
                    updatedCafes[index].image = result.image.pngData()
                case .failure(let error):
                    updatedCafes[index].image = UIImage(named: "standartCafeIcon")?.pngData()
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(updatedCafes)
        }
    }

}

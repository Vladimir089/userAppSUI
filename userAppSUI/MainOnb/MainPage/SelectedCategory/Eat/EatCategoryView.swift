//
//  EatCategoryView.swift
//  userAppSUI
//
//  Created by Владимир Кацап on 25.09.2024.
//

import SwiftUI
import Lottie

struct EatCategoryView: View {
    
    var token: String
    @ObservedObject private var mainWork = SelectedEatCategory()
    @State private var searchText = ""
    
    var filteredCafeArr: [Cafe] {
        if searchText.isEmpty {
            return mainWork.cafeArr
        } else {
            return mainWork.cafeArr.filter { cafe in
                cafe.title.lowercased().contains(searchText.lowercased()) ||
                cafe.number.contains(searchText) ||
                cafe.address.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    init(token: String) {
        self.token = token
        mainWork.loadCafeInfo(token: token)
    }
    
    
    var body: some View {
        VStack {
            if mainWork.isLoading {
                LottieView(animation: .named("LoadPageEat"))
                    .resizable()
                    .playing()
                    .looping()
                    .frame(width: 100, height: 100)
            } else {
                VStack {
                    // Поисковая строка
                    TextField("Search by title, number, or address", text: $searchText)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal)
                    
                    // Коллекция кафе
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
                            ForEach(filteredCafeArr) { cafe in
                                VStack {
                                    
                                    if let imageData = cafe.image, let uiImage = UIImage(data: imageData) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 100, height: 100)
                                            .cornerRadius(8)
                                    }
                                    
                                    Text(cafe.title)
                                        .font(.headline)
                                    
                                    Text(cafe.address)
                                        .font(.subheadline)
                                    
                                    Text(cafe.number)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                            }
                        }
                        .padding()
                    }
                    
                    
                    
                }
            }
        }
    }
    
}







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
    var numberPhone: String

    @ObservedObject private var mainWork = SelectedEatCategory()
    @State private var searchText = ""
    @State private var showSheetEat = false
    
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
    
    init(token: String, numberPhone: String) {
        self.token = token
        self.numberPhone = numberPhone
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
                    TextField("Что поесть?", text: $searchText)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                        .padding(.horizontal)
                        .shadow(radius: 5)
                    
                    // Коллекция кафе
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: .infinity))]) {
                            ForEach(filteredCafeArr) { cafe in
                                VStack {
                                    HStack {
                                        if let imageData = cafe.image, let uiImage = UIImage(data: imageData) {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 44, height: 44)
                                                .cornerRadius(8)
                                        }
                                        
                                        VStack(alignment: .leading) {
                                            Spacer()
                                            
                                            Text(cafe.title)
                                                .font(.system(size: 16, weight: .semibold))
                                                .foregroundColor(Color.black)
                                            
                                            Text(cafe.address)
                                                .font(.system(size: 13, weight: .regular))
                                                .foregroundColor(.gray)

                                            Rectangle()
                                                .offset(y: -5)
                                                .foregroundColor(Color.gray)
                                                .frame(height: 0.3)
                                        }
                                        
                                    }
                                    .padding(.horizontal)
                                    
                                   

                                }
                                .padding(.bottom, 3)
                                .onTapGesture {
                                    mainWork.selectedCafe = cafe
                                    showSheetEat = true
                                }
                            }
                            
                        }
                        .padding()
                        
                    }
                }
            }
        }
        .onAppear(perform: {
            
            mainWork.loadCafeInfo(token: token)
        })
        .fullScreenCover(isPresented: $showSheetEat) {
            if let cafe = mainWork.selectedCafe {
                ContentView(isShowingDetail: $showSheetEat, token: token, cafe:  cafe, phone: numberPhone)
            }
        }


    }

      
    
}







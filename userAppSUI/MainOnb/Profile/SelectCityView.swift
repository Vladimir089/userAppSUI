//
//  SelectCityView.swift
//  userAppSUI
//
//  Created by Владимир Кацап on 01.10.2024.
//

import SwiftUI

struct SelectCityView: View {
    @Binding var selectedCity: String
    @Binding var isOpen: Bool
    
    @State  var newCity = ""
    
     var cities = ["Учкекен", "Качканар", "Черкесск", "Карачаевск", "Теберда", "Преградная", "Чапаевское", "Терезе", "Ударный", "Архыз" , "Кумыш", "Сторожевая", "Первомайское"]
    
    var body: some View {
        VStack {
            TextField("Город", text: $newCity)
                .foregroundStyle(.black)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.figmaOrange, lineWidth: 2) // Добавляем рамку с закругленными краями
                )
                .cornerRadius(10)
                
                .ignoresSafeArea(.keyboard, edges: .all)
                .padding()
            
            List {
                ForEach(cities.filter { newCity.isEmpty || $0.contains(newCity) }, id: \.self) { city in
                    Button(action: {
                        selectedCity = city // Устанавливаем выбранный город
                        UserDefaults.standard.set(selectedCity, forKey: "SelectedCity")
                        isOpen = false
                    }) {
                        Text(city)
                            .foregroundColor(.black)
                            .padding()
                    }
                    .buttonStyle(PlainButtonStyle()) // Убираем стандартный стиль кнопки
                }
            }
            .listStyle(PlainListStyle()) // Убираем стандартный стиль списка
            
            
            Spacer()
        }
    }
}



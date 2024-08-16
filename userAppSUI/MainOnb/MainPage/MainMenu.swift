//
//  MainMenu.swift
//  userAppSUI
//
//  Created by Владимир Кацап on 16.08.2024.
//

import SwiftUI



struct MainMenu: View {
    
    @ObservedObject var mainMenuModel = MainMenuViewModel()
    
   
    
    var body: some View {
        VStack {
            
            
            HStack {
                Spacer()
                Button("\(mainMenuModel.selectedRegion)") {
                    print("Выбор")
                }
                .font(.system(size: 15))
            }
            
            
            HStack {
                Text("Экосистема")
                    .font(.system(size: 34, weight: .bold))
                
                Spacer()
                
                Image(uiImage: UIImage(data: mainMenuModel.profileImage) ?? UIImage())
                    .resizable()
                    .frame(width: 30, height: 30)
            }
            
            
            HStack {
                Text("Куда угодно, когда удобно")
                    .font(.system(size: 20, weight: .light))
                Spacer()
            }
            
            HStack {

                Button(action: {
                    print(23)
                }) {
                    Image(.taxi)
                        
                        .resizable()
                        .frame(width: 170, height: 194)
                        
                }
                .frame(width: 170, height: 194)
                .padding()
                
                Spacer()
                
                VStack {
                    Button(action: {
                        print(23)
                    }) {
                        Image(.eat)
                            .resizable()
                            .frame(width: 170, height: 94)
                    }
                    .frame(width: 170, height: 94)
                    
                    Button(action: {
                        print(23)
                    }) {
                        Image(.avit)
                            .resizable()
                            .frame(width: 170, height: 94)
                    }
                    .frame(width: 170, height: 94)
                }
                Spacer()
                
            }
            
            
            VStack {
                Text("контент")
            }
            
            
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    MainMenu()
}

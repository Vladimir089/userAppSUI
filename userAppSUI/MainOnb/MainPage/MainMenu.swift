//
//  MainMenu.swift
//  userAppSUI
//
//  Created by Владимир Кацап on 16.08.2024.
//

import SwiftUI



struct MainMenu: View {
    
    @ObservedObject var mainMenuModel = MainMenuViewModel()
    @State private var showSheetEat = false
    
   
    
    var body: some View {
        NavigationView {
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
                    
                    Button(action: {
                        print(23)
                    }) {
                        Image(uiImage: UIImage(data: mainMenuModel.profileImage) ?? UIImage())
                        
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                    }
                    .frame(width: 30, height: 30)
                    .padding()
                    
                    
                    
                    
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
                    .disabled(true)
                    
                    Spacer()
                    
                    VStack {
                        Button(action: {
                            showSheetEat.toggle()
                            
                        }) {
                            Image("eat")
                                .resizable()
                                .frame(width: 170, height: 94)
                        }
                        .frame(width: 170, height: 94)
                        .fullScreenCover(isPresented: $showSheetEat) {
                            ContentView(isShowingDetail: $showSheetEat, token: mainMenuModel.token, cafeID: 2)
                        }

                       
                        
                        Button(action: {
                            print(23)
                        }) {
                            Image(.avit)
                                .resizable()
                                .frame(width: 170, height: 94)
                        }
                        .frame(width: 170, height: 94)
                        .disabled(true)
                    }
                    Spacer()
                    
                }
                
                
                VStack {
                    Text("прочий контент")
                }
                
                
                
                Spacer()
            }
            .padding().onAppear(perform: {
                mainMenuModel.checkToken()
            })
            
            .fullScreenCover(isPresented: Binding<Bool>(
                get: { !mainMenuModel.isAuth },
                set: { _ in }
            )) {
                AuthView(mainMenuModel: mainMenuModel, numbTel: "+7")
            }
        }
    }
}

//#Preview {
//    MainMenu()
//}
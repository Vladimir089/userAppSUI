//
//  ProfileView.swift
//  userAppSUI
//
//  Created by Владимир Кацап on 30.09.2024.
//

import SwiftUI
import WebKit
import SwiftUIIntrospect

struct ProfileView: View {
    
    @Binding var isProfileOpen: Bool
    @Binding var phoneNumber: String
    @State var nameUser = ""
    @State private var showingWebView = false
    var menu: MainMenuViewModel
    @State private var showingAlert = false
    @State var isShowFillName = false
    
    @State var selectedCity = "Учкекен"
    @State var isSelectCity = false
    
    
    var body: some View {
        GeometryReader(content: { geometry in
         
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        Image(.settingsIco)
                            .resizable()
                            .clipShape(.buttonBorder)
                            .frame(width: 40, height: 40)
                        
                        //Spacer()
                        VStack {
                            Spacer()
                            Text("Настройки")
                                .foregroundStyle(.white)
                                .font(.system(size: 17, weight: .semibold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 0.5)
                            
                            
                          
                            Spacer()
                        }
                        
                        
                        Spacer()
                        Spacer()
                        
                        Button(action: {
                            isProfileOpen = false
                        }) {
                            Image(.hideVC)
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                        .frame(width: 30, height: 30)
                    }
                    .padding(.horizontal, 10)
                    .padding(.bottom, 40)
                    .frame(maxWidth: .infinity) // Для ширины
                    .frame(height: 100) // Для высоты
                    .background(Color.figmaOrange)
                    
                    VStack {
                        
                        Form {
                            
                            Section {
                                ZStack {
                                    // Добавляем тень на фоне
                                    HStack {
                                        Image(.imageUser)
                                            .resizable()
                                            .frame(width: 60, height: 60)
                                        
                                        VStack {
                                            ZStack {
                                                TextField("Как тебя зовут?", text: $nameUser)
                                                    .foregroundStyle(.black)
                                                    .font(.system(size: 23, weight: .regular))
                                                    .disabled(true) // Отключаем ввод текста
                                                    
                                                Button(action: {
                                                    isShowFillName = true // Ваше действие при нажатии
                                                }) {
                                                    // Прозрачная кнопка
                                                    Rectangle()
                                                        .foregroundColor(.clear) // Делаем кнопку прозрачной
                                                }
                                                .contentShape(Rectangle()) // Ограничиваем область нажатия размером TextField
                                            }

                                            Text(phoneNumber)
                                                .foregroundStyle(.black)
                                                .font(.system(size: 15, weight: .light))
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                //.offset(x: 0, y: -15)
                                        }
                                        .padding(.leading, 5)
                                    }
                                    .frame(maxHeight: 50)
                                    
                                }
                                //.frame(maxHeight: 50)

                                Button(selectedCity) {
                                   isSelectCity = true
                                }
                                .foregroundStyle(.black)
                               
                            }
                            .listRowBackground(Color.black.opacity(0.05))

                            
                            
                            Section {
                                NavigationLink("Адреса") {
                                    Text("Это новый экран Адреса")
                                }
                                .foregroundColor(.black)
                                .font(.system(size: 23, weight: .light))
                                .frame(height: 50)
                                
                                NavigationLink("Заказы") {
                                    Text("Это новый экран Заказы")
                                }
                                .foregroundColor(.black)
                                .font(.system(size: 23, weight: .light))
                                .frame(height: 50)
                                
                                NavigationLink("Подписка") {
                                    Text("Это новый экран Подписка")
                                }
                                .foregroundColor(.black)
                                .font(.system(size: 23, weight: .light))
                                .frame(height: 50)
                                
                                NavigationLink("Настройки ") {
                                    Text("Это новый экран Настройки")
                                }
                                .foregroundColor(.black)
                                .font(.system(size: 23, weight: .light))
                                .frame(height: 50)
                            }
                            .listRowBackground(Color.white)
                            
                            
                            
                        }
                        .scrollDisabled(true)
                        .scrollContentBackground(.hidden)
                        
                        
                        
                        .foregroundColor(.white)
                        .background(.white)
                        .cornerRadius(16)
                        .frame(height: 500)
                        
                        Button {
                            showingAlert = true
                        } label: {
                            Text("Выйти")
                                .foregroundStyle(Color.white)
                                .font(.system(size: 20, weight: .bold))
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                        .frame(height: 50)
                        .background(Color(UIColor(red: 197/255, green: 197/255, blue: 199/255, alpha: 1)))
                        .clipShape(Capsule())
                        .contentShape(Capsule())
                        .padding(.horizontal)
                        .alert(isPresented: $showingAlert) {
                            Alert(
                                title: Text("Выход"),
                                message: Text("Вы действительно хотите выйти? Потребуется повторная авторизация"),
                                primaryButton: .destructive(Text("Выйти")) {
                                    // Действия, выполняемые после подтверждения
                                    UserDefaults.standard.removeObject(forKey: "nameUser")
                                    UserDefaults.standard.removeObject(forKey: "TokenNew")
                                    UserDefaults.standard.removeObject(forKey: "phoneNumber")
                                    isProfileOpen = false
                                    menu.token = ""
                                    menu.phoneNumber = ""
                                    menu.isAuth = false
                                },
                                secondaryButton: .cancel(Text("Отмена"))
                            )
                        }
                        
                        Button(action: {
                            showingWebView = true // Показать SafariView
                        }) {
                            Text("Правовые документы")
                                .foregroundColor(Color(UIColor(red: 197/255, green: 197/255, blue: 199/255, alpha: 1)))
                                .font(.system(size: 20, weight: .light))
                                .underline()
                                
                        }
                        .sheet(isPresented: $showingWebView) {
                            WebView(url: URL(string: "https://www.termsfeed.com/live/84d45da4-1d6a-49d8-92fa-1bb28feb9322")!)
                        }
                        .sheet(isPresented: $isShowFillName) {
                            FillNameinProfile(name: $nameUser)
                                .presentationDetents([.fraction(0.2), .large])
                                .ignoresSafeArea(.keyboard)
                        }
                        .sheet(isPresented: $isSelectCity) {
                            SelectCityView(selectedCity: $selectedCity, isOpen: $isSelectCity)
                                .presentationDetents([.medium, .large])
                                .ignoresSafeArea(.keyboard)
                        }
                        
                        
                        
                        
                    }
                    .offset(x: 0, y: -50)
                    
                    
                    Spacer()
                    
                }
            }
            .onAppear {
                if let savedName = UserDefaults.standard.string(forKey: "nameUser") {
                    nameUser = savedName
                }

                if let selectCity = UserDefaults.standard.string(forKey: "SelectedCity") {
                    selectedCity = selectCity
                }
            }
            .contentShape(Rectangle()) // Чтобы весь ZStack реагировал на нажатия
            
        }
            
        })
        .ignoresSafeArea(.keyboard, edges: .all)
    }
}

extension UIApplication {
    func hideKeyboard() {
        guard let window = windows.first else { return }
        window.endEditing(true)
    }
}


struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}

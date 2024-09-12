//
//  AuthView.swift
//  userAppSUI
//
//  Created by Владимир Кацап on 14.08.2024.
//



import SwiftUI



struct AuthView: View {
    
    @ObservedObject var mainMenuModel: MainMenuViewModel
    @State var numbTel = "+7"
    
    
    @State var isSuccesAuth = false
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("Укажитe телефон")
                    .font(.system(size: 26, weight: .bold))
                Text("Сможете сохранять адреса \n доставки")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 15, weight: .light))
                
                TextField("+7", text: $numbTel)
                    .padding()
                    .keyboardType(.numberPad)
                    .background(Color.white)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(Color.black, lineWidth: 1)
                    )
                    .padding()
                    .onChange(of: numbTel) { newValue in
                        // Ограничиваем возможность изменения префикса "+7"
                        if !newValue.hasPrefix("+7") {
                            numbTel = "+7" + newValue.drop(while: { $0 == "+" || $0 == "7" })
                        }
                        
                        // Ограничиваем максимальное количество символов до 12
                        if numbTel.count > 12 {
                            numbTel = String(numbTel.prefix(12))
                        }
                    }
                
                
                Text("Продолжая, вы соглашаетесь с условиями наших юридических документов")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(.black.opacity(0.4))
                
                Spacer()
                
                
                Button(action: {
                    mainMenuModel.authNumberPhone(phone: numbTel) { success in
                        if success {
                            isSuccesAuth = true
                        } else {
                            print("Ошибка аутентификации.")
                            isSuccesAuth = false
                        }
                    }
                }) {
                    Text("Продолжить")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .bold))
                        .padding() // Отступы добавляются здесь
                        .frame(maxWidth: .infinity, minHeight: 50) // Размеры задаются после отступов
                        .background(numbTel.count == 12 ? Color.blue : Color.gray)
                        .clipShape(Capsule())
                        .contentShape(Capsule()) // Область нажатия определяется здесь
                }
                .disabled(numbTel.count < 12)

                
                NavigationLink(
                    destination: AuthCode(mainMenuModel: mainMenuModel, number: numbTel),
                    isActive: $isSuccesAuth
                ) {
                    EmptyView()
                }
                
                Spacer()
                Spacer()
                Spacer()
            }
            .padding()
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Это нужно для устранения проблем на iPad
        .navigationBarBackButtonHidden(true)
    }
}



//
//  AuthView.swift
//  userAppSUI
//
//  Created by Владимир Кацап on 14.08.2024.
//



import SwiftUI



struct AuthView: View {
    
    @State var numbTel = "+7"
    
    var body: some View {
        Spacer()
        VStack {
            Spacer()
            Text("Укажитe телефон")
                .font(.system(size: 26, weight: .bold))
            Text("Сможете сохранять адреса \n доставки")
                .multilineTextAlignment(.center)
                .font(.system(size: 15, weight: .light))
            
            TextField("+7", text: $numbTel)
                .padding()
                .background(Color.white)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(Color.black, lineWidth: 1)
                )
                .padding()
            
            Text("Продолжая, вы соглашаетесь с условиями наших юридических документов")
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(.black.opacity(0.4))
            
            Spacer(minLength: 100)
            
            HStack {
                Button("Продолжить") {
                    print(1)
                }
                .padding()
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .bold))
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                
                .clipShape(.capsule)
                
            }
            .padding()
            
            Spacer()
            Spacer()
            
        }
    }
}

#Preview {
    AuthView()
}

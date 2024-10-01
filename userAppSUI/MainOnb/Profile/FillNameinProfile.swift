//
//  FillNameinProfile.swift
//  userAppSUI
//
//  Created by Владимир Кацап on 01.10.2024.
//

import SwiftUI

struct FillNameinProfile: View {
    
    @Binding var name: String
    
    var body: some View {
        
        GeometryReader(content: { geometry in
            VStack {
               
                
                TextField("Как тебя зовут?", text: $name)
                    .foregroundStyle(.black)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.figmaOrange, lineWidth: 2) // Добавляем рамку с закругленными краями
                    )
                    .cornerRadius(10)
                    .onChange(of: name) { newValue in
                        UserDefaults.standard.set(newValue, forKey: "nameUser")
                    }
                    .ignoresSafeArea(.keyboard, edges: .all)
                   
                

                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical)
            .ignoresSafeArea(.keyboard, edges: .all)
        })
        .ignoresSafeArea(.keyboard)
       
       
    }
    
}


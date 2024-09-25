//
//  Onboarding.swift
//  userAppSUI
//
//  Created by Владимир Кацап on 25.09.2024.
//

import SwiftUI

struct Onboarding: View {
    @State private var isActive = false

    var body: some View {
        NavigationView {
            VStack {
                Image("OnboardingImage")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.isActive = true
                        }
                    }

                NavigationLink(destination: MainMenu(), isActive: $isActive) {
                    EmptyView()
                }
            }
            .navigationBarHidden(true)
        }
        .navigationBarHidden(true)
    }
}


import SwiftUI

struct MainMenu: View {
    
    @ObservedObject var mainMenuModel = MainMenuViewModel()
    
    @State private var selectedCategory = "Eat"
    
    var body: some View {
        NavigationView {
            ZStack {
                // Содержимое ScrollView
                ScrollView {
                    VStack(spacing: 20) {
                        HStack {
                            Text("Куда угодно, когда удобно")
                                .font(.system(size: 20, weight: .light))
                            Spacer()
                        }
                        .padding(.horizontal, 15)
                        
                        HStack {
                            Button(action: {
                                selectedCategory = "Taxi"
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
                                    
                                    selectedCategory = "Eat"
                                }) {
                                    Image("eat")
                                        .resizable()
                                        .frame(width: 170, height: 94)
                                }
                                .frame(width: 170, height: 94)
                                
                                
                                Button(action: {
                                    selectedCategory = "Announcements"
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
                            switch selectedCategory {
                            case "Eat":
                                EatCategoryView(token: mainMenuModel.token, numberPhone: mainMenuModel.phoneNumber)
                            case "Taxi", "Announcements":
                                Text("Скоро!")
                            default:
                                Text("select category")
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.top, 45)
                }
                
                // Размытие фона
                VStack {
                    HStack {
                        Text("Экосистема")
                            .font(.system(size: 34, weight: .bold))
                        
                        Spacer()
                        
                        Button(action: {
                            print("profile")
                        }) {
                            Image(uiImage: UIImage(data: mainMenuModel.profileImage) ?? UIImage())
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                        .frame(width: 30, height: 30)
                    }
                    .padding(.horizontal)
                    .background(
                        Color.white.opacity(0.95)
                    )
                }
                .frame(maxHeight: .infinity, alignment: .top)
            }
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .onAppear(perform: {
                mainMenuModel.checkToken()
            })
            .fullScreenCover(isPresented: Binding<Bool>(
                get: { !mainMenuModel.isAuth },
                set: { _ in }
            )) {
                AuthView(mainMenuModel: mainMenuModel, numbTel: "+7")
            }
        }
        .navigationBarHidden(true)
    }
}

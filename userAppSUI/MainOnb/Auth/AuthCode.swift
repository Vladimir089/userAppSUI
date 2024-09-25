//
//  AuthCode.swift
//  userAppSUI
//
//  Created by Владимир Кацап on 31.08.2024.
//

import SwiftUI



struct AuthCode: View {
    
    @ObservedObject var mainMenuModel: MainMenuViewModel
    @State var number:String
    
    @State private var shakeOffset: CGFloat = 0
    
    @State private var isError: Bool = false
    
    @State private var code: String = ""
    @FocusState private var isTextFieldFocused: Bool
    
    @State private var isButtonDisabled: Bool = false
    @State private var timer: Timer?
    @State private var timeRemaining: Int = 0
    @State private var isShowTimer = false
    
    var body: some View {
        VStack {
            Spacer()
            Text("Теперь введите код")
                .font(.system(size: 26, weight: .bold))
            Text("Код отправлен на номер")
            Text(number)
            HStack(spacing: 15) {
                ForEach(0..<4) { index in
                    Circle()
                        .strokeBorder(isError ? .red : .figmaOrange, lineWidth: 1)
                        .background(
                            Circle()
                                .foregroundColor(index < code.count ? (isError ? .red : .figmaOrange) : .clear)
                        )
                        .frame(width: 10, height: 10)
                        .offset(x: shakeOffset) // Применяем смещение
                        .animation(.default, value: shakeOffset)
                }
            }
            .padding()
            
            TextField("", text: $code)
                .frame(width: 0, height: 0)
                .keyboardType(.numberPad)
                .focused($isTextFieldFocused)
                .onChange(of: code) { newValue in
                    if newValue.count > 4 {
                        code = String(newValue.prefix(4))
                    }
                    
                    if newValue.count == 4 {
                        print("Введенный код: \(code)")
                        mainMenuModel.verifyCode(code: code, token: mainMenuModel.token) { success in
                            mainMenuModel.verifyCode(code: code, token: mainMenuModel.token) { success in
                                if success {
                                    mainMenuModel.saveToken()
                                    mainMenuModel.savePhone(phone: number)
                                    mainMenuModel.phoneNumber = number
                                    mainMenuModel.isAuth = true
                                    let feedbackGenerator = UIImpactFeedbackGenerator(style: .soft)
                                    feedbackGenerator.prepare()
                                    feedbackGenerator.impactOccurred()
                                } else {
                                    triggerShakeEffect()
                                    let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
                                    feedbackGenerator.prepare()
                                    feedbackGenerator.impactOccurred()
                                }
                            }                        }
                        
                    }
                }
                .onAppear {
                    isTextFieldFocused = true // Автоматически активируем клавиатуру
                }
            
            Spacer()
            
            
            Button(action: {
                if !isButtonDisabled {
                    mainMenuModel.authNumberPhone(phone: number) { success in
                        if success {
                            withAnimation {
                                shakeDots()
                            }
                        }
                    }
                    print("Получить новый код: \(number)")
                    startTimer()
                }
            }) {
                Text("Получить новый код")
                    .padding()
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .background(isButtonDisabled ? Color.gray : Color.figmaOrange)
                    .clipShape(Capsule())
                    .padding()
                    .contentShape(Capsule())
                    .disabled(isButtonDisabled)
                    .onAppear {
                        resetTimer()
                    }
                    .onDisappear {
                        timer?.invalidate()
                    }
            }
           
            
            

            
            Text("Повторная отправка через \(timeRemaining) сек.")
                .font(.system(size: 16))
                .foregroundColor(isButtonDisabled ? .gray : .clear)
            
            Spacer()
            Spacer()
            Spacer()
            
        }
        .onTapGesture {
            isTextFieldFocused = true
        }
        .navigationBarBackButtonHidden(true)
       
    }
    
    
    private func startTimer() {
        timeRemaining = 120 // 2 минуты
        isButtonDisabled = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer?.invalidate()
                isButtonDisabled = false
            }
        }
    }
    
    private func resetTimer() {
        timer?.invalidate()
        timeRemaining = 0
        isButtonDisabled = false
    }
    
    
    private func shakeDots() {
        code = ""
    }
    
    private func triggerShakeEffect() {
        isError = true
        withAnimation(Animation.default.repeatCount(3, autoreverses: true)) {
            shakeOffset = -20
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation {
                shakeOffset = 20
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation {
                shakeOffset = 0
                isError = false
                code = ""
            }
        }
    }
}

//#Preview {
//    AuthCode(mainMenuModel: MainMenuViewModel(), number: "+79821695400")
//}

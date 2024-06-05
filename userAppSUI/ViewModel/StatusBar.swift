//
//  StatusBar.swift
//  userAppSUI
//
//  Created by Владимир Кацап on 04.06.2024.
//

import Foundation
import SwiftUI
import Alamofire
import Combine
import ActivityKit

class checkStatus: ObservableObject {
    @Published var isHidden = false
    private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private var timerTime = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private var cancellable: AnyCancellable?
    private var cancellableTime: AnyCancellable?
    @Published var time = ""
    @Published var status = ""
    
    @Published var wasFirstStepCompleted = true
    @Published var wasSecondStepCompleted = false
    @Published var wasThirdStepCompleted = false
    @Published var isHighlighted = false
    @Published var isUser = false
    
    
    

    func start() {
        if UserDefaults.standard.object(forKey: "idd") != nil {
            let idKey = UserDefaults.standard.object(forKey: "idd")
            orderID = idKey as! [String : Any]
            print(orderID, 32423)
            isUser = true
            isUser = false
            startLiveActivity()
        } else {
            return
        }
        cancellable = timer.sink { _ in
            if let orderId = orderID["orderId"] as? Int {
                self.getStatusOrder(orderId: orderId){
                    if orderID["message"] as! String == "Заказ завершен" || orderID["message"] as! String == "Заказ выполнен" {
                        self.isHidden = true
                        UserDefaults.standard.removeObject(forKey: "idd")
                        self.removeLiveActivity()
                    }
                    
                }
            }
        }
        cancellableTime = timerTime.sink { _ in
            self.fullTime()
        }
    }


    init() {
        if UserDefaults.standard.object(forKey: "idd") != nil {
            let idKey = UserDefaults.standard.object(forKey: "idd")
            orderID = idKey as! [String : Any]
            print(orderID, 32423)
            isUser = true
            startLiveActivity()
        } else {
            return
        }
        
        cancellable = timer.sink { _ in
            if let orderId = orderID["orderId"] as? Int {
                self.getStatusOrder(orderId: orderId){
                    if orderID["message"] as! String == "Заказ завершен" || orderID["message"] as! String == "Заказ выполнен" {
                        self.isHidden = true
                        UserDefaults.standard.removeObject(forKey: "idd")
                        self.removeLiveActivity()
                    }
                    
                }
                
                
            }
        }
        cancellableTime = timerTime.sink { _ in
            self.fullTime()
        }
    }
    
    
    func checkStatus() -> some View {
        
        VStack {
            Spacer().frame(maxHeight: .infinity)
            ZStack {
                Rectangle()
                    .cornerRadius(25)
                    .foregroundStyle(.black)
                    .frame(height: 138)

                VStack {
                    
                    HStack {
                        Text(time)
                            .foregroundStyle(.white)
                            .font(.system(size: 36))
                            .bold()
                            .padding(.leading, 20)
                            .padding(.bottom, 65)
                        Spacer()
                        
                        Button(action: {
                            let phoneNumber = "+79380312109"
                            if let phoneURL = URL(string: "tel://\(phoneNumber)"),
                               UIApplication.shared.canOpenURL(phoneURL) {
                                UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
                            }
                        }) {
                            Image(systemName: "phone")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundStyle(.white)
                        }.frame(width: 45, height: 45)
                            .background(Color(UIColor(red: 248/255, green: 102/255, blue: 6/255, alpha: 1)))
                            .clipShape(.circle)
                            .padding(.bottom, 65)
                            .padding(.trailing, 20)
                    }
                }
            
                HStack {

                    Spacer()
                    Rectangle()
                        .foregroundColor(Color(UIColor(red: 248/255, green: 102/255, blue: 6/255, alpha: 1)))
                        .frame(width: 103, height: 5)
                        .opacity(wasFirstStepCompleted ? (isHighlighted ? 1 : 1) : 1)
                        .cornerRadius(3)

                    Spacer()
                    Rectangle()
                        .foregroundColor(wasSecondStepCompleted ? Color(UIColor(red: 248/255, green: 102/255, blue: 6/255, alpha: 1)) : Color.gray)
                        .frame(width: 103, height: 5)
                        .opacity(wasSecondStepCompleted ? (isHighlighted ? 1 : 1) : 1)
                        .cornerRadius(3)

                    Spacer()
                    Rectangle()
                        .foregroundColor(wasThirdStepCompleted ? Color(UIColor(red: 248/255, green: 102/255, blue: 6/255, alpha: 1)) : Color.gray)
                        .frame(width: 103, height: 5)
                        .opacity(wasThirdStepCompleted ? (isHighlighted ? 1 : 1) : 1)
                        .cornerRadius(3)
                    Spacer()
                }
                .padding(.top, 10)
                .padding(.trailing, 12)
                .padding(.leading, 12)
                .onAppear() {
                    withAnimation(
                        Animation.easeInOut(duration: 5).repeatForever(autoreverses: true)
                    ) {
                        self.isHighlighted.toggle()
                    }
                }
                
                VStack(alignment: .leading, content: {
                    Text(orderID["message"] as! String)
                        .font(.system(size: 20))
                        .foregroundStyle(.white)
                        .bold()
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 5)
                }).padding(.top, 70)
                    .padding(.trailing, 15)
                    .padding(.leading, 15)

                
                
                    
            }
            .padding(.horizontal, 5)
            .padding(.bottom, 40)
        }
        .opacity(isHidden ? 0 : 1)
        .onChange(of: orderID["message"] as! String) { oldValue, newValue in
            self.updateLivActivity()
        }
    }
    
    
    func startLiveActivity() {
        
        let mod = Dost(id: orderID["orderId"] as! Int)
        
        // Создаём начальное состояние со значением типа Dost.ContentState
        let initialContentState = ActivityContent(state: Dost.ContentState(id: orderID["orderId"] as! Int, isHighlighted: isHighlighted, time: time, message: orderID["message"] as! String, wasFirstStepCompleted: wasFirstStepCompleted, wasSecondStepCompleted: wasSecondStepCompleted, wasThirdStepCompleted: wasThirdStepCompleted, imageOne: "cook", imageTwo: "car", imageThree: "finish", date: (orderID["date"] as? Date)!), staleDate: nil)
        
        do {
            _ = try Activity<Dost>.request(attributes: mod, content: initialContentState)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func removeLiveActivity() {
        if let activity = Activity<Dost>.activities.last {
            Task {
                await activity.end(activity.content, dismissalPolicy: .immediate)
            }
        }
    }
    
    func updateLivActivity() {
        if let activity = Activity<Dost>.activities.last {
            let mod: Dost.ContentState = .init(id: orderID["orderId"] as! Int, isHighlighted: isHighlighted, time: time, message: orderID["message"] as! String, wasFirstStepCompleted: wasFirstStepCompleted, wasSecondStepCompleted: wasSecondStepCompleted, wasThirdStepCompleted: wasThirdStepCompleted, imageOne: "cook", imageTwo: "car", imageThree: "finish", date: (orderID["date"] as? Date)!)
            
            Task {
                await activity.update(
                    ActivityContent<Dost.ContentState>(state: mod, staleDate: nil)
                )
            }
        }
    }
    
    
    func getStatusOrder(orderId: Int, completion: @escaping () -> Void) {
        let headers: HTTPHeaders = [
            HTTPHeader.authorization(bearerToken: token)]
        
        AF.request("http://arbamarket.ru/api/v1/main/get_status_by_order_id/?order_id=\(orderId)&cafe_id=\(cafeID)", method: .get, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let data):
                print("Успешный запрос, данные получены")
                if let data = response.data, let stat = try? JSONDecoder().decode(getStatusToOrderStruct.self, from: data) {
                    if let statStatus = stat.status {
                        orderID["message"] = statStatus
                        self.status = orderID["message"] as! String

                        if self.status.first == "1" || self.status == "Начинаем готовить Ваш заказ..." {
                            self.wasFirstStepCompleted = true
                        } else if self.status.first == "2" {
                            self.wasFirstStepCompleted = true
                            self.wasSecondStepCompleted = true
                        } else if self.status.first == "3" {
                            self.wasFirstStepCompleted = true
                            self.wasSecondStepCompleted = true
                            self.wasThirdStepCompleted = true
                        }
                    }
                }
            case .failure(_):
                print(2)
            }
        }
        completion()
    }
    
    
    
    func fullTime() {
        if let orderDate = orderID["date"] as? Date {
            let now = Date()
            let elapsed = now.timeIntervalSince(orderDate)
            let hours = Int(elapsed) / 3600
            let mins = Int(elapsed) / 60 % 60
            let secs = Int(elapsed) % 60
            DispatchQueue.main.async {
                self.objectWillChange.send()
                withAnimation {
                    if hours == 0 {
                        self.time = String(format: "%02i:%02i", mins, secs )
                    } else {
                        self.time = String(format: "%02i:%02i:%02i", hours, mins, secs )
                    }
                }
            }
        }
    }
    
    
    
}


struct getStatusToOrderStruct: Codable {
    let status: String?
    let color: String?
}

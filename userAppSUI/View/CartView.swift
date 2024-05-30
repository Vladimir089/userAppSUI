//
//  CartView.swift
//  userAppSUI
//
//  Created by Владимир Кацап on 29.05.2024.
//

import SwiftUI

struct CartView: View {
    
    @ObservedObject var order: Order
    @State var selectedSegment = "Доставка"
    @State var dost = 0
    @State var adress = "df"
    
    @StateObject var modelView = CartModelView()
    
    
    
    var body: some View {
        
        VStack {
            
            Rectangle().frame(width: 50, height: 4)
                .cornerRadius(2)
                .foregroundStyle(Color(UIColor(red: 229/255, green: 229/255, blue: 230/255, alpha: 1)))
                .padding()
            
            
            
            SegmentedPicker(selectedSegment: $selectedSegment, segments: ["Доставка", "Самовывоз"])
                .padding(.horizontal)
                .frame(height: 44)
            
            
            
            Form {
                ScrollView {
                    ForEach($order.orderArr) { $item in
                        VStack(alignment: .center) {
                            Spacer()
                            HStack(alignment: .center) {
                                Image(uiImage: item.image)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                
                                VStack(alignment: .leading) {
                                    
                                    Text(item.name)
                                        .lineSpacing(-2)
                                        .font(.system(size: 15))
                                        .lineLimit(2)
                                        .lineSpacing(-2)
                                        .padding(.bottom, -5)
                                    
                                    Spacer(minLength: 1)
                                    Text("\(item.price) ₽")
                                        .font(.system(size: 15))
                                        .foregroundStyle(Color(UIColor(red: 182/255, green: 182/255, blue: 182/255, alpha: 1)))
                                }.frame(height: 50)
                                
                                
                                Spacer()
                                ZStack(alignment: .center) {
                                    Rectangle()
                                        .foregroundStyle(Color(UIColor(red: 242/255, green: 242/255, blue: 248/255, alpha: 1)))
                                        .frame(width: 103, height: 44)
                                        .clipShape(.buttonBorder)
                                        .padding(.top, 5)
                                    HStack(alignment: .center) {
                                        Button(action: {
                                            if item.quantity != 0 {
                                                item.quantity -= 1
                                                modelView.getTotalCoast(adress: "df", order: order) {
                                                    print("good")
                                                }
                                            }
                                            if item.quantity == 0 {
                                                if let index = order.orderArr.firstIndex(where: { $0.id == item.id }) {
                                                    withAnimation(.easeInOut(duration: 0.5)) {
                                                        order.orderArr.remove(at: index)
                                                        modelView.getTotalCoast(adress: "df", order: order) {
                                                            print("good")
                                                        }
                                                    }
                                                }
                                            }
                                        }) {
                                            Image(.minus)
                                                .resizable()
                                                .frame(width: 12, height: 2)
                                                .padding()
                                        }
                                        .frame(width: 24, height: 24)
                                        .padding(.top, 3.5)
                                        
                                        
                                        
                                        
                                        Text("\(item.quantity)")
                                            .padding(.horizontal, 4)
                                        
                                        
                                        Button(action: {
                                            if item.quantity != 10 {
                                                item.quantity += 1
                                                modelView.getTotalCoast(adress: "df", order: order) {
                                                    print("good")
                                                }
                                            }
                                        }) {
                                            Image(.plus)
                                                .resizable()
                                                .frame(width: 12, height: 12)
                                        }
                                        .frame(width: 24, height: 24)
                                        .padding(.top, 3.5)
                                        
                                        
                                    }
                                    
                                }
                                
                            }
                            
                            
                        }.transition(.scale)
                        
                        
                    }
                    Spacer(minLength: 15)
                    HStack {
                        Text("\($order.orderArr.count) \(productWordDeclension(count: $order.orderArr.count))")
                            .font(.system(size: 18))
                            .foregroundStyle(Color(UIColor(red: 126/255, green: 126/255, blue: 126/255, alpha: 1)))
                        Spacer()
                        let totalSum = order.orderArr.reduce(0) { $0 + $1.price }
                        Text("\(totalSum)₽")
                            .font(.system(size: 18))
                            .foregroundStyle(Color(UIColor(red: 126/255, green: 126/255, blue: 126/255, alpha: 1)))
                        
                    }
                    
                    HStack {
                        Text("Доставка")
                            .font(.system(size: 18))
                            .foregroundStyle(Color(UIColor(red: 126/255, green: 126/255, blue: 126/255, alpha: 1)))
                            
                        
                    }
                }.transition(.scale)
            }
            
            .scrollContentBackground(.hidden)
            
            
        }
        .background(Color(UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)))
    }
    
    func productWordDeclension(count: Int) -> String {
        let cases = [2, 0, 1, 1, 1, 2]
        return ["товар", "товара", "товаров"][(count%100>4 && count%100<20) ? 2 : cases[min(count%10, 5)]]
    }
}



#Preview {
    ContentView()
}

extension UISegmentedControl {
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.setContentHuggingPriority(.defaultLow, for: .vertical)
    }
}



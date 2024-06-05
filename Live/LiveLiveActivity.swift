//
//  LiveLiveActivity.swift
//  Live
//
//  Created by Владимир Кацап on 04.06.2024.
//

import ActivityKit
import WidgetKit
import SwiftUI


struct LiveLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: Dost.self) { context in
            checkStatus(for: context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    
                    if context.state.message.first == "1" || context.state.message == "Начинаем готовить Ваш заказ..." {
                        Image(context.state.imageOne)
                            .resizable()
                            .colorMultiply(Color(UIColor(red: 248/255, green: 102/255, blue: 6/255, alpha: 1)))
                            .frame(width: 40, height: 40)
                    }
                    
                    if context.state.message.first == "2" {
                        Image(context.state.imageTwo)
                            .resizable()
                            .colorMultiply(Color(UIColor(red: 248/255, green: 102/255, blue: 6/255, alpha: 1)))
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            
                    }
                    
                    if context.state.message.first == "3" {
                        Image(context.state.imageThree)
                            .resizable()
                            .colorMultiply(Color(UIColor(red: 248/255, green: 102/255, blue: 6/255, alpha: 1)))
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                    }
                    
                    
                    
                    
                }
                
                DynamicIslandExpandedRegion(.trailing) {
//                    VStack {
//                        Spacer()
//                        Text(context.state.time)
//                            .font(.system(size: 24))
//                            .bold()
//                        Spacer()
//                    }
                    
                }
                
                DynamicIslandExpandedRegion(.center) {
                    VStack {
                        
                        if context.state.message.first == "1" || context.state.message == "Начинаем готовить Ваш заказ..." {
                            Text("Готовим...")
                                .font(.system(size: 20))
                                .bold()
                        }
                        if context.state.message.first == "2" {
                            Text("Передаем курьеру")
                                .font(.system(size: 16))
                                .bold()
                        }
                        if context.state.message.first == "3" {
                            Text("Встречайте!")
                                .font(.system(size: 16))
                                .bold()
                        }
                        
                    }
                }
                
            } compactLeading: {
                VStack(alignment: .center, content: {
                    if context.state.message.first == "1" || context.state.message == "Начинаем готовить Ваш заказ..." {
                        Image(context.state.imageOne)
                            .resizable()
                            .colorMultiply(Color(UIColor(red: 248/255, green: 102/255, blue: 6/255, alpha: 1)))
                            .frame(width: 30, height: 20)
                    }
                    if context.state.message.first == "2" {
                        Image(context.state.imageTwo)
                            .resizable()
                            .colorMultiply(Color(UIColor(red: 248/255, green: 102/255, blue: 6/255, alpha: 1)))
                            .frame(width: 20, height: 20)
                    }
                    if context.state.message.first == "3" {
                        Image(context.state.imageThree)
                            .resizable()
                            .colorMultiply(Color(UIColor(red: 248/255, green: 102/255, blue: 6/255, alpha: 1)))
                            .frame(width: 20, height: 20)
                    }
                    
                })
                    

            } compactTrailing: {
//                Text(context.state.time)
//                    .font(.system(size: 14))
//                    .foregroundStyle(Color(UIColor(red: 248/255, green: 102/255, blue: 6/255, alpha: 1)))
            } minimal: {
            }
            
        }
        
    }
    
    func checkStatus(for context: ActivityViewContext<Dost>) -> some View {
        
        VStack {
            ZStack {
                Rectangle()
                    .cornerRadius(23)
                    .foregroundStyle(.black)
                    .frame(height: 138)
                
                HStack {
                    
                    if context.state.message.first == "1" || context.state.message == "Начинаем готовить Ваш заказ..." {
                        Image(context.state.imageOne)
                            .resizable()
                            .frame(width: 60, height: 40)
                            .padding(.bottom, 65)
                            .padding(.leading, 5)
                    }
                    
                    if context.state.message.first == "2" {
                        Image(context.state.imageTwo)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 40)
                            .padding(.bottom, 65)
                            .padding(.leading, 5)
                            
                    }
                    
                    if context.state.message.first == "3" {
                        Image(context.state.imageThree)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 40)
                            .padding(.bottom, 65)
                            .padding(.leading, 5)
                    }
                    
                    Spacer()
                    Link(destination: URL(string: "tel://+79380312109")!) {
                        Image(systemName: "phone")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundStyle(.white)
                    }
                    .frame(width: 45, height: 45)
                    .background(Color(UIColor(red: 248/255, green: 102/255, blue: 6/255, alpha: 1)))
                    .clipShape(.circle)
                    .padding(.bottom, 65)
                    .padding(.trailing, 1)
                }
                    .padding(.trailing, 12)
                    .padding(.leading, 12)
                
                

                HStack {
                    
                    Spacer()
                    Rectangle()
                        .foregroundColor(Color(UIColor(red: 248/255, green: 102/255, blue: 6/255, alpha: 1)))
                        .frame(width: 103, height: 5)
                        .opacity(context.state.wasFirstStepCompleted ? (context.state.isHighlighted ? 1 : 1) : 1)
                        .cornerRadius(3)

                    Spacer()
                    Rectangle()
                        .foregroundColor(context.state.wasSecondStepCompleted ? Color(UIColor(red: 248/255, green: 102/255, blue: 6/255, alpha: 1)) : Color.gray)
                        .frame(width: 103, height: 5)
                        .opacity(context.state.wasSecondStepCompleted ? (context.state.isHighlighted ? 1 : 1) : 1)
                        .cornerRadius(3)

                    Spacer()
                    Rectangle()
                        .foregroundColor(context.state.wasThirdStepCompleted ? Color(UIColor(red: 248/255, green: 102/255, blue: 6/255, alpha: 1)) : Color.gray)
                        .frame(width: 103, height: 5)
                        .opacity(context.state.wasThirdStepCompleted ? (context.state.isHighlighted ? 1 : 1) : 1)
                        .cornerRadius(3)
                    Spacer()
                    
                    
                }
                .padding(.top, 10)
                .padding(.trailing, 12)
                .padding(.leading, 12)
                
                Spacer()
                
                VStack(alignment: .leading, content: {
                    Text(context.state.message)
                        .font(.system(size: 20))
                        .foregroundStyle(.white)
                        .bold()
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 5)
                }).padding(.top, 70)
                    .padding(.trailing, 15)
                    .padding(.leading, 15)
                    .padding(.bottom, 5)

                
                
                    
            }
        }

    }
    
}



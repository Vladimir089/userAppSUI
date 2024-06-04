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
                            .frame(width: 20, height: 20)
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
                    .frame(height: 100)

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
                .padding(.top, -25)
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
                }).padding(.top, 15)
                    .padding(.trailing, 15)
                    .padding(.leading, 15)

                
                
                    
            }
        }

    }
    
}



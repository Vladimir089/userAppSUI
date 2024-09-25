import SwiftUI
import Lottie
import SnapKit


struct ContentView: View {
    @Binding var showSheetEat: Bool
    @ObservedObject var netWorking: Networking
    @ObservedObject var checkStatusModelView: checkStatus
    @State var selectedCategory = "РОЛЛЫ"
    @State var isButtonTapped = false
    @ObservedObject var order = Order()
    @State var showingCart = false
    
    @State var token: String
    @State var cafeID: Int
    
    init(isShowingDetail: Binding<Bool>, token: String, cafeID: Int, phone: String) {
        self._showSheetEat = isShowingDetail
        self.token = token
        self.cafeID = cafeID
        let netWorkingInstance = Networking()
        netWorkingInstance.token = token
        self.netWorking = netWorkingInstance
        self.checkStatusModelView = checkStatus(mainModel: netWorkingInstance)
        self.netWorking.cafeID = cafeID
        self.netWorking.phoneNumber = phone
        print(netWorking.phoneNumber, "dsfdsffdsdfsfs")
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        Image(uiImage: UIImage(data: netWorking.cafe.image) ?? UIImage())
                            .resizable()
                            .clipShape(.buttonBorder)
                            .frame(width: 40, height: 40)
                        //Spacer()
                        VStack {
                            Spacer()
                            Text(netWorking.cafe.name)
                                .foregroundStyle(.white)
                                .font(.system(size: 17, weight: .semibold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top)
                            Spacer()
                            
                            Text("\(netWorking.cafe.numberOrders) Заказов")
                                .foregroundStyle(.white)
                                .font(.system(size: 12, weight: .regular))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .opacity(0.8)
                                .padding(.bottom)
                            Spacer()
                        }
                        
                        Spacer()
                        Spacer()
                        
                        Button(action: {
                            showSheetEat = false
                        }) {
                            Image(.hideVC)
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                        .frame(width: 30, height: 30)
                    }
                    .padding(.horizontal, 10)
                    .padding(.bottom, 40)
                    .frame(maxWidth: .infinity) // Для ширины
                    .frame(height: 100) // Для высоты
                    .background(Color.figmaOrange)
                    
                    VStack {
                        if netWorking.isDataLoaded == true {
                            ScrollView(.horizontal, showsIndicators: false) {
                                ScrollViewReader { scrollView in
                                    HStack(alignment: .center, spacing: 10) {
                                        ForEach(netWorking.arrCategories, id: \.self) { category in
                                            Button(action: {
                                                withAnimation {
                                                    selectedCategory = category
                                                    scrollView.scrollTo(category, anchor: .center)
                                                    isButtonTapped = true
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                        self.isButtonTapped = false
                                                    }
                                                }
                                                triggerHapticFeedback()
                                            }) {
                                                Text(category)
                                                    .font(.system(size: 17))
                                                    .bold()
                                                    .padding(.horizontal, 15)
                                                    .padding(.vertical, 5)
                                                    .background(selectedCategory == category ? Color(UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)) : .white)
                                                    .clipShape(Capsule())
                                                    .foregroundColor(selectedCategory == category ? .white : Color(UIColor(red: 112/255, green: 112/255, blue: 113/255, alpha: 1)))
                                                    .id(category)
                                            }
                                        }
                                    }
                                    .onChange(of: selectedCategory) { newValue in
                                        withAnimation {
                                            scrollView.scrollTo(selectedCategory, anchor: .center)
                                        }
                                        
                                    }
                                }
                            }
                            .padding(.top, 10)
                            .cornerRadius(10)
                            .background(Color.white)
                        } else {
                            Rectangle()
                                .padding(.top, 10)
                                .cornerRadius(10)
                                .foregroundStyle(Color.white)
                                .background(Color.white)
                            
                           
                            LottieView(animation: .named("LoadPageEat"))
                                .playing()
                                .looping()
                        }

                        Spacer()
                        
                        ZStack {
                            if netWorking.isDataLoaded {
                                let sections = netWorking.arrCategories.map { category in
                                    return (category, netWorking.allDishes.filter { dish, _ in dish.category == category })
                                }
                                CollectionView(sections: sections, selectedCategory: $selectedCategory, isButtonTapped: $isButtonTapped, order: order)
                            }
                            
                            if order.orderArr.count != 0 {
                                VStack {
                                    Spacer()
                                    HStack {
                                        Spacer()
                                        Button(action: {
                                            showingCart = true
                                            triggerHapticFeedback()
                                        }) {
                                            
                                            //let sum = order.orderArr.reduce(into: 0) { $0 += ($1.price * $1.quantity) }
                                            Text("\(checkSumm()) ₽")
                                                .padding(.trailing, 45)
                                                .padding(.leading, 20)
                                                .font(.system(size: 24))
                                                .bold()
                                                .animation(nil)
                                            
                                            if order.orderArr.count >= 1 {
                                                let images = Array(order.orderArr.suffix(3).reversed().map { $0 })
                                                ForEach(0..<images.count, id: \.self) { index in
                                                    let item = images[index]
                                                    
                                                    Image(uiImage: item.image)
                                                        .resizable()
                                                        .scaledToFit()
                                                        .background(Color(UIColor(red: 248/255, green: 102/255, blue: 6/255, alpha: 1)))
                                                        .clipShape(Circle())
                                                        .frame(width: 60, height: 60)
                                                        .padding(.leading, -40)
                                                        .zIndex(Double(images.count - index))
                                                        .transition(.scale)
                                                }
                                            }
                                        }
                                        .frame(height: 60)
                                        .animation(.default)
                                        .background(Color(UIColor(red: 247/255, green: 102/255, blue: 6/255, alpha: 0.9)))
                                        .foregroundColor(.white)
                                        .clipShape(.capsule)
                                        .sheet(isPresented: $showingCart, content: {
                                            CartView(order: order, mainObject: netWorking, statusBard: checkStatusModelView)
                                        })
                                        
                                        Spacer()
                                    }
                                    .padding(.bottom , 40)
                                    .background(Color.clear)
                                    
                                }
                            }
                            Spacer()
                            if let orderId = orderID["orderId"] as? Int {
                                if orderId != 0 {
                                    checkStatusModelView.checkStatus()
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .cornerRadius(30)
                    .padding(.top, -45)
                }
                .ignoresSafeArea(edges: .bottom)
                .onAppear {
                    netWorking.getDishes { _ in
                       // print(netWorking.allDishes)
                    }
                }
                //.foregroundStyle(Color.white)
                .background(Color.white)
                
            }
        }
        .onAppear {
            NotificationCenter.default.addObserver(forName: .updateScrolledCategory, object: nil, queue: .main) { (notification) in
                if let category = notification.object as? String {
                    self.selectedCategory = category
                }
            }
            netWorking.checkuser()
        }
    }
    
    
    
    func checkSumm() -> Int {
        var sum = 0
        for i in order.orderArr {
            sum += i.quantity * i.price
        }
        return sum
    }
    
    func triggerHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)  //.light, .medium или .heavy
        generator.impactOccurred()
    }
}



//#Preview {
//    ContentView()
//}

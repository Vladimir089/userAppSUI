import SwiftUI




struct CartView: View {
    
    @State private var keyboardHeight: CGFloat = 0
    @ObservedObject var order: Order
    @State var selectedSegment = "Доставка"
    @State var dost = 0
    @State private var isEditing = false
    @FocusState private var phoneNumberIsFocused: Bool
    @FocusState private var commentIsFocused: Bool
    @ObservedObject var mainObject: Networking
    @State  var isEditingText = false
    @State  var isNewOrder = true
    @State  var buttonHighlight = false
    @State var buttonTitle = ""
    @State private var isButtonTap = false
    @Environment(\.presentationMode) var presentationMode

    
    private let phoneFormatter = PhoneNumberFormatter()
    

    @StateObject var statusBard: checkStatus
    
    
    
    
    var body: some View {
        NavigationView {
            VStack {
                Rectangle().frame(width: 50, height: 4)
                    .cornerRadius(2)
                    .foregroundStyle(Color(UIColor(red: 229/255, green: 229/255, blue: 230/255, alpha: 1)))
                    .padding()
                
                SegmentedPicker(selectedSegment: $selectedSegment, segments: ["Доставка", "Самовывоз"])
                    .padding(.horizontal)
                    .frame(height: 44)
                    .onChange(of: selectedSegment) { oldValue, newValue in
                        triggerHapticFeedback()
                    }
                ZStack {
                    Form {
                        Section {
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
                                                    .foregroundStyle(Color.black)
                                                
                                                Spacer(minLength: 1)
                                                Text("\(item.price * item.quantity) ₽")
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
                                                        triggerHapticFeedback()
                                                        if item.quantity > 0 {
                                                            item.quantity -= 1
                                                            mainObject.getTotalCoast(adress: mainObject.adress, order: order) {
                                                                buttonTitle = "Оформить заказ \(mainObject.totalCoast) ₽"
                                                            }
                                                            
                                                            if item.quantity == 0 {
                                                                // Проверяем, что индекс существует в массиве перед удалением
                                                                if let index = order.orderArr.firstIndex(where: { $0.id == item.id }) {
                                                                    withAnimation(.easeInOut(duration: 0.5)) {
                                                                        order.orderArr.remove(at: index)
                                                                        // Пересчитываем общую стоимость после удаления элемента
                                                                        mainObject.getTotalCoast(adress: mainObject.adress, order: order) {
                                                                            buttonTitle = "Оформить заказ \(mainObject.totalCoast) ₽"
                                                                        }
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
                                                        .foregroundStyle(Color.black)
                                                    
                                                    Button(action: {
                                                        triggerHapticFeedback()
                                                        if item.quantity != 10 {
                                                            item.quantity += 1
                                                            mainObject.getTotalCoast(adress: mainObject.adress, order: order) {
                                                                buttonTitle = "Оформить заказ \(mainObject.totalCoast) ₽"
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
                                    Text("\(checkSumm()) ₽")
                                        .font(.system(size: 18))
                                        .foregroundStyle(Color(UIColor(red: 126/255, green: 126/255, blue: 126/255, alpha: 1)))
                                }.padding(.bottom, 5)
                                    .padding(.top, 5)
                                
                                Spacer()
                                
                                HStack {
                                    Text("Доставка")
                                        .font(.system(size: 18))
                                        .foregroundStyle(Color(UIColor(red: 126/255, green: 126/255, blue: 126/255, alpha: 1)))
                                    Spacer()
                                    Text("\(mainObject.adressCoast) ₽")
                                        .font(.system(size: 18))
                                        .foregroundStyle(Color(UIColor(red: 126/255, green: 126/255, blue: 126/255, alpha: 1)))
                                        .onChange(of: mainObject.adress) { oldValue, newValue in
                                            buttonTitle = "Оформить заказ \(mainObject.totalCoast) ₽"
                                        }
                                }.padding(.bottom, 5)
                                
                                Divider()
                                HStack {
                                    Text("Итого")
                                        .font(.system(size: 18))
                                        .foregroundStyle(Color.black)
                                    Spacer()
                                    
                                    Text("\(mainObject.totalCoast) ₽")
                                        .font(.system(size: 18))
                                        .foregroundStyle(Color.black)
                                        .onChange(of: mainObject.totalCoast) { oldValue, newValue in
                                            buttonTitle = "Оформить заказ \(mainObject.totalCoast) ₽"
                                        }
                                }.padding(.top, 5)
                                
                            }
                            
                            

                            
                            
                        }.transition(.scale)
                        
                        
                        Section {
                            VStack {
                                TextField("Номер телефона", text: $mainObject.phoneNumber, onEditingChanged: { editing in
                                    self.isEditing = editing
                                })
                                .keyboardType(.numbersAndPunctuation)
                                .focusable()
                                .focused($phoneNumberIsFocused)
                                .navigationBarTitleDisplayMode(.inline)
                                .onSubmit {
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                }
                                .onChange(of: mainObject.phoneNumber) { newValue in
                                    print(mainObject.adress)
                                    mainObject.phoneNumber = phoneFormatter.format(with: "+# (###) ### ####", phone: newValue)
                                }
                                Divider()
                                
                                
                                NavigationLink(
                                    destination: DostView(model: mainObject)) {
                                        if mainObject.adress.isEmpty {
                                            Text("Адрес доставки")
                                                .foregroundStyle(.black)
                                        } else {
                                            Text(mainObject.adress)
                                                .foregroundStyle(.black)
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .padding(.vertical, 2)
                                
                                Divider()
                                
                                HStack {
                                    Text("Кол-во приборов")
                                    Spacer()
                                    ZStack(alignment: .center) {
                                        Rectangle()
                                            .foregroundStyle(Color(UIColor(red: 242/255, green: 242/255, blue: 248/255, alpha: 1)))
                                            .frame(width: 103, height: 34)
                                            .clipShape(.buttonBorder)
                                            .padding(.top, 5)
                                        HStack(alignment: .center) {
                                            Image(.minus) // Изображение для кнопки
                                                .resizable()
                                                .frame(width: 12, height: 2)
                                                .padding(5) // Увеличивает область нажатия на 5 points
                                                .contentShape(Rectangle())
                                                .onTapGesture {
                                                    if mainObject.pribor != 1 {
                                                        mainObject.pribor -= 1
                                                        triggerHapticFeedback()
                                                    }
                                                }
                                                .padding(.top, 3.5)
                                                .frame(width: 24, height: 24)
                                            
                                            Text("\(mainObject.pribor)")
                                                .padding(.top, 4)
                                                .foregroundStyle(Color.black)
                                            
                                            Image(.plus) // Изображение для кнопки
                                                .resizable()
                                                .frame(width: 12, height: 12)
                                                .padding(5) // Увеличивает область нажатия на 5 points
                                                .contentShape(Rectangle())
                                                .onTapGesture {
                                                    if mainObject.pribor != 10 {
                                                        mainObject.pribor += 1
                                                        triggerHapticFeedback()
                                                    }
                                                }
                                            
                                                .padding(.top, 3.5)
                                                .frame(width: 24, height: 24)
                                            
                                        }
                                    }.padding(.bottom, 5)
                                }.frame(height: 30)
                                
                                Divider()
                                
                                TextField("Комментарий к заказу", text: $mainObject.commentOrder, onEditingChanged: { editing in
                                    self.isEditingText = editing
                                })
                                .navigationBarTitleDisplayMode(.inline)
                                .onSubmit {
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                }
                                .onChange(of: mainObject.commentOrder) { newValue in
                                    print(mainObject.commentOrder)
                                    
                                }
                                
                                
                                
                            }
                            
                        }
                        
                        Section {
                            Rectangle()
                                .fill(Color.clear)
                                .frame(height: 50)
                        }
                        .listRowBackground(Color.clear)
                        .frame(height: 50)
                        
                        
                    }.transition(.scale)
                        .scrollContentBackground(.hidden)
                        
                    VStack {
                        Spacer()
                        if keyboardHeight == 0 {
                            Button {
                                let menuStrings = order.orderArr.map { item in
                                    return "\(item.name) - \(item.quantity)"
                                }
                                let menu = menuStrings.joined(separator: ", ")
                                isButtonTap = true
                                mainObject.createNewOrder(phonee: mainObject.phoneNumber, menuItems: menu, clientsNumber: mainObject.pribor, adres: mainObject.adress, totalCost: mainObject.totalCoast, paymentMethod: "наличка", timeOrder: "", cafeID: mainObject.cafeID) { success in
                                    if success {
                                        withAnimation {
                                            isNewOrder = true
                                            buttonHighlight = true
                                            buttonTitle = "Заказ оформлен"
                                        }
                                        triggerHapticFeedback()
                                        self.presentationMode.wrappedValue.dismiss()
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                            withAnimation {
                                                statusBard.start()
                                                isButtonTap = false
                                                buttonHighlight = false
                                                buttonTitle = "Оформить заказ \(mainObject.totalCoast) ₽"
                                            }
                                        }
                                       
                                    } else {
                                        triggerHapticFeedbackFall()
                                        withAnimation {
                                            isNewOrder = false
                                            buttonHighlight = false
                                            buttonTitle = "Заказ не создан"
                                        }
                                       
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                            withAnimation {
                                                isButtonTap = false
                                                buttonHighlight = false
                                                buttonTitle = "Оформить заказ \(mainObject.totalCoast) ₽"
                                            }
                                        }
                                        
                                    }
                                }
                            } label: {
                                Text(buttonTitle)
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                                    .bold()
                            }
                            .frame(height: 50)
                            .padding(.leading, 20)
                            .padding(.trailing, 20)
                            .background(buttonHighlight && isNewOrder ? Color.green : Color(UIColor(red: 248/255, green: 102/255, blue: 6/255, alpha: 1)))
                            .clipShape(Capsule())
                            .disabled(isButtonTap)
                            .onAppear {
                                buttonTitle = "Оформить заказ \(mainObject.totalCoast) ₽"
                            }
                            
                        }
                            
                    }
                    
                    
                }
               
                
                
            }
            
            .background(Color(UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)))
            .onAppear {
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (noti) in
                    let value = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                    let height = value.height
                    keyboardHeight = height + 50
                }
                
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (noti) in
                    keyboardHeight = 0
                }
            }
            
            
        }.onAppear {
            mainObject.getTotalCoast(adress: mainObject.adress, order: order) {
                print("good")
            }
        }
    }
    
    func triggerHapticFeedbackFall() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)  // Вы можете изменить стиль на .light, .medium или .heavy
        generator.impactOccurred()
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func triggerHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .light)  // Вы можете изменить стиль на .light, .medium или .heavy
        generator.impactOccurred()
    }
    
    func productWordDeclension(count: Int) -> String {
        let cases = [2, 0, 1, 1, 1, 2]
        return ["товар", "товара", "товаров"][(count%100>4 && count%100<20) ? 2 : cases[min(count%10, 5)]]
    }
    
    private func generateToolbar(for textField: UITextField) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Готово", style: .done, target: textField, action: #selector(UITextField.resignFirstResponder))
        toolbar.items = [flexButton, doneButton]
        return toolbar
    }
    
    func checkSumm() -> Int {
        var sum = 0
        for i in order.orderArr {
            sum += i.quantity * i.price
        }
        return sum
    }
}

//#Preview {
//    ContentView()
//}

extension UISegmentedControl {
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.setContentHuggingPriority(.defaultLow, for: .vertical)
    }
}

class PhoneNumberFormatter: Formatter {
    func format(with mask: String, phone: String) -> String {
        let numbers = phone.filter { "0"..."9" ~= $0 }
        var result = ""
        var index = numbers.startIndex
        for ch in mask where index < numbers.endIndex {
            if ch == "#" {
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
}

import SwiftUI

struct DostView: View {
    @ObservedObject var model: Networking
    @Environment(\.presentationMode) var presentationMode
    @State var adressArr: [String] = []
    @State var adr = ""

    

    var body: some View {
        
        VStack {
            Rectangle().frame(width: 50, height: 4)
                .cornerRadius(2)
                .foregroundStyle(Color(UIColor(red: 229/255, green: 229/255, blue: 230/255, alpha: 1)))
                .padding()
            HStack {
                
                
                TextField("Улица, № дома, село", text: $adr)
                    .padding(.vertical, 7)
                    .padding(.horizontal, 5)
                    .background(.white)
                    .clipShape(.capsule)
                    .overlay(
                        HStack {
                            Spacer()
                            Button(action: {
                                self.model.adress = ""
                                adr = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .padding(.trailing, 10)
                            }
                        }
                    )
                    .onChange(of: adr) { newValue in
                        model.getAdress(adres: newValue) { fullAddresses in
                            adressArr = fullAddresses
                        }
                    }
                    .onAppear(perform: {
                        adr = model.adress
                    })
                    
                
                Spacer()
                
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Готово")
                }
                .padding(.vertical, 7)
                .padding(.horizontal, 5)
                .background(.white)
                .clipShape(.capsule)
                Spacer()
            }.padding(.horizontal)
            
            
            List {
                ForEach(adressArr.indices, id: \.self) { i in
                    Text(adressArr[i])
                        .onTapGesture {
                            model.adress = adressArr[i]  // Обновляем выбранный адрес при нажатии на ячейку
                            adr = model.adress
                        }
                }
            }.scrollContentBackground(.hidden)
        }
        .background(Color(UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)))
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ContentView()
}

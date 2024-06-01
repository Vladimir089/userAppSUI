import SwiftUI

struct DostView: View {
    @ObservedObject var model: Networking
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Rectangle().frame(width: 50, height: 4)
                .cornerRadius(2)
                .foregroundStyle(Color(UIColor(red: 229/255, green: 229/255, blue: 230/255, alpha: 1)))
                .padding()
            HStack {
                Spacer()
                
                TextField("Улица, № дома, село", text: $model.adress)
                    .padding(.vertical, 7)
                    .padding(.leading, 5)
                    .padding(.trailing, 5)
                    .padding(.horizontal, 10)
                    .background(.white)
                    .clipShape(.capsule)
                    .overlay(
                        HStack {
                            Spacer()
                            Button(action: {
                                self.model.adress = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .padding(.trailing, 10)
                            }
                        }
                    )
                    
                
                Spacer()
                
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Готово")
                }
                .padding(.vertical, 7)
                .padding(.horizontal, 10)
                .background(.white)
                .clipShape(.capsule)
                Spacer()
            }.padding(.horizontal)
            Spacer()
            
            List {
                Text("dsf") //ТУТ ДОДЕЛАТЬ
            }.scrollContentBackground(.hidden)
        }
        .background(Color(UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)))
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ContentView()
}

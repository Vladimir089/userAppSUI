import SwiftUI
import SnapKit

struct ContentView: View {
    
    @ObservedObject var netWorking = Networking()
    @State var selectedCategory = "РОЛЛЫ"
    @State var isButtonTapped = false
    
    
    
    var body: some View {
        NavigationView {
            VStack {
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
                
                Spacer()
                if netWorking.isDataLoaded {
                    let sections = netWorking.arrCategories.map { category in
                        return (category, netWorking.allDishes.filter { dish, _ in dish.category == category })
                    }
                    CollectionView(sections: sections, selectedCategory: $selectedCategory, isButtonTapped: $isButtonTapped)
                }
            }
            .ignoresSafeArea(edges: .bottom)
            .padding(.horizontal)
            .onAppear {
                netWorking.getDishes { _ in
                    print(netWorking.allDishes)
                }
            }
        }
        .onAppear {
            NotificationCenter.default.addObserver(forName: .updateScrolledCategory, object: nil, queue: .main) { (notification) in
                if let category = notification.object as? String {
                    self.selectedCategory = category
                }
            }
            
        }
    }
}

struct CollectionView: UIViewRepresentable {
    
    var sections: [(String, [(Dish, UIImage)])]
    @Binding var selectedCategory: String
    @Binding var isButtonTapped: Bool
    
    func makeUIView(context: Context) -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = context.coordinator
        collectionView.delegate = context.coordinator
        
        return collectionView
    }
    
    func updateUIView(_ collectionView: UICollectionView, context: Context) {
        guard isButtonTapped else { return }
        collectionView.reloadData()
        if let sectionIndex = sections.firstIndex(where: { $0.0 == selectedCategory }) {
            let indexPath = IndexPath(item: 0, section: sectionIndex)
            collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
        }
    }
    
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, selectedCategory: $selectedCategory, isButtonTapped: $isButtonTapped)
    }
    
    class Coordinator: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
        var parent: CollectionView
        @Binding var selectedCategory: String
        @Binding var isButtonTapped: Bool
        
        init(_ collectionView: CollectionView, selectedCategory: Binding<String>, isButtonTapped: Binding<Bool>) {
            self.parent = collectionView
            self._selectedCategory = selectedCategory
            self._isButtonTapped = isButtonTapped
        }
        
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return parent.sections.count
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return parent.sections[section].1.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            cell.subviews.forEach { $0.removeFromSuperview() }
            let dish = parent.sections[indexPath.section].1[indexPath.item]
            let image = dish.1
            let imageView = UIImageView(image: image)
            cell.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.left.equalToSuperview()
                make.height.width.equalTo(150)
                make.centerY.equalToSuperview()
            }
            let labelName = UILabel()
            labelName.text = "\(dish.0.category) \n \(dish.0.name)"
            cell.addSubview(labelName)
            labelName.snp.makeConstraints { make in
                make.centerX.centerY.equalToSuperview()
            }
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            if parent.isButtonTapped == false {
                print(isButtonTapped)
                let visibleSections = collectionView.indexPathsForVisibleItems.map { $0.section }
                if let firstVisibleSection = visibleSections.first {
                    let category = parent.sections[firstVisibleSection].0
                    NotificationCenter.default.post(name: .updateScrolledCategory, object: category)
                }
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.frame.width, height: 150)
        }
    }
}


extension Notification.Name {
    static let updateScrolledCategory = Notification.Name("updateScrolledCategory")
}

#Preview {
    ContentView()
}

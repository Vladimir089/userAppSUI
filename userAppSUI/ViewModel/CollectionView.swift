//
//  CollectionView.swift
//  userAppSUI
//
//  Created by Владимир Кацап on 28.05.2024.
//

import Foundation
import UIKit
import SwiftUI


struct CollectionView: UIViewRepresentable {
    
    var sections: [(String, [(Dish, UIImage)])]
    @Binding var selectedCategory: String
    @Binding var isButtonTapped: Bool
    @ObservedObject var order: Order
    
    func makeUIView(context: Context) -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.minimumLineSpacing = 30
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
            cell.tag = indexPath.section
            let dish = parent.sections[indexPath.section].1[indexPath.item]
            let image = dish.1
            let imageView = UIImageView(image: image)
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 10
            cell.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.left.equalToSuperview()
                make.height.width.equalTo(150)
                make.centerY.equalToSuperview()
            }
            let labelName = UILabel()
            labelName.text = dish.0.name
            labelName.numberOfLines = 0
            labelName.textAlignment = .left
            labelName.font = .systemFont(ofSize: 15, weight: .bold)
            labelName.textColor = .black
            cell.addSubview(labelName)
            labelName.snp.makeConstraints { make in
                make.left.equalTo(imageView.snp.right).inset(-15)
                make.top.equalToSuperview().inset(7)
                make.right.equalToSuperview().inset(10)
            }
            
            let orderButton: UIButton = {
                let button = UIButton(type: .system)
                button.backgroundColor = UIColor(red: 241/255, green: 242/255, blue: 247/255, alpha: 1)
                button.setTitle("\(dish.0.price) ₽", for: .normal)
                button.tintColor = .black
                button.layer.cornerRadius = 15
                button.tag = indexPath.row
                button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
                button.contentEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
                button.addTarget(self, action: #selector(addToCart(button:)), for: .touchUpInside)
                return button
            }()
            cell.addSubview(orderButton)
            orderButton.snp.makeConstraints { make in
                make.height.equalTo(28)
                make.left.equalTo(labelName.snp.left)
                make.bottom.equalToSuperview().inset(7)
            }
            
            return cell
        }
        
        @objc func addToCart(button: UIButton) {
            
            let originalColor = button.backgroundColor
            let originalColorToText = button.tintColor
            
            UIView.animate(withDuration: 0.4) {
                button.tintColor = .white
                button.backgroundColor = .systemGreen
            }
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.4) {
                UIView.animate(withDuration: 0.4) {
                    button.tintColor = originalColorToText
                    button.backgroundColor = originalColor
                }
            }
            
            let row = button.tag
            let section = button.superview?.tag ?? 0
            
            let dish = parent.sections[section].1[row]
            
            if let existingIndex =  parent.order.orderArr.firstIndex(where: { $0.0 == dish.0.name }) {
                parent.order.orderArr[existingIndex].1 += 1
                parent.order.orderArr[existingIndex].3 += dish.0.price
            } else {
                parent.order.orderArr.append((dish.0.name, 1, dish.1, dish.0.price))
            }
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
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let dish = parent.sections[indexPath.section].1[indexPath.item]
            let detailVC = DetailViewController(dish: dish, order: parent.order)
            collectionView.viewController?.present(detailVC, animated: true, completion: nil)
        }
    }
   
}

class DetailViewController: UIViewController {
    let dish: (Dish, UIImage)
    var order: Order
    let dishImageView: UIImageView = UIImageView()
    var addToCartButton: UIButton = UIButton()
    let nameLabel: UILabel = UILabel()
    let hideView = UIView()
   

    init(dish: (Dish, UIImage), order: Order) {
        self.dish = dish
        self.order = order
        super.init(nibName: nil, bundle: nil)
        dishImageView.image = dish.1
        nameLabel.text = dish.0.name
        nameLabel.font = .systemFont(ofSize: 27, weight: .bold)
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .left
        hideView.backgroundColor = UIColor(red: 229/255, green: 229/255, blue: 230/255, alpha: 1)
        hideView.layer.cornerRadius = 2
        
        addToCartButton = {
            let button = UIButton(type: .system)
            let text: Int = dish.0.price
            button.setTitle("В козину за \(text) ₽", for: .normal)
            button.tintColor = .white
            button.backgroundColor = UIColor(red: 248/255, green: 102/255, blue: 6/255, alpha: 1)
            button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
            button.layer.cornerRadius = 30
            button.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
            return button
        }()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(hideView)
        view.addSubview(dishImageView)
        view.addSubview(addToCartButton)
        view.addSubview(nameLabel)
        view.backgroundColor = .white
        
        hideView.snp.makeConstraints { make in
            make.height.equalTo(4)
            make.width.equalTo(50)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(10)
        }
        
        dishImageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(10)
            make.top.equalTo(hideView.snp.bottom).inset(-15)
            make.height.equalTo(dishImageView.snp.width)
        }
        nameLabel.snp.makeConstraints { make in
            make.left.right.equalTo(dishImageView).inset(10)
            make.top.equalTo(dishImageView.snp.bottom).inset(-20)
        }
       
        addToCartButton.snp.makeConstraints({ make in
            make.height.equalTo(60)
            make.left.right.equalToSuperview().inset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        })
       
    }

    @objc func addButtonPressed(_ sender: UIButton) {
        let originalColor = sender.backgroundColor
        let originalColorToText = sender.tintColor
        
        UIView.animate(withDuration: 0.4) {
            sender.tintColor = .white
            sender.backgroundColor = .systemGreen
        }
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.4) {
            UIView.animate(withDuration: 0.4) {
                sender.tintColor = originalColorToText
                sender.backgroundColor = originalColor
            }
        }
        
        if let existingIndex =  order.orderArr.firstIndex(where: { $0.0 == dish.0.name }) {
            order.orderArr[existingIndex].1 += 1
            order.orderArr[existingIndex].3 += dish.0.price
        } else {
            order.orderArr.append((dish.0.name , 1, dish.1 , dish.0.price ))
        }
    }
}

extension UIView {
    var viewController: UIViewController? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            if let vc = nextResponder as? UIViewController {
                return vc
            }
            responder = nextResponder
        }
        return nil
    }
}


extension Notification.Name {
    static let updateScrolledCategory = Notification.Name("updateScrolledCategory")
}

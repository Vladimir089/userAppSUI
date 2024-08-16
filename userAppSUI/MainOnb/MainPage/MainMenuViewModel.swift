//
//  MainMenuViewModel.swift
//  userAppSUI
//
//  Created by Владимир Кацап on 16.08.2024.
//

import Foundation
import SwiftUI
import UIKit


class MainMenuViewModel: ObservableObject {
    @Published var selectedRegion = "Учкекен"
    @Published var profileImage: Data = (UIImage.elon.jpegData(compressionQuality:1) ?? Data())
}

//
//  Screen.swift
//  CreateObject
//
//  Created by Brian Abraham on 03/04/2023.
//

import Foundation
import SwiftUI

struct Screen {
   static let height = Double(UIScreen.main.bounds.height)
   static let width = Double(UIScreen.main.bounds.width)
    static let smallestDimension = [height, width].min() ?? height

}

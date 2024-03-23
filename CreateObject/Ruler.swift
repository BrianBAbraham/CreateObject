//
//  Ruler.swift
//  CreateObject
//
//  Created by Brian Abraham on 23/03/2024.
//

import SwiftUI

struct Ruler: View {
    var body: some View {
        Rectangle()
                    .fill(Color.blue) // Change color as needed
                    .frame(width: 50, height: 400)
                    .opacity(0.1)// A
    }
}

#Preview {
    Ruler()
}

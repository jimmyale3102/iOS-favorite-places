//
//  CustomDialog.swift
//  FavoritePlaces
//
//  Created by Jimmy on 27/7/2024.
//

import SwiftUI

struct CustomDialog<Content: View>: View {
    let closeDialog: () -> Void
    let onDismissOutside: Bool
    let content: Content
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.gray.opacity(0.7))
                .ignoresSafeArea()
                .onTapGesture {
                    if onDismissOutside {
                        closeDialog()
                    }
                }
            content
                .frame(width: UIScreen.main.bounds.width - 100, height: 300)
                .padding()
                .background(.white)
                .cornerRadius(16)
                .overlay(alignment: .topTrailing) {
                    Button(
                        action: { closeDialog() },
                        label: {
                            Image(systemName: "xmark.circle")
                        }
                    )
                }
        }
        .ignoresSafeArea()
        .frame(
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.height,
            alignment: .center
        )
    }
}

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
                .fill(.gray.opacity(0.8))
                .ignoresSafeArea()
                .onTapGesture {
                    if onDismissOutside {
                        withAnimation {
                            closeDialog()
                        }
                    }
                }
            content
                .frame(width: UIScreen.main.bounds.width - 100, height: 300)
                .padding()
                .background(.white)
                .cornerRadius(16)
                .overlay(alignment: .topTrailing) {
                    Button(
                        action: {
                            withAnimation {
                                closeDialog()
                            }
                        },
                        label: {
                            Image(systemName: "xmark.circle")
                        }
                    )
                    .foregroundColor(.gray)
                    .padding(16)
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

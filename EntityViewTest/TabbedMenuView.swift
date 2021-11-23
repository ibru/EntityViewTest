//
//  TabbedMenuView.swift
//  EntityViewTest
//
//  Created by Jiri Urbasek on 19.11.2021.
//

import SwiftUI

struct TabbedMenuView: View {
    
    @ObservedObject var viewModel: TabbedMenuViewModel
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                ForEach(viewModel.items) { item in
                    TabbedMenuItem(item: item)
                        .onTapGesture {
                            viewModel.select(item)
                        }
                }
            }
        }
    }
}

struct TabbedMenuView_Previews: PreviewProvider {
    static var previews: some View {
        TabbedMenuView(
            viewModel: .init(
                itemViewModels: [
                    .init(title: "Task", isSelected: true, selection: {}),
                    .init(title: "Field", selection: {}),
                    .init(title: "Attachment", selection: {})
                ]
            )
        )
            .previewLayout(.fixed(width: 400, height: 48))
    }
}

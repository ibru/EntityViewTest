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


struct MenuItemViewModel {
    let title: String
    let isSelected: Bool
    let selection: () -> Void
    
    init(title: String, isSelected: Bool = false, selection: @escaping () -> Void) {
        self.title = title
        self.isSelected = isSelected
        self.selection = selection
    }
}

final class TabbedMenuViewModel: ObservableObject {
    
    private let itemViewModels: [MenuItemViewModel]
    
    init(itemViewModels: [MenuItemViewModel]) {
        self.itemViewModels = itemViewModels
        items = itemViewModels.map {
            .init(title: $0.title, isSelected: $0.isSelected)
        }
    }
    
    @Published var items: [MenuItem]
    
    func select(_ item: MenuItem) {
        items = items.map {
            .init(
                title: $0.title,
                isSelected: $0.id == item.id ? !item.isSelected : false
            )
        }
        if !item.isSelected {
            itemViewModels.first { $0.title == item.title }?.selection()
        }
    }
}

//
//  TabbedMenuViewModel.swift
//  EntityViewTest
//
//  Created by Jiri Urbasek on 23.11.2021.
//

import Foundation

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

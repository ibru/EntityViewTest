//
//  EntityViewModel.swift
//  EntityViewTest
//
//  Created by Jiri Urbasek on 23.11.2021.
//

import UIKit

final class EntityViewModel: ObservableObject {
    struct ContentItem: Identifiable {
        var title: String
        let viewController: () -> UIViewController
        var id: String { title }
    }
    
    @Published var contentItems: [ContentItem] = []
    
    @Published var selectedItem: ContentItem?
    
    
    init(contentItems: [ContentItem], selectedIdx: Int = 0) {
        self.contentItems = contentItems
        
        if selectedIdx >= 0 && selectedIdx < contentItems.count {
            selectedItem = contentItems[selectedIdx]
        }
    }
    
    func show(content: ContentItem) {
        selectedItem = content
    }
}

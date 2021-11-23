//
//  EntityViewModel.swift
//  EntityViewTest
//
//  Created by Jiri Urbasek on 23.11.2021.
//

import UIKit

final class EntityViewModel: ObservableObject {
    struct ContentItem {
        var title: String
        let viewController: () -> UIViewController
    }
    
    @Published var contentItems: [ContentItem] = []
    
    @Published var selectedItem: ContentItem
    
    init(contentItems: [ContentItem], selectedItem: ContentItem) {
        self.contentItems = contentItems
        self.selectedItem = selectedItem
    }
    
    func show(content: ContentItem) {
        selectedItem = content
    }
}

extension EntityViewModel.ContentItem: Identifiable, Equatable, Hashable {
    var id: String { title }
    
    static func == (lhs: EntityViewModel.ContentItem, rhs: EntityViewModel.ContentItem) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

import SwiftUI

extension EntityViewModel.ContentItem {
    var view: ContentItemView {
        .init(item: self)
    }
}

struct ContentItemView: UIViewRepresentable {
    private let item: EntityViewModel.ContentItem
    
    init(item: EntityViewModel.ContentItem) {
        self.item = item
    }
    func makeUIView(context: Context) -> UIView {
        item.viewController().view
    }
    
    func updateUIView(_ view: UIView, context: Context) {
    }
}

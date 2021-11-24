//
//  EntityViewModel.swift
//  EntityViewTest
//
//  Created by Jiri Urbasek on 23.11.2021.
//

import UIKit
import Combine

protocol EntityViewContentPublishing {
    typealias ContentPublisher = AnyPublisher<[EntityViewModel.ContentItem], Never>
    
    var contentPublisher: ContentPublisher { get }
}

final class EntityViewModel: ObservableObject {
    struct ContentItem {
        var title: String
        let viewController: () -> UIViewController
    }
    
    @Published var contentItems: [ContentItem] = []
    
    @Published var selectedItem: ContentItem = .empty
        
    private var cancellables: Set<AnyCancellable> = []
    
    init(contentPublisher: EntityViewContentPublishing) {
        contentPublisher.contentPublisher.sink { [weak self] in
            self?.contentItems = $0
            self?.selectedItem = $0.first ?? .empty
        }.store(in: &cancellables)
    }
    
    func show(content: ContentItem) {
        selectedItem = content
    }
}

extension EntityViewModel.ContentItem {
    static var empty: Self {
        .init(title: "_empty", viewController: { UIViewController() })
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

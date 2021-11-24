//
//  EntityView.swift
//  EntityViewTest
//
//  Created by Jiri Urbasek on 23.11.2021.
//

import SwiftUI

@available(iOS 14.0, *)
struct EntityView: View {
    @ObservedObject var viewModel: EntityViewModel
    
    private var tabbedMenuViewModel: TabbedMenuViewModel {
        .init(
            itemViewModels: viewModel.contentItems.map { contentItem in
                    .init(
                        title: contentItem.title,
                        isSelected: contentItem.id == viewModel.selectedItem.id,
                        selection: { self.viewModel.show(content: contentItem) }
                    )
            }
        )
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle() // screen header
                .fill(Color.white)
                .frame(height: 64)
            
            TabbedMenuView(viewModel: tabbedMenuViewModel)
                .frame(height: 48)

            TabView(selection: $viewModel.selectedItem) {
                ForEach(viewModel.contentItems) { item in
                    item.view
                        .ignoresSafeArea()
                        .tag(item)
                }
            }
            .tabViewStyle(.page)
            .ignoresSafeArea()
        }
    }
}

@available(iOS 14.0, *)
struct EntityView_Previews: PreviewProvider {
    static var previews: some View {
        let selectedItem = EntityViewModel.ContentItem(title: "Fields", viewController: { ContentViewController(title: "Fields", color: .blue) })
        
        return EntityView(viewModel: .init(contentPublisher: [
            .init(title: "Task", viewController: { ContentViewController(title: "My Work Template", color: .gray) }),
            selectedItem,
            .init(title: "Attachments", viewController: { ContentViewController(title: "Attachments", color: .purple) })
        ]))
    }
}

import Combine
extension Array: EntityViewContentPublishing where Element == EntityViewModel.ContentItem {
    var contentPublisher: EntityViewContentPublishing.ContentPublisher {
        Just(self)
            .eraseToAnyPublisher()
    }
}

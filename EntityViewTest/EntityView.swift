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
        VStack {
            TabbedMenuView(viewModel: tabbedMenuViewModel)
                .frame(height: 48)

            TabView(selection: $viewModel.selectedItem) {
                ForEach(viewModel.contentItems) { item in
                    item.view
                        .tag(item)
                }
            }
            .tabViewStyle(.page)
        }
    }
}

@available(iOS 14.0, *)
struct EntityView_Previews: PreviewProvider {
    static var previews: some View {
        let selectedItem = EntityViewModel.ContentItem(title: "Fields", viewController: { ContentViewController(title: "Fields", color: .blue) })
        
        return EntityView(viewModel: .init(contentItems: [
            .init(title: "Task", viewController: { ContentViewController(title: "My Work Template", color: .gray) }),
            selectedItem,
            .init(title: "Attachments", viewController: { ContentViewController(title: "Attachments", color: .purple) })
        ], selectedItem: selectedItem))
    }
}

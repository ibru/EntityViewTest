//
//  TabbedMenuItem.swift
//  EntityViewTest
//
//  Created by Jiri Urbasek on 19.11.2021.
//

import SwiftUI

struct MenuItem {
    let title: String
    let isSelected: Bool
}

extension MenuItem: Identifiable {
    var id: String { title }
}

struct TabbedMenuItem: View {
    
    let item: MenuItem
    
    var body: some View {
        VStack {
            Spacer()
            Text(item.title)
                .foregroundColor(item.isSelected ? .blue : .gray)
                .padding([.leading, .trailing], 16)
            Spacer()
            Rectangle()
                .fill(item.isSelected ? Color.blue : .clear)
                .frame(maxHeight: 4)
        }
    }
}

struct TabbedMenuItem_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            TabbedMenuItem(item: .init(title: "Task", isSelected: true))
            TabbedMenuItem(item: .init(title: "Fields", isSelected: false))
            TabbedMenuItem(item: .init(title: "Attachments", isSelected: false))
        }
        .previewLayout(.fixed(width: 400, height: 48))
    }
}

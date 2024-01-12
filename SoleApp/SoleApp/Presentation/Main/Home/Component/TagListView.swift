//
//  TagListView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/13.
//

import SwiftUI

struct TagListView<Data: Collection, Content: View>: View where Data.Element: Hashable {
    private let availableWidth: CGFloat
    private let data: Data
    private let spacing: CGFloat
    private let alignment: HorizontalAlignment
    private let content: (Data.Element) -> Content
    
    @State var elementSize: [Data.Element: CGSize] = [:]
    
    init(availableWidth: CGFloat,
         data: Data,
         spacing: CGFloat,
         alignment: HorizontalAlignment,
         content: @escaping (Data.Element) -> Content) {
        self.availableWidth = availableWidth
        self.data = data
        self.spacing = spacing
        self.alignment = alignment
        self.content = content
    }
    
    
    var body: some View {
        VStack(alignment: alignment, spacing: spacing) {
            ForEach(0..<computeRows().count, id: \.self) { rowIndex in
                HStack(spacing: spacing) {
                    ForEach(0..<computeRows()[rowIndex].count, id: \.self) { columnIndex in
                        content(computeRows()[rowIndex][columnIndex])
                            .fixedSize()
                            .readSize { size in
                                elementSize[computeRows()[rowIndex][columnIndex]] = size
                            }
                    }
                }
            }
        }
    }
    
    
    func computeRows() -> [[Data.Element]] {
        var rows: [[Data.Element]] = [[]]
        var currentRow = 0
        var remainingWidth = availableWidth
        
        for element in data {
            let elementSize = elementSize[element, default: CGSize(width: availableWidth, height: 1)]
            if remainingWidth >= (elementSize.width + spacing) {
                rows[currentRow].append(element)
            } else {
                currentRow += 1
                rows.append([element])
                remainingWidth = availableWidth
            }
            
            remainingWidth -= (elementSize.width + spacing)
        }
        
//        maxRows = currentRow
        return rows
    }
}

//
//  TagListView.swift
//  SoleApp
//
//  Created by SUN on 2023/03/13.
//

import SwiftUI

struct TagListView<Data: Collection, Content: View>: View where Data.Element: Hashable {
    let availableWidth: CGFloat
    let data: Data
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    @Binding var isExpandedUserTagListView: Bool
    @Binding var maxRows: Int
    let content: (Data.Element) -> Content
    
    @State var elementSize: [Data.Element: CGSize] = [:]
    
    
    
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
                if isExpandedUserTagListView {
                    if currentRow < 2 {
                        rows.append([element])
                        remainingWidth = availableWidth
                    }
                } else {
                    rows.append([element])
                    remainingWidth = availableWidth
                }
            }
            
            remainingWidth -= (elementSize.width + spacing)
        }
        maxRows = currentRow
        return rows
    }
}

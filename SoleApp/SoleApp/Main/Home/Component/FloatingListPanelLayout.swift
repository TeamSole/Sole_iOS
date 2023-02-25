//
//  FloatingListPanelLayout.swift
//  SoleApp
//
//  Created by SUN on 2023/02/24.
//

import FloatingPanel

final class FloatingListPanelLayout: FloatingPanelLayout {
    var position: FloatingPanel.FloatingPanelPosition {
        return .bottom
    }
    
    var initialState: FloatingPanel.FloatingPanelState {
        return .half
    }
    
    var anchors: [FloatingPanel.FloatingPanelState : FloatingPanel.FloatingPanelLayoutAnchoring] {
        return [
            .full: FloatingPanelLayoutAnchor(absoluteInset: 16.0, edge: .top, referenceGuide: .safeArea),
            .half: FloatingPanelLayoutAnchor(absoluteInset: 292, edge: .bottom, referenceGuide: .safeArea),
        ]
    }
     
    
}

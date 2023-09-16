//
//  ScrapListFeature.swift
//  SoleApp
//
//  Created by SUN on 2023/09/17.
//

import ComposableArchitecture

struct ScrapListFeature: Reducer {
    struct State: Equatable {
        var folderId: Int
        var folderName: String
        
        init(folderId: Int, folderName: String) {
            self.folderId = folderId
            self.folderName = folderName
        }
    }
    
    enum Action: Equatable {
       
    }
    
    @Dependency(\.scrapClient) var scrapClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            
            }
        }
    }
}

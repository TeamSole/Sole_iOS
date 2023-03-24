//
//  MoveScrapsPopupModifier.swift
//  SoleApp
//
//  Created by SUN on 2023/03/24.
//

import SwiftUI
import Kingfisher
import Alamofire

struct MoveScrapsPopupModifier: ViewModifier {
    typealias Folders = [ScrapFolderResponseModel.DataModel]
    typealias Folder = ScrapFolderResponseModel.DataModel
    @State private var folderList: Folders = []
    @Binding var isShowFlag: Bool
    let complete: (Int) -> ()
    func body(content: Content) -> some View {
        ZStack() {
            content
            if isShowFlag {
                Color.black
                    .opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        isShowFlag = false
                    }
                contentView
            }
        }
        .onAppear {
            getFolders()
        }
    }
    
    private var contentView: some View {
        VStack(spacing: 0.0) {
            Text("폴더 선택")
                .font(.pretendard(.bold, size: 16.0))
                .foregroundColor(.black)
                .padding(.vertical, 30.0)
            List(0..<folderList.count, id: \.self) { index in
                folderItem(folder: folderList[index])
                    .contentShape(Rectangle())
                    .onTapGesture {
                        guard let folderId = folderList[index].scrapFolderId else { return }
                        complete(folderId)
                        isShowFlag = false
                    }
            }
            .frame(height: 200.0)
            .listStyle(.plain)
            HStack(spacing: 7.0) {
               
            }
            .frame(maxWidth: .infinity)
            .padding(12.0)
        }
        .background(Color.white)
        .frame(width: 300.0)
        .cornerRadius(10.0)
    }
    
    private func folderItem(folder: Folder) -> some View {
        HStack(spacing: 16.0) {
            KFImage(URL(string: folder.scrapFolderImg ?? ""))
                .placeholder {
                    Image("folderImage")
                        .resizable()
                        .frame(width: 32.0,
                               height: 32.0)
                }
                .resizable()
                .frame(width: 32.0,
                       height: 32.0)
            Text(folder.scrapFolderName ?? "")
                .foregroundColor(.black)
                .font(.pretendard(.medium, size: 15.0))
                .frame(maxWidth: .infinity,
                       alignment: .leading)
        }
        .padding(.vertical, 10.0)
    }
    
    func getFolders() {
        let url: URLConvertible = URL(string: K.baseUrl + K.Path.folderList)!
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": Utility.load(key: Constant.token)
        ]
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: ScrapFolderResponseModel.self, completionHandler: { response in
                switch response.result {
                case .success(let response):
                    if response.success == true,
                       let list = response.data {
                        self.folderList = list
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
    }
    
}

struct MoveScrapsPopupModifier_Previews: PreviewProvider {
    static var previews: some View {
        Color.red
            .modifier(MoveScrapsPopupModifier(isShowFlag: .constant(true), complete: { _ in }))
        
    }
}

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
    @State private var errorMessage: String = ""
    @Binding var isShowFlag: Bool
    var scraps: [Int]
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
                        moveScraps(folderId: folderId, scraps: scraps) {
                            complete(folderId)
                            isShowFlag = false
                        }
                    }
            }
            .frame(height: 200.0)
            .listStyle(.plain)
            HStack(spacing: 7.0) {
               Text(errorMessage)
                    .foregroundColor(.red_FF717D)
                    .font(.pretendard(.medium, size: 13.0))
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
            }
            .frame(maxWidth: .infinity)
            .padding(13.0)
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
    
    func moveScraps(folderId: Int, scraps: [Int], complete: @escaping () -> ()) {
        guard scraps.isEmpty == false else { return }
        let url: URLConvertible = URL(string: K.baseUrl + K.Path.folderList + "/default/\(folderId)")!
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": Utility.load(key: Constant.token)
        ]
        let parameter = ["courseIds": scraps]
        AF.request(url, method: .post, parameters: parameter, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .responseDecodable(of: BaseResponse.self, completionHandler: { response in
                switch response.result {
                case .success:
                    complete()
                case .failure(let error):
                    guard let data = response.data else {
                        print(error.localizedDescription)
                        return }
                    let jsonData = try? JSONDecoder().decode(BaseResponse.self, from: data)
                    if jsonData?.code == "S001" {
                        errorMessage = jsonData?.message ?? ""
                    }
                    
                }
            })
    }
    
}

struct MoveScrapsPopupModifier_Previews: PreviewProvider {
    static var previews: some View {
        Color.red
            .modifier(MoveScrapsPopupModifier(isShowFlag: .constant(true), scraps: [], complete: { _ in }))
        
    }
}

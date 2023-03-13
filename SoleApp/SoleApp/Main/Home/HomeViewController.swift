//
//  HomeViewController.swift
//  SoleApp
//
//  Created by SUN on 2023/02/17.
//

import UIKit
import SnapKit

final class HomeViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
        collectionView.isScrollEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(HotCourseCell.self, forCellWithReuseIdentifier: HotCourseCell.identifier)
        collectionView.register(UserTasteCourseCell.self, forCellWithReuseIdentifier: UserTasteCourseCell.identifier)
        collectionView.register(HotCourseHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HotCourseHeader")
        collectionView.register(UserTasteCourseHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "UserTasteCourseHeader")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        let logoImage = UIImage(named: "small_logo")?.withRenderingMode(.alwaysOriginal)
        let profileImage = UIImage(named: "profile24")?.withRenderingMode(.alwaysOriginal)
        let searchImage = UIImage(named: "search24")?.withRenderingMode(.alwaysOriginal)
        let profileButton = UIButton(type: .custom)
        profileButton.setImage(profileImage, for: .normal)
        profileButton.addTarget(self, action: #selector(moveToMyPage), for: .touchUpInside)
        profileButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: logoImage, style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: profileButton),
            UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(moveToSearchVC))]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupUI() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints({
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        })
    }
    
    private func layout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout {[weak self] index, env -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            switch HomeSection.allCases[index] {
            case .hotCourse:
                return self.hotCourseLayout()
            case .User:
                return self.userCourseLayout()
            }
        }
    }
    
    private func userCourseLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 10.0, leading: 0, bottom: 10.0, trailing: 0)
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(300))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        //secion
        let section = NSCollectionLayoutSection(group: group)
        let sectionHeader = createHotCourseHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        section.contentInsets = .init(top: 10.0, leading: 10.0, bottom: 20, trailing: 10.0)
        return section
    }
    
    
    
    private func hotCourseLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.9))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 10, leading: 5, bottom: 0, trailing: 5)
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        //secion
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        let sectionHeader = createHotCourseHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        section.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
        return section
    }
    
    private func createHotCourseHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(30.0))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        return sectionHeader
    }
    
    @objc func moveToMyPage() {
        let vc = MyPageViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func moveToSearchVC() {
        let vc = SearchViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch HomeSection.allCases[indexPath.section] {
        case .hotCourse:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HotCourseCell.identifier, for: indexPath) as? HotCourseCell else { return UICollectionViewCell() }
            cell.backgroundColor = .red
            return cell
        case .User:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserTasteCourseCell.identifier, for: indexPath) as? UserTasteCourseCell else { return UICollectionViewCell() }
            cell.backgroundColor = .blue
            return cell
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            switch HomeSection.allCases[indexPath.section] {
            case .hotCourse:
                guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HotCourseHeader", for: indexPath) as? HotCourseHeader else { fatalError("Could not dequeue Header") }
                return headerView
            case .User:
                guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "UserTasteCourseHeader", for: indexPath) as? UserTasteCourseHeader else { fatalError("Could not dequeue Header") }
                return headerView
            }
        } else {
            return UICollectionReusableView()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return HomeSection.allCases.count
    }
    
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = CourseDetailViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}


enum HomeSection: CaseIterable {
    case hotCourse
    case User
}

//
//  HomeViewController.swift
//  YouTube
//
//  Created by Алексей Авер on 08.08.2025.
//

import UIKit

enum HomeSection: Hashable {
    case videos
    case shorts
}

enum ItemID: Hashable {
    case video(UUID)
    case short(UUID)
}

enum SupplementaryKind {
    static let mainHeader = "main-header"
    static let shortsHeader = SectionHeader.kind
}

final class HomeViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    
    private var dataSource: UICollectionViewDiffableDataSource<HomeSection, ItemID>!
    
    private let viewModel: MainViewViewModel
    
    init(viewModel: MainViewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func loadView() {
        collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: Self.makeLayout())
        collectionView.backgroundColor = .systemBackground
        view = collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCellsAndSupplementaries()
        configureDataSource()
        applySnapshot()
    }
    
    private func registerCellsAndSupplementaries() {
        collectionView.register(VideoCell.self,
                                forCellWithReuseIdentifier: VideoCell.reuseId)
        collectionView.register(ShortsItemCell.self,
                                forCellWithReuseIdentifier: ShortsItemCell.reuseId)
        
        collectionView.register(SectionHeader.self,
                                forSupplementaryViewOfKind: SectionHeader.kind,
                                withReuseIdentifier: SectionHeader.reuseId)
        
        collectionView.register(HeaderContainerView.self,
                                forSupplementaryViewOfKind: SupplementaryKind.mainHeader,
                                withReuseIdentifier: HeaderContainerView.reuseId)
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<HomeSection, ItemID>(
            collectionView: collectionView
        ) { [weak self] collectionView, indexPath, itemID in
            guard let self = self else { return nil }
            
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            
            switch (section, itemID) {
            case (.videos, .video(let vid)):
                guard let video = self.viewModel.videos.first(where: { $0.id == vid }) else {
                    return nil
                }
                
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: VideoCell.reuseId,
                    for: indexPath
                ) as! VideoCell
                cell.configure(with: video)
                return cell
                
            case (.shorts, .short(let sid)):
                guard let short = self.viewModel.shorts.first(where: { $0.id == sid }) else {
                    return nil
                }
                
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ShortsItemCell.reuseId,
                    for: indexPath
                ) as! ShortsItemCell
                cell.configure(with: short)
                return cell
                
            default:
                return UICollectionViewCell()
            }
        }
        
        dataSource.supplementaryViewProvider = { [weak self] cv, kind, indexPath in
            guard let self = self else { return nil }
            switch kind {
            case SupplementaryKind.mainHeader:
                let header = cv.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: HeaderContainerView.reuseId,
                    for: indexPath
                ) as! HeaderContainerView
                return header
                
            case SectionHeader.kind:
                let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
                guard section == .shorts else { return nil }
                
                let header = cv.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: SectionHeader.reuseId,
                    for: indexPath
                ) as! SectionHeader
                return header
                
            default:
                return nil
            }
        }
    }
    
    private func applySnapshot(animated: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<HomeSection, ItemID>()
        snapshot.appendSections([.videos, .shorts])
        
        let videoItems = viewModel.videos.map { ItemID.video($0.id) }
        let shortItems = viewModel.shorts.map { ItemID.short($0.id) }
        
        snapshot.appendItems(videoItems, toSection: .videos)
        snapshot.appendItems(shortItems, toSection: .shorts)
        
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
}

// MARK: - Layout
extension HomeViewController {
    static func makeLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, env in
            switch sectionIndex {
            case 0:
                
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .estimated(300)
                    )
                )
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: item.layoutSize,
                    subitems: [item]
                )
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                section.interGroupSpacing = 0
                return section
                
            case 1:
                
                let shortItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .absolute(160),
                        heightDimension: .absolute(240)
                    )
                )
                
                let visibleCount = 2
                let groupWidth = NSCollectionLayoutDimension.absolute( (160 * CGFloat(visibleCount)) + (12 * CGFloat(visibleCount - 1)) )
                let groupHeight = NSCollectionLayoutDimension.absolute(240)
                
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: groupWidth,
                        heightDimension: groupHeight
                    ),
                    subitem: shortItem,
                    count: visibleCount
                )
                group.interItemSpacing = .fixed(12)
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
                section.interGroupSpacing = 12
                
                let headerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(40)
                )
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: SectionHeader.kind,
                    alignment: .topLeading
                )
                section.boundarySupplementaryItems = [header]
                
                return section
                
            default:
                return nil
            }
        }
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(130)
        )
        let mainHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: SupplementaryKind.mainHeader,
            alignment: .top
        )
        mainHeader.pinToVisibleBounds = false
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.boundarySupplementaryItems = [mainHeader]
        
        layout.configuration = config
        return layout
    }
}

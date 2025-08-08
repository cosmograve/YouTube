//
//  HomeViewController.swift
//  YouTube
//
//  Created by Алексей Авер on 08.08.2025.
//

import UIKit

enum HomeSection: Hashable {
    case videos([Video])
    case shorts([ShortVideo])
}

enum SupplementaryKind {
    static let mainHeader = "main-header"
    static let shortsHeader = "shorts-header"
}

final class HomeViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<HomeSection, UUID>!
    private let viewModel: MainViewViewModel
    
    init(viewModel: MainViewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: Self.makeLayout())
        collectionView.backgroundColor = .systemBackground
        view = collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        configureDataSource()
        applySnapshot()
    }
    
    private func registerCells() {
        collectionView.register(VideoCell.self,
                                forCellWithReuseIdentifier: VideoCell.reuseId)
        collectionView.register(ShortsItemCell.self,
                                forCellWithReuseIdentifier: ShortsItemCell.reuseId)
        collectionView.register(SectionHeader.self,
                                forSupplementaryViewOfKind: SectionHeader.kind,
                                withReuseIdentifier: SectionHeader.reuseId)
        collectionView.register(MainHeaderView.self,
            forSupplementaryViewOfKind: SupplementaryKind.mainHeader,
            withReuseIdentifier: MainHeaderView.reuseId
        )
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<HomeSection, UUID>(
            collectionView: collectionView
        ) { collectionView, indexPath, id in

            switch indexPath.section {
            case 0:
                let video = self.viewModel.videos[indexPath.item]
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: VideoCell.reuseId, for: indexPath) as! VideoCell
                cell.configure(with: video)
                return cell

            case 1:
                let short = self.viewModel.shorts[indexPath.item]
                let cell  = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ShortsItemCell.reuseId, for: indexPath) as! ShortsItemCell
                cell.configure(with: short)
                return cell
            default: return UICollectionViewCell()
            }
        }

        dataSource.supplementaryViewProvider = { cv, kind, indexPath in
            switch kind {
            case SupplementaryKind.mainHeader:
                return cv.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: MainHeaderView.reuseId,
                    for: indexPath)

            case SectionHeader.kind:
                return cv.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: SectionHeader.reuseId,
                    for: indexPath)

            default: return nil
            }
        }
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<HomeSection, UUID>()
        snapshot.appendSections([.videos(viewModel.videos),
                                 .shorts(viewModel.shorts)])

        snapshot.appendItems(viewModel.videos.map(\.id), toSection: .videos(viewModel.videos))
        snapshot.appendItems(viewModel.shorts.map(\.id), toSection: .shorts(viewModel.shorts))

        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension HomeViewController {
    static func makeLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
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
                    subitems: [item])

                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0,
                                                                bottom: 0, trailing: 0)
                return section

            case 1:
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .absolute(160),
                        heightDimension: .absolute(240)
                    )
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: item.layoutSize,
                    subitems: [item])

                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16,
                                                                 bottom: 0, trailing: 16)
                section.interGroupSpacing = 12

                let headerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(40))
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: SectionHeader.kind,
                    alignment: .topLeading)
                section.boundarySupplementaryItems = [header]
                return section
            default:
                return nil
            }
        }
        let headerSize   = NSCollectionLayoutSize(
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

import UIKit

enum ParkRecordSection: String, Hashable, CaseIterable {
    case personalPark = "개인"
    case publicPark = "공영"
    case all = "전체"
}

final class UsageRecordViewController: BaseViewController {
    var dataSource: UICollectionViewDiffableDataSource<ParkRecordSection, Record>!
    var collectionView: UICollectionView! = nil
    let sampleData: [Record] = Record.mockData
    
    override func configureConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        self.navigationItem.title = "이용 기록"
        self.view.backgroundColor = .white
        configureCollectionView()
        super.viewDidLoad()
        configureDataSource()
        setInitialData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
}

extension UsageRecordViewController {
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .null, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemGray6
        view.addSubview(collectionView)
    }
    
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<RecordCell, Record> { [weak self] cell, indexPath, recordID in
            guard let self = self else { return }
            cell.configure(with: sampleData[indexPath.row])
        }
        
        dataSource = UICollectionViewDiffableDataSource<ParkRecordSection, Record>(collectionView: collectionView) { (collectionView, indexPath, identifier) in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }
    
    private func setPostNeedsUpdate(_ items: [Record]) {
        var snapshot = self.dataSource.snapshot()
        snapshot.reconfigureItems(items)
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func setInitialData() {
        var snapshot = NSDiffableDataSourceSnapshot<ParkRecordSection, Record>()
        snapshot.appendSections(ParkRecordSection.allCases)
        snapshot.appendItems(sampleData)
        var items: [Record] = []
        
        for sectionType in ParkRecordSection.allCases {
            for item in sampleData {
                if item.category == sectionType.rawValue {
                    items.append(item)
                }
            }
            snapshot.appendItems(items, toSection: sectionType)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    
    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let columnCount = layoutEnvironment.container.effectiveContentSize.width > 500 ? 3 : 1
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(0.33))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
            group.interItemSpacing = .fixed(20)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 20
            
            return section
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        
        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: sectionProvider, configuration: config)
        
        return layout
    }
}


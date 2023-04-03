
import UIKit
import SnapKit
import RxSwift
import RxDataSources

class AirportsViewController: UIViewController {
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.rowHeight = 175
        tableView.sectionFooterHeight = 1
        tableView.sectionHeaderHeight = 1
        return tableView
    }()
    private let disposeBag = DisposeBag()
    private static let CellId = "AirportCellId"
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<AirportItemsSection>(configureCell: { (_, tableView, indexPath, item) in
        let airportCell = tableView.dequeueReusableCell(withIdentifier: AirportsViewController.CellId, for: indexPath) as! AirportCell
        airportCell.configure(usingViewModel: item as! AirportViewModel) //zaten type of item is AirportViewModel
        return airportCell
    })
    private var viewModel: AirportsViewPresentable!
    var viewModelBuilder: AirportsViewPresentable.ViewModelBuilder!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureView()
        setupConstraints()
        self.viewModel = viewModelBuilder(())
        self.setupUI()
        self.setupBinding()
    }
    
    private func configureView() {
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

private extension AirportsViewController {
    func setupUI() -> Void {
        tableView.register(UINib(nibName: "AirportCell", bundle: nil),
                           forCellReuseIdentifier: AirportsViewController.CellId)
    }
    
    func setupBinding() -> Void {
        self.viewModel.output.airports
            .drive(self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        self.viewModel.output.title
            .drive(self.rx.title)
            .disposed(by: disposeBag)
    }
}

import UIKit
import RxSwift
import RxDataSources

class SearchCityViewController: UIViewController {
    
    private var viewModel: SearchCityViewPresentable!
    var viewModelBuilder: SearchCityViewPresentable.ViewModelBuilder!
    
    private var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 233.0/255.0,
                                       green: 55.0/255.0,
                                       blue: 72.0/255.0,
                                       alpha: 1.0)
        return view
    }()
    
    private static let CellId = "CityCellId"
    private let disposeBag = DisposeBag()
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<CityItemsSection>(configureCell: { _, tableView, indexPath, item in
        let cityCell = tableView.dequeueReusableCell(withIdentifier: SearchCityViewController.CellId, for: indexPath) as! CityCell
        cityCell.configure(usingViewModel: item)
        return cityCell
    })
    
    private var searchTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.white.cgColor
        textField.placeholder = "Search City"
        textField.textAlignment = .left
        textField.font = .systemFont(ofSize: 20)
        textField.backgroundColor = .white
        return textField
    }()
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 100
        tableView.backgroundColor = .lightGray
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Airports"
        configureView()
        setupConstraints()
        viewModel = viewModelBuilder((
            searchText: searchTextField.rx.text.orEmpty.asDriver(),
            citySelect: tableView.rx.modelSelected(CityViewModel.self).asDriver()
        ))
        setupUI()
        setupBinding()
    }
    
    private func configureView() {
        view.addSubviews(
            contentView,
            tableView
        )
        contentView.addSubview(searchTextField)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 150),
            
            searchTextField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            searchTextField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            searchTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -20),
            searchTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            searchTextField.heightAnchor.constraint(equalToConstant: 50),
            
            tableView.topAnchor.constraint(equalTo: contentView.bottomAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

}

private extension SearchCityViewController {
    func setupUI() -> Void {
        tableView.register(UINib(nibName: "CityCell", bundle: nil), forCellReuseIdentifier: SearchCityViewController.CellId)
        self.title = "Airports"
    }
    
    func setupBinding() -> Void {
        
        self.viewModel.output.cities
            .drive(tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: disposeBag)
        
    }
}

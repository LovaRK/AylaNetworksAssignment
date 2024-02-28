//
//  ViewController.swift
//  AylaNetworksAssignment
//
//  Created by MA1424 on 27/02/24.
//

import UIKit
import RxSwift
import RxCocoa

class CountryFactsViewController: UIViewController {
    var viewModel: CountryFactsViewModel
    private let disposeBag = DisposeBag()
    private var tableView: UITableView!
    
    init(viewModel: CountryFactsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
        bindViewModel()
        viewModel.fetchCountryFacts()
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Set default row height
        tableView.rowHeight = 100
        
        tableView.register(CountryFactTableViewCell.self, forCellReuseIdentifier: CountryFactTableViewCell.identifier)
    }

    
    private func bindViewModel() {
        viewModel.title
            .observe(on: MainScheduler.instance)
            .bind(to: self.navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        viewModel.facts
            .bind(to: tableView.rx.items(cellIdentifier: CountryFactTableViewCell.identifier, cellType: CountryFactTableViewCell.self)) { (index, fact, cell) in
                cell.configure(with: fact)
            }
            .disposed(by: disposeBag)
        
        // Bind to the error message
           viewModel.errorMessage
               .observe(on: MainScheduler.instance)
               .subscribe(onNext: { [weak self] errorMessage in
                    AlertView.instance.showAlert(title: "Error", message: errorMessage, alertType: .failure, in: self)
               })
               .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(CountryFact.self)
            .subscribe(onNext: { [weak self] fact in
                print(self?.title ?? "")
                print("Selected fact: \(fact.title ?? "Unknown")")
            })
            .disposed(by: disposeBag)
    }
}


//
//  ViewController.swift
//  Restaurant Rate
//
//  Created by Tigran Oganisyan on 24.01.2022.
//

import UIKit


class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(RestaurantCell.self,
                       forCellReuseIdentifier: RestaurantCell.identifier)
        return table
    }()
    
    private let viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Рестораны"
        self.view.backgroundColor = .white
        viewModel.viewDidLoad()
        configurateNavigationBar()
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    func configurateNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(didTapPlusButton))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.getItems().count != 0 {
            return viewModel.getItems().count
        } else {return 0}
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantCell.identifier,
                                                 for: indexPath as IndexPath) as? RestaurantCell else { return UITableViewCell()
        }
        let item = viewModel.getItems()[indexPath.row]
        cell.configure(name: item.name, imageData: item.picture, totalRate: item.totalRate)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive,
                                        title: "Удалить",
                                        handler: { (action, view, contextualHandler) in
            
            let alert = UIAlertController(title: "Удаление объекта",
                                          message: "Вы точно хотите удалить объект?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Удалить",
                                          style: .destructive,
                                          handler: { [self] action in
                let position = indexPath.row
                viewModel.deleteItem(position: position)

                tableView.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "Отмена",
                                          style: .cancel,
                                          handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
        )
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    @objc private func didTapPlusButton() {
        let vc = RestaurantViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension MainViewController: MainViewModelDelegate {
    
}

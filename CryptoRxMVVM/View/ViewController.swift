//
//  ViewController.swift
//  CryptoRxMVVM
//
//  Created by Berkan Aydın on 19.02.2025.
//

import UIKit
import RxSwift
import RxCocoa


class ViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    let cryptoVM = CryptoViewModel()
    let disposeBag = DisposeBag()
    //var cryptoList = [Crypto]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        view.backgroundColor =  .black
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        setupBindings()
        cryptoVM.requestData()
    }

    private func setupBindings() {
        
        cryptoVM
            .loading
            .bind(to: self.indicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        
        cryptoVM
            .error
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { errorString in
                print(errorString)
            }
            .disposed(by: disposeBag)
        
        
        /*
        cryptoVM
            .cryptos
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { cryptos in
                self.cryptoList = cryptos
                self.tableView.reloadData()
            }.disposed(by: disposeBag)
        */
        
        
        
        cryptoVM
            .cryptos
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: tableView.rx.items(cellIdentifier: "CryptoCell", cellType: CryptoTableViewCell.self)) {row,item,cell in
                cell.item = item
            }
            .disposed(by: disposeBag)
        
        
        
        
        tableView.rx.modelSelected(Crypto.self).subscribe(onNext: { item in
            print("SelectedItem: \(item.currency)")
        }).disposed(by: disposeBag)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    /*
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptoList.count
    }
    
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = cryptoList[indexPath.row].currency
        content.secondaryText = cryptoList[indexPath.row].price
        cell.contentConfiguration = content
        return cell
    }
     */
}


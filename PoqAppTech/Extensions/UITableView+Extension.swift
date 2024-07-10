//
//  UITableView+Extension.swift
//  PoqAppTech
//
//  Created by Екатерина Лаптева on 10.07.24.
//

import UIKit

extension UITableView {
    
    func register<T: UITableViewCell>(_ cell: T.Type) {
        let reuseIdentifier = String(describing: T.self)
        register(T.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    func dequeue<T: UITableViewCell>(_ cell: T.Type, completion: ((T) -> Void)? = nil) -> T {
        let reuseIdentifier = String(describing: T.self)
        guard let cell = dequeueReusableCell(withIdentifier: reuseIdentifier) as? T else {
            return T()
        }
        completion?(cell)
        return cell
    }
}

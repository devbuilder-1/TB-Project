//
//  ExpenseTableViewCell.swift
//  TBInterview
//
//  Created by Prithiv Dev on 17/07/21.
//

import Foundation
import UIKit

class ExpenseTableViewCell: UITableViewCell {
    
    ///the id for the cell
    static let id = "ExpenseTableViewCell"
    
    //MARK: - All UI Elements Initialization
    var mainLabel :  UILabel! = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    var categoryLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.storm
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    var amount : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.storm
        label.font = UIFont.systemFont(ofSize: 16, weight:.regular)
        return label
    }()
    
    
    ///this is a test view to check the height of the cell
//    var vi : UIView = {
//        let v = UIView()
//        v.backgroundColor = .red
//        return v
//    }()

    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //MARK: - All Constraints
        ///add all the constraints
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 6
        contentView.addSubview(mainLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(amount)

        ///main overview label
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.text = ""
        mainLabel.sizeToFit()
        NSLayoutConstraint.activate([
            mainLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            mainLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
        
        ///category label
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.text = ""
        categoryLabel.sizeToFit()
        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 4),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
        
        ///amount label
        amount.translatesAutoresizingMaskIntoConstraints = false
        amount.text = ""
        amount.sizeToFit()
        NSLayoutConstraint.activate([
            amount.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0),
            amount.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
        
        
        //contentView.addSubview(vi)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        ///add padding
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        ///add the test rectangle to see if it is 75
        //vi.frame = CGRect(x: 150, y: 0, width: 5, height: 75)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

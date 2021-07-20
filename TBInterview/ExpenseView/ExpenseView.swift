//
//  ViewController.swift
//  TBInterview
//
//  Created by Zachary Rhodes on 5/25/21.
//

import UIKit
import Combine
import Lottie

class ExpenseView: UIViewController, UITableViewDelegate, UITableViewDataSource, ObservableObject {
    
    //MARK: - Data etc.. Initialization
    let presenter = ExpensePresenter()
    var cancel : AnyCancellable?
    
    
    ///the main data that is used to update the tableview
    var data = [expenseData]()
    {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    
    //MARK: - All UI Elements Initialization
    ///Expense overview elements
    ///add all expense labels as a subview to this view
    var expenseView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    ///the main tableview
    var tableView = UITableView()
    
    ///overview label
    var overViewLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.text = ""
        return label
    }()
    
    ///most spent label
    var mostSpentLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor.storm
        label.text = "You spent the most on:"
        return label
    }()
    
    ///monthly most spent label
    var monthlySpentLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor.storm
        label.text = "Total monthly spend:"
        return label
    }()
    
    ///most spent answer label
    var mostSpentAnswerlabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = UIColor.black
        label.text = ""
        return label
    }()
    
    ///most spent answer label
    var monthlySpentAnswerlabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        // label.textColor = UIColor.black
        label.text = ""
        return label
    }()
    
    
    ///the lottie animation view
    private var animationView : AnimationView = {
        var animationview = AnimationView()
        animationview = .init(name: "thumbsUp")
        animationview.contentMode = .scaleAspectFit
        animationview.loopMode = .playOnce
        animationview.animationSpeed = 0.5
        return animationview
    }()
    
    
    
    
    // MARK: - View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ///add the UI elements and add constaraints
        configureUIandConstraints()
        
        ///add tableview datasource, delegate etc.
        configureTableView()
        
        ///receive the data
        setUpReceiver()
        
    }
    
    
    
    
    
    // MARK: - Receiver setup from presenter
    func setUpReceiver() {
        
        cancel = self.presenter.expenseData
            .sink(receiveCompletion: {_ in}, receiveValue: { [weak self] value in
                ///set the receieved value to the data
                self?.data = value
                
                ///set up label data inside the closure
                self?.presenter.getBudgetColorAndAmount(data: value, completionHandler: { [weak self] (amount, color, bool,category) in
                    
                    ///monthly label
                    self?.monthlySpentAnswerlabel.text = amount
                    self?.monthlySpentAnswerlabel.textColor = color
                    
                    ///category label
                    self?.mostSpentAnswerlabel.text = category
                    
                    
                    ///animation
                    self?.playAnimation(play: bool)
                })
            })}
    
    
    
    
    
    
    // MARK: - UI Element Configuration
    func configureUIandConstraints()  {
        
        ///add a white background
        self.view.backgroundColor = .white
        
        ///add the expense view to the main view and add it's constraints
        self.view.addSubview(expenseView)
        expenseView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            expenseView.heightAnchor.constraint(equalToConstant: 140),
            expenseView.widthAnchor.constraint(equalTo: view.widthAnchor),
            expenseView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0)
        ])
        
        
        ///add the tableview to the view and postion it below the expense view
        self.view.addSubview(tableView)
        tableView.backgroundColor = UIColor.zircon
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tableView.topAnchor.constraint(equalTo: expenseView.bottomAnchor, constant: 0),
            tableView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: 0)
        ])
        
        
        ///main overview label
        self.view.addSubview(overViewLabel)
        overViewLabel.translatesAutoresizingMaskIntoConstraints = false
        overViewLabel.text = "\(self.presenter.month()) Overview"
        overViewLabel.sizeToFit()
        NSLayoutConstraint.activate([
            overViewLabel.topAnchor.constraint(equalTo: expenseView.topAnchor, constant: 16),
            overViewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        
        ///most spent label
        self.view.addSubview(mostSpentLabel)
        mostSpentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mostSpentLabel.topAnchor.constraint(equalTo: overViewLabel.bottomAnchor, constant: 30),
            mostSpentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mostSpentLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        
        ///monthly spent label
        self.view.addSubview(monthlySpentLabel)
        monthlySpentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            monthlySpentLabel.topAnchor.constraint(equalTo: mostSpentLabel.bottomAnchor, constant: 12),
            monthlySpentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            monthlySpentLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        
        ///most spent answer label
        self.view.addSubview(mostSpentAnswerlabel)
        mostSpentAnswerlabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mostSpentAnswerlabel.topAnchor.constraint(equalTo: overViewLabel.bottomAnchor, constant: 30),
            mostSpentAnswerlabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mostSpentAnswerlabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        
        ///monthly spent answer label
        self.view.addSubview(monthlySpentAnswerlabel)
        monthlySpentAnswerlabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            monthlySpentAnswerlabel.topAnchor.constraint(equalTo: mostSpentLabel.bottomAnchor, constant: 12),
            monthlySpentAnswerlabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            monthlySpentAnswerlabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        
        ///animationview
        self.view.addSubview(animationView)
        animationView.isHidden = true
        animationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
           animationView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 150),
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.widthAnchor.constraint(equalToConstant: 400),
            animationView.heightAnchor.constraint(equalToConstant: 400)
        ])
        
        
    }
    
    
    
    
    // MARK: - Lottie Animation Functions
    private func playAnimation(play : Bool) {
        if play {
            self.animationView.isHidden = false
            self.animationView.play()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                self.animationView.stop()
                self.animationView.isHidden = true
            }
        }
    }
    
    
    
    // MARK: - TableView Functions
    private func configureTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = 91
        self.tableView.allowsSelection = false
        self.tableView.backgroundColor = UIColor.zircon
        self.tableView.register(ExpenseTableViewCell.self, forCellReuseIdentifier: ExpenseTableViewCell.id)
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier:ExpenseTableViewCell.id, for: indexPath) as? ExpenseTableViewCell {
            cell.mainLabel?.text = data[indexPath.row].title
            cell.amount.text = "$\(data[indexPath.row].amount)"
            cell.categoryLabel.text = self.presenter.getCategoryString(category: data[indexPath.row].category ?? "")
            cell.backgroundColor = UIColor.zircon
            return cell
        }
        
        else {
            return ExpenseTableViewCell()
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    
    
}

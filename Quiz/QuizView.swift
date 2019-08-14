//  
//  QuizView.swift
//  Quiz
//
//  Created by Felipe Fleming on 12/08/19.
//  Copyright © 2019 Fleming. All rights reserved.
//

import UIKit

class QuizView: UIViewController {

    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var hitsLabel: UILabel!
    @IBOutlet var countdownLabel: UILabel!
    @IBOutlet var startResetButton: UIButton!
    @IBOutlet var wordTextField: UITextField!
    @IBOutlet var bottomSpaceConstraint: NSLayoutConstraint!
    
    private let cellIdentifier = "keywordCell"

    var viewModel = QuizViewModel()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: .zero)
        startResetButton.layer.cornerRadius = 10.0
        self.setupViewModel()
        self.viewModel.startQuiz()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    fileprivate func setupViewModel() {
        self.viewModel.didStartGettingData = {
            LoadingUtils.displayLoadingView(forParentView: self.view)
            self.questionLabel.isHidden = self.viewModel.isLoading
            self.wordTextField.isHidden = self.viewModel.isLoading
            self.wordTextField.isEnabled = self.viewModel.isResponding
            self.tableView.isHidden = self.viewModel.isLoading
        }
        
        self.viewModel.didGetData = {
            LoadingUtils.hideActivityIndicator()
            self.questionLabel.isHidden = self.viewModel.isLoading
            self.wordTextField.isHidden = self.viewModel.isLoading
            self.wordTextField.isEnabled = self.viewModel.isResponding
            self.tableView.isHidden = self.viewModel.isLoading
            self.questionLabel.text = self.viewModel.question
            self.startResetButton.setTitle(self.viewModel.buttonString, for: .normal)
        }
        
        self.viewModel.raizeAlert = {
            self.view.endEditing(true)
            let alertView = UIAlertController(title: self.viewModel.alertTitle, message: self.viewModel.alertMessage, preferredStyle: .alert)
            let alertButton = UIAlertAction(title: self.viewModel.alertButtonText, style: .default, handler: { (_) in
                self.viewModel.resetQuiz()
            })
            alertView.addAction(alertButton)
            self.present(alertView, animated: true, completion: nil)
        }
        
        self.viewModel.shouldUpdateForHitOrReset = {
            self.wordTextField.text = ""
            self.hitsLabel.text = self.viewModel.hitsString
            self.tableView.reloadData()
        }
        
        self.viewModel.didUpdateCountdown = {
            self.countdownLabel.text = self.viewModel.countdownString
        }
        
        self.viewModel.didStartStopResponding = {
            self.wordTextField.text = ""
            self.wordTextField.isEnabled = self.viewModel.isResponding
            self.startResetButton.setTitle(self.viewModel.buttonString, for: .normal)
        }
    }
    
    @IBAction func startResetButtonPressed(_ sender: UIButton) {
        if self.viewModel.isResponding {
            self.viewModel.resetQuiz()
        } else {
            self.viewModel.startQuizBind()
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.bottomSpaceConstraint.constant = (UIDevice.current.orientation.isLandscape && UIDevice.current.userInterfaceIdiom == .phone) ? 0 : keyboardSize.height
                
            UIView.animate(withDuration: 0.5) {
                self.view.setNeedsUpdateConstraints()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.bottomSpaceConstraint.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.view.setNeedsUpdateConstraints()
        }
    }
}

extension QuizView: UITableViewDelegate {
    
}

extension QuizView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.keywords.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        cell?.textLabel?.text = self.viewModel.keywords[indexPath.row]
        return cell ?? UITableViewCell()
    }
}

extension QuizView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {
            return !self.viewModel.checkHit(word: text + string)
        }
        return false
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

//
//  CrashViewController.swift
//  BuglyDemo
//
//  Created by Zack.Zhang on 9/16/19.
//  Copyright © 2019 Zack.Zhang. All rights reserved.
//

import UIKit
import RealmSwift

class CrashViewModel: NSObject {
    var isNew: Bool = false
}

class CrashViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var numbers = [Int]()
    var viewModel: CrashViewModel!
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - 1. 数组越界
    @IBAction func outofRange() {
        print(Array(1...5)[6])
    }
    
    //MARK: - 2. 调用已经销毁的对象
    @IBAction func pointDeinitedObject() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            [unowned self] in
            print(self)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - 3. 未在info.plist文件设置权限
    @IBAction func plistWithoutPermission() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
    }
    
    //MARK: - 4. 非可选值为nil时被调用
    @IBAction func pointNilObject() {
        print(self.viewModel.isNew)
    }
    
    //MARK: - 5. 未给segue设置对应的identifier
    @IBAction func segueWithoutIdentifier() {
        self.performSegue(withIdentifier: "UnknownSegueIdentifier", sender: nil)
    }
    
    //MARK: - 6. 未给cell设置对应的identifier
    @IBAction func cellWithoutIdentifier() {
        self.numbers = [1, 2, 3]
        self.tableView.reloadData()
    }

    //MARK: - 7. RLModel字段新增或者变更，但未更新realm数据库版本
    @IBAction func updatedFieldWithoutUpdatingRealm() {
        let realm = try! Realm()
        let result = realm.objects(RLModel.self)
        print(result)
    }
    
    //MARK: - 8. 递归导致栈溢出
    @IBAction func outofStack() {
        self.test(a: 1000000) {
            print(self)
        }
    }
    
    func test(a: Int, closure: ()->Void) {
        if a == 0 {
            closure()
        }
        else {
            self.test(a: a - 1, closure: closure)
        }
    }
}

extension CrashViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numbers.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellWithoutIdentifier", for: indexPath)
        cell.textLabel?.text = "\(self.numbers[indexPath.row])"
        return cell
    }
}

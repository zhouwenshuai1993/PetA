//
//  MineVController.swift
//  SwiftFirstAPP
//
//  Created by 嗯，大葱 on 2018/6/20.
//  Copyright © 2018年 嗯，大葱. All rights reserved.
//

import UIKit

class MineVController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureV();
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func configureV() {
        self.navigationController?.navigationBar.isTranslucent = false;
        self.view.backgroundColor = UIColor.lightText;
    }

}

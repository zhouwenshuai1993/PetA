//
//  OneVController.swift
//  SwiftFirstAPP
//
//  Created by 嗯，大葱 on 2018/6/20.
//  Copyright © 2018年 嗯，大葱. All rights reserved.
//

import UIKit
import SDWebImage
class clasName {
    let s1 = 100
    let s2 = 200
    let s3 = 300
}

class OneVController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    //定义一个可变数组VAR   不可变数组 let
    var dataArr:[String] = ["小倩","韦小宝","刘小懂","莫僧人"];
    var dataArr2:[String] = ["222","335","6434","6446"];
    var dataArr3:[String] = ["你吃饭了吗","干嘛呢在","昨天的发片给我发一下","谢谢你"];
    let tableView = UITableView(frame: CGRect(x:0,y:0,width:UIScreen.main.bounds.size.width,height:UIScreen.main.bounds.size.height), style: UITableViewStyle.plain)

    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = UIColor.white;
        self.navigationItem.title = "会话列表";
    }
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
    
        let x1 = clasName();
        
        
        print(pateHight,x1.s1);
        self.configureVC();
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    func configureVC() {
        //关闭导航栏半透明效果
        self.navigationController?.navigationBar.isTranslucent = false
        self.view.backgroundColor = UIColor.white;
        self.navigationController?.navigationBar.barTintColor = UIColor.blue;
//        let label = UILabel(frame:CGRect(x:50,y:100,width:100,height:100));
//        label.text = "13214321";
//        self.view.addSubview(label);
        
     tableView .register(UINib.init(nibName: "OneCell", bundle: nil), forCellReuseIdentifier: "OneCell")
        self.view.addSubview(tableView);
        tableView.delegate=self;
        tableView.dataSource = self;
        tableView.backgroundColor = UIColor.white;
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none;
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 65;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: OneCell = tableView.dequeueReusableCell(withIdentifier: "OneCell") as! OneCell;
        let title :String = dataArr[indexPath.section]
        cell.selectionStyle = UITableViewCellSelectionStyle.none;
        cell.titlLB.text = title;
        cell.photoImageV.image = UIImage.init(named: dataArr2[indexPath.section])
        cell.contentLB.text = dataArr3[indexPath.section];
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("1111111",indexPath.row);
        let Oc:OCVController = OCVController.init();
        Oc.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(Oc, animated: true);
        
    }
    
}

//
//  BaseBarVController.swift
//  SwiftFirstAPP
//
//  Created by 嗯，大葱 on 2018/6/20.
//  Copyright © 2018年 嗯，大葱. All rights reserved.
//

import UIKit

class BaseBarVController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        let VC1 = OneVController();
        VC1.title = "小信";
//        VC1.view.backgroundColor = UIColor.gray;
        let na1 = UINavigationController(rootViewController:VC1);
        
   
       
         VC1.tabBarItem.image = UIImage(named: "petfriend_gray")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
         VC1.tabBarItem.selectedImage = UIImage(named:"petfriend")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        // Do any additional setup after loading the view.
        
        
        
        let VC2 = MineVController();
        VC2.title = "我的";
        VC2.view.backgroundColor = UIColor.white;
        // 设置标题，未选中状态图标，选中状态图标
        VC2.tabBarItem.image = UIImage(named: "mine_gray")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        VC2.tabBarItem.selectedImage = UIImage(named:"mine")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        let na2 = UINavigationController(rootViewController:VC2);
        
        // 1 打开用户交互
        self.tabBar.isUserInteractionEnabled = true;
        // 2 设置背景颜色
        self.tabBar.backgroundColor = UIColor.white;
        // 3 设置背景图片
        self.tabBar.backgroundImage = UIImage(named: "");
        // 4 选中时的背景图片
        self.tabBar.selectionIndicatorImage = UIImage(named: "");
        
        
    
      
        self.tabBar.barTintColor = UIColor.white;
        // 注意：视图控制器超过5个时（不包含5）会自动生成一个more视图标签，用来控制第5、6、...以后的视图控制器。
        self.viewControllers = [na1,na2];
        // 属性设置
        // 设置默认被选中视图控制器
        self.selectedIndex = 0;
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       NSLog("回收内存");
        
    }
    


}

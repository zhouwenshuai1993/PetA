//
//  OneCell.swift
//  SwiftFirstAPP
//
//  Created by 嗯，大葱 on 2018/6/21.
//  Copyright © 2018年 嗯，大葱. All rights reserved.
//

import UIKit

class OneCell: UITableViewCell {

    @IBOutlet var titlLB: UILabel!
    
    
    @IBOutlet var contentLB: UILabel!
    
    
    @IBOutlet var photoImageV: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func draw(_ rect: CGRect) {
        
        let context:CGContext = UIGraphicsGetCurrentContext()!;
        
        
        
        context.setFillColor(UIColor.clear.cgColor);
        context.fill(rect);
        
        //    //上分割线，
        //    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor); CGContextStrokeRect(context, CGRectMake(5, -1, rect.size.width - 10, 1));
        //    下分割线
        context.setStrokeColor(UIColor.gray.cgColor);
        context.stroke(CGRect(x:0, y:rect.size.height, width:rect.size.width-0, height:1));
        //
    }
    
}

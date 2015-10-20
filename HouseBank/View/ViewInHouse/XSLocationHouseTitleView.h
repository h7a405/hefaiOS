//
//  XSLocationHouseTitleView.h
//  HouseBank
//  显示定位信息的titleview
//  Created by 鹰眼 on 14-9-22.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XSLocationHouseTitleView : UIView
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *locationInfo;
-(void)setLocationContent:(NSString *)location;
@end

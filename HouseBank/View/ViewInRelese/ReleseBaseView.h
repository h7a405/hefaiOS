//
//  ReleseBaseView.h
//  HouseBank
//
//  Created by CSC on 15/1/26.
//  Copyright (c) 2015年 QCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpImgBean.h"
#import "ReleaseWsImpl.h"
#import "UIPlaceHolderTextView.h"

/**
 为一个傻逼程序员写的基类，能把代码写的每个相同的操作都必须在六个地方写，您也真够奇葩的，您不累，我也累啊。
 */
@interface ReleseBaseView : UIView{
    UIViewController *_vc ;
    UIImage *_doorModelFigure;
    UIImage *_housePropertyCardFigure;
    UIImage *_delegateFigure;
    NSString *_houseImages;
}

-(void) startUpImage : (NSArray *) imgs ;
-(void) onUpImageBegan ;
-(void) onUpImageComplete : (NSString *) result ;

@end

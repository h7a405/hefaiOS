//
//  ArticleViewController.h
//  HouseBank
//
//  Created by 鹰眼 on 14-9-15.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "BaseViewController.h"


//首页点击滚动的订阅页
@class ArticleData;
@interface ArticleViewController : BaseViewController
@property(nonatomic,strong)ArticleData *article;
@end

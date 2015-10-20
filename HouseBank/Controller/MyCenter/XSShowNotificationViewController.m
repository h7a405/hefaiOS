//
//  XSShowNotificationViewController.m
//  HouseBank
//
//  Created by 鹰眼 on 14/10/22.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "XSShowNotificationViewController.h"
#import "XSNotification.h"
@interface XSShowNotificationViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *content;

@end

@implementation XSShowNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleLabel.text=_notification.title;
    _content.text=_notification.content;
    _content.frame=(CGRect){_content.frame.origin,[TextUtil sizeWithContent:_content]};
}


@end

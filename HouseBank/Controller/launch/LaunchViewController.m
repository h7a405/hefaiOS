//
//  LaunchViewController.m
//  HouseBank
//
//  Created by CSC on 15/1/9.
//  Copyright (c) 2015年 QCloud. All rights reserved.
//

#import "LaunchViewController.h"
#import "FYUserDao.h"

@interface LaunchViewController (){
    UIScrollView *_scrollview;
}

-(void) initialize;

@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialize];
}

-(void) initialize{
    self.view.frame = [UIScreen mainScreen].bounds;
    _scrollview = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollview.pagingEnabled = YES;
    _scrollview.showsVerticalScrollIndicator = NO;
    _scrollview.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_scrollview];
    
    NSArray *images = [NSArray arrayWithObjects:@"loading1.jpg",@"loading2.jpg",@"loading3.jpg",@"loading4.jpg", nil];
    _scrollview.contentSize = CGSizeMake(self.view.frame.size.width, _scrollview.frame.size.height*images.count);
    
    float width = _scrollview.frame.size.width;
    float height = _scrollview.frame.size.height;
    for (int i = 0; i <images.count ; i++ ) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect(0, height*i, width, height)];
        imageView.image = [UIImage imageNamed:images[i]];
        
        [_scrollview addSubview:imageView];
    }
    
    UIButton *btn = [[UIButton alloc] initWithFrame:rect((_scrollview.frame.size.width - 100)/2, _scrollview.bounds.size.height*4 - 50, 100, 35)];
    btn.backgroundColor = KNavBGColor;
    [btn setTitle:@"立即体验" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(touch) forControlEvents:UIControlEventTouchUpInside];
    [_scrollview addSubview:btn];
}

-(void) touch {
    [[FYUserDao new] setIsLaunch:YES];
    [self presentViewController: [[UIStoryboard storyboardWithName:@"Home" bundle:nil]instantiateViewControllerWithIdentifier:@"RootViewController"] animated:YES completion:^{}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

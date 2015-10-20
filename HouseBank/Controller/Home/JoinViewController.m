//
//  JoinViewController.m
//  HouseBank
//
//  Created by CSC on 14/12/29.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "JoinViewController.h"
#import "SeeViewController.h"

@interface JoinViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)seeBtnTapped:(id)sender;

- (IBAction)joinBtnTapped:(id)sender;

-(void) initialize;

@end

//我要加盟
@implementation JoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialize];
}

- (IBAction)seeBtnTapped:(id)sender {
    SeeViewController *vc = [SeeViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)joinBtnTapped:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void) initialize{
    self.navigationItem.title = @"年薪百万分行行长";
    
    if (IPhone4) {
        self.view.frame = [UIScreen mainScreen].bounds;
        _scrollView.contentSize = _scrollView.frame.size;
        _scrollView.frame = self.view.bounds;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

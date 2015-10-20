//
//  RegisterGuideViewController.m
//  HouseBank
//
//  Created by SilversRayleigh on 2/6/15.
//  Copyright (c) 2015年 QCloud. All rights reserved.
//

#import "RegisterGuideViewController.h"
#import "RegisterHandlerViewController.h"
#import "DistributionViewController.h"
#import "UserPromoteViewController.h"

@interface RegisterGuideViewController ()<UIActionSheetDelegate>

@end

@implementation RegisterGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        [self gotoDistribution];
    }else if (buttonIndex == 1){
        [self gotoPromotion];
    }
}


#pragma mark - Event
- (IBAction)openTestChosen:(id)sender{
    UIActionSheet *actionSheet_temp = [[UIActionSheet alloc]initWithTitle:@"Choose" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Distribution" otherButtonTitles:@"Promotion", nil];
    [actionSheet_temp showInView:self.view];
}

- (IBAction)gotoRegisterMember:(id)sender{
    RegisterHandlerViewController *registerHandlerViewCtrl = [self getRegisterHandlerViewCtrl];
    registerHandlerViewCtrl.currentRegistrationType = FYMemberRegistration;
    [self.navigationController pushViewController:registerHandlerViewCtrl animated:YES];
}

- (IBAction)gotoRegisterBroker:(id)sender{
    RegisterHandlerViewController *registerHandlerViewCtrl = [self getRegisterHandlerViewCtrl];
    registerHandlerViewCtrl.currentRegistrationType = FYBrokerRegistration;
    [self.navigationController pushViewController:registerHandlerViewCtrl animated:YES];
}

- (IBAction)gotoRegisterPresident:(id)sender{
    RegisterHandlerViewController *registerHandlerViewCtrl = [self getRegisterHandlerViewCtrl];
    registerHandlerViewCtrl.currentRegistrationType = FYPresidentRegistration;
    [self.navigationController pushViewController:registerHandlerViewCtrl animated:YES];
}

- (IBAction)gotoRegisterShareholder:(id)sender{
    RegisterHandlerViewController *registerHandlerViewCtrl = [self getRegisterHandlerViewCtrl];
    registerHandlerViewCtrl.currentRegistrationType = FYShareholderRegistration;
    [self.navigationController pushViewController:registerHandlerViewCtrl animated:YES];
}

#pragma mark - Private
- (RegisterHandlerViewController *)getRegisterHandlerViewCtrl{
    RegisterHandlerViewController *registerHandlerViewCtrl = [[RegisterHandlerViewController alloc]init];
    return registerHandlerViewCtrl;
}

- (void)gotoDistribution{
    DistributionViewController *distributionViewCtrl = [[DistributionViewController alloc]init];
    [distributionViewCtrl.view setFrame:self.view.frame];
    [self.navigationController pushViewController:distributionViewCtrl animated:YES];
}

- (void)gotoPromotion{
    UserPromoteViewController *promotionViewCtrl = [[UserPromoteViewController alloc]init];
    [promotionViewCtrl.view setFrame:self.view.frame];
    [self.navigationController pushViewController:promotionViewCtrl animated:YES];
}

@end

//
//  UserPromoteViewController.m
//  HouseBank
//
//  Created by SilversRayleigh on 8/6/15.
//  Copyright (c) 2015年 QCloud. All rights reserved.
//

#import "UserPromoteViewController.h"
#import "PromotionHandlerViewController.h"

static NSInteger const COUNT_SECTION = 1;
static NSInteger const COUNT_ROW_SECTION = 3;
static NSInteger const HEIGHT_ROW_SECTION = 100;

@interface UserPromoteViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation UserPromoteViewController

#pragma mark - life
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if(self.currentUserStatus == FYUSERPROMOTIONHOLDING)
    [self.view addSubview:self.tableView];
    else {
        self.view.backgroundColor = [UIColor whiteColor];
        UIAlertView *alertView_temp = [[UIAlertView alloc]initWithTitle:@"合发房银提醒您：" message:@"您已提交过申请，请耐心等候。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView_temp show];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.navigationItem.title = @"升级认证";
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

#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return COUNT_SECTION;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return COUNT_ROW_SECTION;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT_ROW_SECTION;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell%d", indexPath.row]];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[NSString stringWithFormat:@"cell%d", indexPath.row]];
        switch (indexPath.row) {
            case 0:{
                UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 20, 60, 60)];
//                imgView.backgroundColor = [UIColor orangeColor];
                NSString *path = [[NSBundle mainBundle]pathForResource:@"FYBroker@2x" ofType:@"png"];
                [imgView setImage:[UIImage imageWithContentsOfFile:path ]];
                [cell.contentView addSubview:imgView];
                UIButton *btn_promote = [[UIButton alloc]initWithFrame:CGRectMake(94, 20, 120, 30)];
                [btn_promote setTitle:@"申请成为经纪人" forState:UIControlStateNormal];
                [btn_promote.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
                [btn_promote setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                [cell.contentView addSubview:btn_promote];
                UILabel *lb_note = [[UILabel alloc]initWithFrame:CGRectMake(94, 42, 218, 50)];
                lb_note.text = @"升级成功后您将自动成为您所在分行的认证经纪人，若您未加入任何分行，则自动加入您推荐人所在分行。";
                lb_note.textColor = [UIColor lightGrayColor];
                lb_note.font = [UIFont systemFontOfSize:12.0];
                lb_note.numberOfLines = 3;
                lb_note.lineBreakMode = NSLineBreakByCharWrapping;
                [cell.contentView addSubview:lb_note];
                if(self.currentUserRank > FYRANKMEMBER){
                    [btn_promote setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                    [btn_promote setEnabled:NO];
                }else{
                    [btn_promote addTarget:self action:@selector(gotoPoromotion:) forControlEvents:UIControlEventTouchUpInside];
                }
                break;
            }
            case 1:{
                UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 20, 60, 60)];
//                imgView.backgroundColor = [UIColor redColor];
                NSString *path = [[NSBundle mainBundle]pathForResource:@"FYPresident@2x" ofType:@"png"];
                [imgView setImage:[UIImage imageWithContentsOfFile:path ]];
                [cell.contentView addSubview:imgView];
                UIButton *btn_promote = [[UIButton alloc]initWithFrame:CGRectMake(94, 20, 120, 30)];
                [btn_promote setTitle:@"申请成为分行长" forState:UIControlStateNormal];
                [btn_promote.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
                [btn_promote setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                [cell.contentView addSubview:btn_promote];
                UILabel *lb_note = [[UILabel alloc]initWithFrame:CGRectMake(94, 42, 218, 50)];
                lb_note.text = @"申请成功后您将自动成为您所在片区的分行长。";
                lb_note.textColor = [UIColor lightGrayColor];
                lb_note.font = [UIFont systemFontOfSize:12.0];
                lb_note.numberOfLines = 3;
                lb_note.lineBreakMode = NSLineBreakByCharWrapping;
                [cell.contentView addSubview:lb_note];
                if(self.currentUserRank > FYRANKBROKER){
                    [btn_promote setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                    [btn_promote setEnabled:NO];
                }else{
                    [btn_promote addTarget:self action:@selector(gotoPoromotion:) forControlEvents:UIControlEventTouchUpInside];
                }
                break;
            }
            case 2:{
                UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 20, 60, 60)];
//                imgView.backgroundColor = [UIColor blueColor];
                NSString *path = [[NSBundle mainBundle]pathForResource:@"FYShareHolder@2x" ofType:@"png"];
                [imgView setImage:[UIImage imageWithContentsOfFile:path ]];
                [cell.contentView addSubview:imgView];
                UIButton *btn_promote = [[UIButton alloc]initWithFrame:CGRectMake(94, 20, 120, 30)];
                [btn_promote setTitle:@"申请成为股权人" forState:UIControlStateNormal];
                [btn_promote.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
                [btn_promote setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                [cell.contentView addSubview:btn_promote];
                UILabel *lb_note = [[UILabel alloc]initWithFrame:CGRectMake(94, 42, 218, 50)];
                lb_note.text = @"申请成功后您将自动成为您所在片区的分行长。";
                lb_note.textColor = [UIColor lightGrayColor];
                lb_note.font = [UIFont systemFontOfSize:12.0];
                lb_note.numberOfLines = 3;
                lb_note.lineBreakMode = NSLineBreakByCharWrapping;
                [cell.contentView addSubview:lb_note];
                if(self.currentUserRank > FYRANKPRESIDENT){
                    [btn_promote setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                    [btn_promote setEnabled:NO];
                }else{
                    [btn_promote addTarget:self action:@selector(gotoPoromotion:) forControlEvents:UIControlEventTouchUpInside];
                }
                break;
            }
            default:
                break;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - event
- (void)gotoPoromotion:(id)sender{
    PromotionHandlerViewController *promotionHandlerViewCtrl = [[PromotionHandlerViewController alloc]init];
    [promotionHandlerViewCtrl.view setFrame:self.view.frame];
    [self.navigationController pushViewController:promotionHandlerViewCtrl animated:YES];
}

#pragma mark - private

#pragma mark - getter/setter
- (UITableView *)tableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    }
    return _tableView;
}
@end

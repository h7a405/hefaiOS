//
//  XSNeedViewController.m
//  HouseBank
//
//  Created by 鹰眼 on 14-10-13.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "XSNeedViewController.h"
#import "XSNeedListCell.h"
#import "MJRefresh.h"
#import "XSNeedBean.h"
#import "XSNeedDetailViewController.h"
#import "XSNeedFilterViewController.h"
#import "BackButton.h"
#import "FYUserDao.h"
#import "KeyboardToolView.h"
#import "AFNetworking.h"
#import "NSDictionary+String.h"
#import "MBProgressHUD+Add.h"
#import "FYCustomerNeedsDao.h"
#import "CustomerNeedsWsImpl.h"

@interface XSNeedViewController ()<UITableViewDelegate,UITableViewDataSource,KeyboardToolDelegate,UITextFieldDelegate>
{
    NSInteger _pageNo;
    
    NSString *_keyWord;
    /**
     *  搜索记录
     */
    NSMutableArray *_resultData;
    /**
     *  历史记录
     */
    NSMutableArray *_historyData;
    
    NSString *_communityId;
    
    BOOL _isSearch;
    
}
@property(nonatomic,strong)NSMutableArray *data;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)AFHTTPRequestOperationManager *request;
@property (weak, nonatomic) IBOutlet UIView *resultView;

@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (weak, nonatomic) IBOutlet UIButton *buttonCancel;
@property (weak, nonatomic) IBOutlet BackButton *backButton;
@property (weak, nonatomic) IBOutlet UIImageView *searchBg;
@property (weak, nonatomic) IBOutlet UIImageView *searchButton;


@property (weak, nonatomic) IBOutlet UITableView *searchResultTableView;
@property (weak, nonatomic) IBOutlet UITableView *history;
@property (weak, nonatomic) IBOutlet UIView *noDataShowView;
@end

@implementation XSNeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _keyWord=@"";
    _data=[NSMutableArray array];
    _resultData=[NSMutableArray array];
    _historyData=[NSMutableArray array];
    
    _communityId=@"0";
    _resultView.hidden=YES;
    [self setupTableView];
    
    [self setupSearchResultTable];
    if (IPhone4) {
        _tableView.frame = rect(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, _tableView.frame.size.height-88);
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [self.view endEditing:YES];
    [super viewDidAppear:animated];
}

#pragma mark - 初始化view
-(void)setupSearchResultTable
{
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, KWidth, 30)];
    label.text=@"  搜索历史";
    label.font=[UIFont systemFontOfSize:14.0];
    label.backgroundColor=[UIColor lightGrayColor];
    _history.tableHeaderView=label;
}
#pragma mark - 初始化footer view
-(void)setupTableFooterView
{
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, KWidth, 30)];
    if (_historyData.count>0) {
        _history.tableFooterView=button;
    }else{
        _history.tableFooterView=nil;
        return;
    }
    button.titleLabel.font=[UIFont systemFontOfSize:14.0];
    button.backgroundColor=[UIColor lightGrayColor];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:@"清除历史记录" forState:UIControlStateNormal];
    
    [button addTarget:self  action:@selector(cleanAllHistory) forControlEvents:UIControlEventTouchUpInside];
}

-(void)cleanAllHistory{
    FYCustomerNeedsDao *dao = [FYCustomerNeedsDao new];
    [dao removeAllHistoryForNeed];
    [self showHistory];
}
#pragma mark - 初始化view
-(void)setupTableView{
    [_tableView addHeaderWithTarget:self action:@selector(headerRefenre)];
    [_tableView addFooterWithTarget:self action:@selector(footerReference)];
    [_tableView headerBeginRefreshing];
}
#pragma mark - 刷新数据
-(void)headerRefenre
{
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _pageNo=1;
    
    [self loadMoreData];
}
-(void)footerReference
{
    _pageNo++;
    [self loadMoreData];
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - tableview datasourse and delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_tableView==tableView) {
        return _data.count;
    }else if (_history==tableView){
        
        return _historyData.count;
    }
    
    return _resultData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==_tableView){
        XSNeedListCell *cell=[tableView dequeueReusableCellWithIdentifier:@"XSNeedListCell"];
        if (cell==nil) {
            cell=[XSNeedListCell cell];
        }
        cell.model=_data[indexPath.row];
        return cell;
    }else if(_history==tableView){//历史
        static   NSString *ID=@"History";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            cell.textLabel.font=[UIFont systemFontOfSize:16.0];
            cell.detailTextLabel.font=[UIFont systemFontOfSize:12.0];
            cell.detailTextLabel.textColor=[UIColor grayColor];
        }
        NSDictionary *dict=_historyData[indexPath.row];
        cell.textLabel.text=dict[@"communityName"];
        return cell;
    }else{//结果
        static   NSString *ID=@"ResultForNeed";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            cell.textLabel.font=[UIFont systemFontOfSize:16.0];
            cell.detailTextLabel.font=[UIFont systemFontOfSize:12.0];
            cell.detailTextLabel.textColor=[UIColor grayColor];
        }
        NSDictionary *dict=_resultData[indexPath.row];
        //cell.textLabel.text=dict[@"communityName"];
        cell.textLabel.attributedText=[ViewUtil content:dict[@"communityName"] colorString:_searchText.text];
        // cell.detailTextLabel.text=dict[@"address"];
        cell.detailTextLabel.attributedText=[ViewUtil content:dict[@"address"] colorString:_searchText.text];
        
        return cell;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==_tableView){
        XSNeedListCell *cell=(XSNeedListCell *)[tableView cellForRowAtIndexPath:indexPath];
        [self performSegueWithIdentifier:@"needInfoDetail" sender:cell.model];
    }else if(tableView==_searchResultTableView){
        _isSearch=YES;
        [self.view endEditing:YES];
        
        FYCustomerNeedsDao *dao = [FYCustomerNeedsDao new];
        [dao saveHistoryForNeed:_resultData[indexPath.row]];
        _communityId=_resultData[indexPath.row][@"communityId"];
        _searchText.text=_resultData[indexPath.row][@"communityName"];
        [_tableView headerBeginRefreshing];
        _keyWord=_searchText.text;
        [self hideSearchDataView];
        [self endSearchEdit];
        
    }else{
        _searchText.text=_historyData[indexPath.row][@"communityName"];
        _keyWord=_searchText.text;
        _communityId=_historyData[indexPath.row][@"communityId"];
        
        [_tableView headerBeginRefreshing];
        [self endSearchEdit];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tableView==tableView) {
        return 137.f;
    }else if(_history==tableView){
        return 44;
    }else{
        return 44;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
#pragma mark - 跳转页面前处理
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"needInfoDetail"]){
        XSNeedDetailViewController *detail=segue.destinationViewController;
        detail.model=sender;
    }else if ([segue.identifier isEqualToString:@"NeedTypeRent"]){
        XSNeedFilterViewController *filter=segue.destinationViewController;
        filter.type=NeedTypeRent;
    }else if ([segue.identifier isEqualToString:@"NeedTypeSell"]){
        XSNeedFilterViewController *filter=segue.destinationViewController;
        filter.type=NeedTypeSell;
    }
    
}
#pragma mark - 加载数据
-(void)loadMoreData{
    FYUserDao *userDao = [FYUserDao new];
    UserBean *user = [userDao user];
    
    CustomerNeedsWsImpl *ws = [CustomerNeedsWsImpl new];
    [ws requestCustomerNeeds:user.sid pageNo:_pageNo communityId:_communityId result:^(BOOL isSuccess, id result, NSString *data) {
        if (isSuccess) {
            _tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
            NSArray *data=[result objectForKey:@"data"];
            if(_pageNo==1){
                [_data removeAllObjects];
            }
            
            [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [_data addObject:[XSNeedBean modelObjectWithDictionary:[obj allStringObjDict]]];
            }];
            
            if (_data.count>0) {
                _tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
                _resultView.hidden=YES;
            }else{
                _resultView.hidden=NO;
            }
            [_tableView reloadData];
        }else{
            [MBProgressHUD showNetErrorToView:[KAPPDelegate window]];
        }
        
        if (_pageNo==1) {
            [_tableView headerEndRefreshing];
        }else{
            [_tableView footerEndRefreshing];
        }
    }];
}

#pragma mark - 代理
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    KeyboardToolView *tool=[[KeyboardToolView alloc]init];
    tool.delegate=self;
    textField.inputAccessoryView=tool;
    [tool setButtonTitle:@"取消"];
    [self beginSearchEdit];
    return YES;
}

-(void)keyboardTool:(KeyboardToolView *)tool didClickFinished:(UIButton *)button
{
    [self.view endEditing:YES];
    if (_resultData.count==0) {
        [self endSearchEdit];
    }
    
}
#pragma mark - 开始搜索
-(void)beginSearchEdit
{
    [self showHistory];
    [self hideResultView];
    if (![_searchText.text isEqualToString:@""]) {
        _searchText.text=@"";
    }
    _backButton.hidden=YES;
    [UIView animateWithDuration:0.25 animations:^{
        CGRect bgFrame=_searchBg.frame;
        bgFrame.origin.x-=KMoveWidth;
        bgFrame.size.width+=KMoveWidth-30;
        _searchBg.frame=bgFrame;
        CGRect buttonFrame=_searchButton.frame;
        buttonFrame.origin.x-=KMoveWidth;
        _searchButton.frame=buttonFrame;
        CGRect frame=_searchText.frame;
        frame.origin.x-=KMoveWidth;
        frame.size.width+=KMoveWidth-30;
        _searchText.frame=frame;
    }];
    _buttonCancel.hidden=NO;
}
#pragma mark - 结束搜索
-(void)endSearchEdit
{
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect bgFrame=_searchBg.frame;
        bgFrame.origin.x+=KMoveWidth;
        bgFrame.size.width-=KMoveWidth-30;
        _searchBg.frame=bgFrame;
        CGRect buttonFrame=_searchButton.frame;
        buttonFrame.origin.x+=KMoveWidth;
        _searchButton.frame=buttonFrame;
        CGRect frame=_searchText.frame;
        frame.origin.x+=KMoveWidth;
        frame.size.width-=KMoveWidth-30;
        _searchText.frame=frame;
    }];
    
    _backButton.hidden=NO;
    _buttonCancel.hidden=YES;
    [self.view endEditing:YES];
    [self hideHistory];
    [self hideResultView];
    [self hideSearchDataView];
    
    if (_request) {
        [_request.operationQueue cancelAllOperations];
    }
    
}
#pragma mark - 搜索框输入发生变化
- (IBAction)searchTextChange:(UITextField *)sender
{
    if ([_keyWord isEqualToString:sender.text]) {
        return;
    }
    _keyWord=sender.text;
    if ([_keyWord isEqualToString:@""]) {
        [self showHistory];
        [self hideSearchDataView];
    }else{
        [self searchData];
    }
    
}
#pragma mark - 取消搜索
- (IBAction)cancelSearch:(id)sender
{
    
    [_searchText resignFirstResponder];
    
    [self endSearchEdit];
    _keyWord=@"";
    [_tableView headerBeginRefreshing];
}
#pragma mark - 查找数据
-(void)searchData{
    if (_request) {
        [_resultData removeAllObjects];
        [_searchResultTableView reloadData];
        [_request.operationQueue cancelAllOperations];
        _request = nil;
    }
    
    _request = [[CustomerNeedsWsImpl new] searchCustomerNeeds:_keyWord pageSize:@"20" :^(BOOL isSuccess, id result, NSString *data) {
        if (isSuccess) {
            if (![[result objectForKey:@"data"] isKindOfClass:[NSNull class]]) {
                _resultView.hidden=YES;
                _history.hidden=YES;
                NSArray *data=[result objectForKey:@"data"];
                [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [_resultData addObject:obj];
                }];
                [self showSearchDataView];
                if (_resultData.count==0) {
                    [self showResultView];
                }
            }else{
                [self showResultView];
            }
        }
    }];
}

#pragma  mark - 显示  隐藏
-(void)showHistory
{
    _history.hidden=NO;
    
    [_historyData removeAllObjects];
    FYCustomerNeedsDao *dao = [FYCustomerNeedsDao new];
    [_historyData addObjectsFromArray:[dao searchHistoryForNeed]];
    [self setupTableFooterView];
    [_history reloadData];
}
-(void)hideHistory
{
    _history.hidden=YES;
}
-(void)showResultView
{
    _resultView.hidden=NO;
}
-(void)hideResultView
{
    _resultView.hidden=YES;
}
-(void)showSearchDataView
{
    _searchResultTableView.hidden=NO;
    [_searchResultTableView reloadData];
}
-(void)hideSearchDataView
{
    _searchResultTableView.hidden=YES;
}



@end

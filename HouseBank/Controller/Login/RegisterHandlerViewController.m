//
//  TestViewController.m
//  HouseBank
//
//  Created by SilversRayleigh on 2/6/15.
//  Copyright (c) 2015年 QCloud. All rights reserved.
//

#import "RegisterHandlerViewController.h"
#import "Address.h"
#import "SelectTypeView.h"
#import "KeyboardToolView.h"
#import "Tool.h"
#import "MBProgressHUD.h"
#import "LoginWsImpl.h"
#import "ResultCode.h"
#import "MBProgressHUD+Add.h"
#import "FYUploadImgTask.h"
#import "UpImgBean.h"

#pragma mark - 宏
#define X_ORGIN_TEXTFIELD 111
#define Y_ORGIN_TEXTFIELD 7
#define WIDTH_TEXTFIELD 190
#define HEIGHT_TEXTFIELD 30
#define WIDTH_TEXTFIELD_STOCK 100
#define WIDTH_TEXTFIELD_VALIDATE 110

#define X_ORIGIN_IMAGEVIEW 120
#define Y_ORIGIN_IMAGEVIEW_FRONT 15
#define Y_ORIGIN_IMAGEVIEW_BACK (Y_ORIGIN_IMAGEVIEW_FRONT * 2 + WIDTH_IMAGEVIEW)
#define WIDTH_IMAGEVIEW 80

#define WIDTH_SEGEMENT 150

#define HEIGHT_EXTRA_BUTTON 15
#define WIDTH_EXTRA_BUTTON 60

#define GAP_NOTE 5
#define HEIGHT_NOTE 55
#define SIZE_FONT_TEXT_NOTE 13.0

#define HEIGHT_DEFAULT_CELL 44
#define HEIGHT_RECOMMENDBY_CELL 92
#define HEIGHT_IDCARD_CELL 100

#define NUMBER_SECTION 1

#define TEXT_MEMBER @"会员注册"
#define TEXT_BROKER @"经纪人注册"
#define TEXT_PRESIDENT @"分行长注册"
#define TEXT_SHAREHOLDER @"股权人注册"

#define TEXT_NOTE @"手机号码作为登陆账号，注册成功后登陆账号不能修改，请填写真是手机号，以便客户能联系到您。"
#define TEXT_GETVADALITE @"获取验证码"
#define TEXT_AGREEMENT @"同意【合发房银】注册协议"
#define TEXT_SUBMIT @"提交"

#define TEXT_PHONENUMBER @"手机号码："
#define TEXT_VALIDATENUMBER @"验证码："
#define TEXT_PASSWORD @"密码："
#define TEXT_CONFIRMPASSWORD @"确认密码："
#define TEXT_REALNAME @"真实姓名："
#define TEXT_ADDRESS @"所在地区："
#define TEXT_REGISTERWAY @"注册方式："
#define TEXT_RECOMMENDERNAME @"推荐人姓名："
#define TEXT_RECOMMENDERPHONE @"推荐人手机："
#define TEXT_RECOMMENDBY @"推荐人"
#define TEXT_RECOMMENDED @"推广代码"
#define TEXT_RECOMMENDCODE @"推广代码："
#define TEXT_IDNUMBER @"身份证号码："
#define TEXT_IDCARDIMAGE @"身份证图片："
#define TEXT_IDCARDFRONT @"(点击上传)"
#define TEXT_IDCARDBACK @"（反面）"
#define TEXT_STOCKS @"购买股权："
#define TEXT_YUAN @"元"

#define HexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

static NSString * const STRING_TITLE_ALERTVIEW = @"合发房银提醒您：";
static NSString * const STRING_CANCEL_ALERTVIEW = @"确定";

#pragma mark - enum

@interface RegisterHandlerViewController()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SelectTypeViewDelegate, KeyboardToolDelegate>

#pragma mark - 控件变量
@property (strong, nonatomic) UIView *view_recommendBy;
@property (strong, nonatomic) UIView *view_recommended;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UITextField *txt_phoneNumber;
@property (strong, nonatomic) UITextField *txt_validateNumber;
@property (strong, nonatomic) UITextField *txt_password;
@property (strong, nonatomic) UITextField *txt_confirmPassword;
@property (strong, nonatomic) UITextField *txt_realname;
@property (strong, nonatomic) UITextField *txt_address;
@property (strong, nonatomic) UITextField *txt_idNumber;
@property (strong, nonatomic) UITextField *txt_recommenderName;
@property (strong, nonatomic) UITextField *txt_recommenderPhone;
@property (strong, nonatomic) UITextField *txt_recommendCode;
@property (strong, nonatomic) UITextField *txt_stockCount;
@property (strong, nonatomic) UIImageView *imgView_idCardFront;
@property (strong, nonatomic) UIImageView *imgView_idCardBack;
@property (strong, nonatomic) UIImageView *imgView_checkbox;
@property (strong, nonatomic) UISegmentedControl *seg_recommendWay;
@property (strong, nonatomic) UILabel *lb_note;
@property (strong, nonatomic) UILabel *lb_idFront;
@property (strong, nonatomic) UILabel *lb_idBack;
@property (strong, nonatomic) UILabel *lb_recommendName;
@property (strong, nonatomic) UILabel *lb_recommendPhone;
@property (strong, nonatomic) UILabel *lb_recommendCode;
@property (strong, nonatomic) UILabel *lb_yuan;
@property (strong, nonatomic) UIButton *btn_getValidateCode;
@property (strong, nonatomic) UIButton *btn_agreement;
@property (strong, nonatomic) UIButton *btn_submit;

#pragma mark - 成员变量
@property (strong, nonatomic) NSArray *array_textFeild;
@property (strong, nonatomic) NSArray *array_cellIdentify;
@property (strong, nonatomic) NSArray *province;
@property (strong, nonatomic) NSArray *city;
@property (strong, nonatomic) NSArray *area;
@property (strong, nonatomic) NSArray *strees;
@property (strong, nonatomic) NSString *cityId;
@property (strong, nonatomic) NSString *areaId;
@property (strong, nonatomic) NSString *streesId;
@property (strong, nonatomic) NSString *addressInfo;
@property (strong, nonatomic) NSString *string_idCardImagePath;
@property (assign, nonatomic) AddressLevel level;
@property (assign, nonatomic) BOOL isFrontImgViewClicked;
@property (assign, nonatomic) BOOL isFrontImgViewSelected;
@property (assign, nonatomic) BOOL isBackImgViewSelected;
@property (assign, nonatomic) BOOL isAgreementChosen;

@end

@implementation RegisterHandlerViewController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self setTitleOfView];
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

#pragma mark - 代理实现
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return NUMBER_SECTION;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array_cellIdentify.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 1){
        return HEIGHT_NOTE;
    } else if (self.currentRegistrationType != FYMemberRegistration){
        if(indexPath.row == 8){
            return HEIGHT_IDCARD_CELL;
        } else if(indexPath.row == 10){
            if(self.seg_recommendWay.selectedSegmentIndex == 0)
            return HEIGHT_RECOMMENDBY_CELL;
            else return HEIGHT_DEFAULT_CELL;
        }
    } else if (self.currentRegistrationType == FYMemberRegistration){
        if(indexPath.row == 8){
            if(self.seg_recommendWay.selectedSegmentIndex == 0)
                return HEIGHT_RECOMMENDBY_CELL;
            else return HEIGHT_DEFAULT_CELL;
        }
    }
    return HEIGHT_DEFAULT_CELL;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.array_cellIdentify[indexPath.row]];
    if(cell == nil){
        cell = [self getCellWithIndexPath:indexPath];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSTimeInterval animationDuration = 0.3f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField==self.txt_address) {
        [self.view endEditing:YES];
        [self showSelectTypeView:AddressLevelProvince];
        KeyboardToolView *tool=[[KeyboardToolView alloc]init];
        tool.delegate=self;
        textField.inputAccessoryView=tool;
        return NO;
    }
    return YES;
}
-(void)keyboardTool:(KeyboardToolView *)tool didClickFinished:(UIButton *)button{
    [self.view endEditing:YES];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if([string isEqualToString:@"\n"]){
        [textField resignFirstResponder];
        return NO;
    } else if (string.length == 0){
        return YES;
    }
    if (self.txt_validateNumber == textField){
        if(textField.text.length >= 6){
            return NO;
        }
    } else if (self.txt_recommendCode == textField){
        if(textField.text.length >= 8){
            return NO;
        }
    } else if (self.txt_phoneNumber == textField || self.txt_recommenderPhone == textField){
        if(textField.text.length >= 11){
            return NO;
        }
    } else if (self.txt_idNumber == textField){
        if(textField.text.length >= 18){
            return NO;
        }
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if(self.txt_address == textField || self.txt_recommendCode == textField || self.txt_recommenderName == textField || self.txt_recommenderPhone == textField || self.txt_stockCount == textField || self.txt_idNumber == textField){
    int offset = self.view.frame.size.height - (self.view.frame.size.height - 216);//键盘高度216
    NSTimeInterval animationDuration = 0.45f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    if(offset > 0){
        CGRect rect = CGRectMake(0.0f, -offset,width,height);
        self.view.frame = rect;
    }
    [UIView commitAnimations];
    }
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 800001) {
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    //来源:相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 1:
                    //来源:相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                case 2:
                    return;
            }
        }
        else {
            if (buttonIndex == 1) {
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        imagePickerController.navigationBar.backgroundColor = [UIColor blackColor];
        [self presentViewController:imagePickerController animated:YES completion:^{

        }];
    }
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if(self.isFrontImgViewClicked) {
        self.imgView_idCardFront.image = image;
        [self uploadImage];
//        self.isFrontImgViewSelected = YES;
    }else{
        self.imgView_idCardBack.image = image;
        self.isBackImgViewSelected = YES;
    }
}

#pragma mark - 事件响应
- (void)onUploadImageButtonTouchedUpInside:(id)sender{
    [self uploadImage];
}
- (void)segmentValueChanged:(id)sender{
    NSUInteger index;
    if(self.currentRegistrationType == FYMemberRegistration){
        index = 8;
    } else {
        index = 10;
    }
    NSIndexPath * indexPath =  [NSIndexPath indexPathForRow:index inSection:0];
    NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    [self doResignFirstResponder];
}
#pragma mark - 选择地区 - 根据level判断拿的数据
-(void)typeView:(SelectTypeView *)view didSelect:(NSString *)str selectIndex:(NSInteger)index{
    if (_level==AddressLevelProvince) {
        _addressInfo=str;
    }else{
        _addressInfo= [_addressInfo stringByAppendingString:str];
    }
    
    self.txt_address.text=_addressInfo;
    
    if (_level==AddressLevelProvince) {
        _city=[Address citysWithProvience:_province[index]];
        
        Address *address=_city[0];
        
        if (_city.count==1&&[str isEqualToString:address.name]) {
            _cityId=[NSString stringWithFormat:@"%@",[_city[0] tid]];
            _area=[Address areasWithCity:_city[0]];
            [self showSelectTypeView:AddressLevelArea];
        }else{
            [self showSelectTypeView:AddressLevelCity];
        }
    }else if (_level==AddressLevelCity){
        _cityId=[NSString stringWithFormat:@"%@",[_city[index] tid]];
        _area=[Address areasWithCity:_city[index]];
        [self showSelectTypeView:AddressLevelArea];
    }else if (_level==AddressLevelArea){
        _areaId=[NSString stringWithFormat:@"%@",[_area[index] tid]];
        
        _strees=[Address streesWithArea:_area[index]];
        [self showSelectTypeView:AddressLevelStreet];
    }else{
        _streesId=[NSString stringWithFormat:@"%@",[_strees[index] tid]];
    }
}
#pragma mark - 选择地址
-(void)showSelectTypeView:(AddressLevel)level{
    SelectTypeView *view=[[SelectTypeView alloc]init];
    [view setClickButtonFrame:CGRectMake(0, 50, 0, 0)];
    view.delegate=self;
    NSMutableArray *tmp=[NSMutableArray array];
    _level=level;
    if (level==AddressLevelProvince) {
        _province=[Address getAllProvience];
        [_province enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Address *address=obj;
            [tmp addObject:address.name];
        }];
        [view showWithTitle:@"请选择省份"];
    }else if (level==AddressLevelCity){
        [_city enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Address *address=obj;
            [tmp addObject:address.name];
        }];
        [view showWithTitle:@"请选择城市"];
    }else if (level==AddressLevelArea){
        [_area enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Address *address=obj;
            [tmp addObject:address.name];
        }];
        [view showWithTitle:@"请选择区域"];
    }else if (level==AddressLevelStreet){
        [_strees enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Address *address=obj;
            [tmp addObject:address.name];
        }];
        [view showWithTitle:@"请选择版块"];
    }
    view.data = tmp;
}

- (void)doCallActionSheet:(UITapGestureRecognizer *)gesture{
    [self doResignFirstResponder];
    if(gesture.view.tag == 900001){
        self.isFrontImgViewClicked = YES;
    } else {
        self.isFrontImgViewClicked = NO;
    }
    UIActionSheet *actionSheet_temp;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        actionSheet_temp = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
    }else{
        actionSheet_temp = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消"destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
    actionSheet_temp.tag = 800001;
    [actionSheet_temp showInView:[UIApplication sharedApplication].keyWindow];
}
- (void)doGetValidateCode:(id)sender{
    [self startTimer];
    UIAlertView *alerView_temp = [[UIAlertView alloc]initWithTitle:STRING_TITLE_ALERTVIEW message:@"验证码已发送，请注意接收。" delegate:self cancelButtonTitle:STRING_CANCEL_ALERTVIEW otherButtonTitles:nil, nil];
    [alerView_temp show];
}
- (void)doResignFirstResponder{
    for(UITextField *textField in self.array_textFeild){
        [textField resignFirstResponder];
    }
    NSTimeInterval animationDuration = 0.3f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
}
- (void)doAgreementCheck{
    self.isAgreementChosen = !self.isAgreementChosen;
    if(self.isAgreementChosen){
        NSString *path = [[NSBundle mainBundle]pathForResource:@"agreementClicked@2x" ofType:@"png"];
        [self.imgView_checkbox setImage:[UIImage imageWithContentsOfFile:path]];
    }else{
        NSString *path = [[NSBundle mainBundle]pathForResource:@"agreementUnclicked@2x" ofType:@"png"];
        [self.imgView_checkbox setImage:[UIImage imageWithContentsOfFile:path]];
    }
}
- (void)doSubmitRegistration{
    if(self.isAgreementChosen){
//        if([self checkEmptyTextField]){
            if([self checkAllClear]){
                [MBProgressHUD showHUDAddedTo:[KAPPDelegate window] animated:YES];
                NSString *string_recommenderName;
                NSString *string_recommenderPhone;
                NSString *string_recommenderCode;
                NSString *string_stockCount;
                if(self.seg_recommendWay.selectedSegmentIndex == 0){
                    string_recommenderCode = nil;
                    string_recommenderName = self.txt_recommenderName.text;
                    string_recommenderPhone = self.txt_recommenderPhone.text;
                }else{
                    string_recommenderCode = self.txt_recommendCode.text;
                    string_recommenderName = nil;
                    string_recommenderPhone = nil;
                }
                if(self.currentRegistrationType != FYShareholderRegistration){
                    string_stockCount = nil;
                }else {
                    string_stockCount = self.txt_stockCount.text;
                }
                LoginWsImpl *ws = [LoginWsImpl new];
                if(self.currentRegistrationType == FYMemberRegistration){
                    [ws registMemberWithPhone:self.txt_phoneNumber.text andPassword:self.txt_password.text andRealname:self.txt_realname.text andCityId:self.cityId andRegionId:self.areaId andBlockId:self.streesId andRecommender:string_recommenderName andRecommendPhone:string_recommenderPhone andRecommendCode:string_recommenderCode andResult:^(BOOL isSuccess, id result, NSString *data){
                        [MBProgressHUD hideHUDForView:[KAPPDelegate window] animated:YES];
                        NSLog(@"%s || data:%@ and isSuccess:%i", __FUNCTION__, data, isSuccess);
                        if([result isKindOfClass:[NSDictionary class]]){
                            if ([data intValue] == 501)  {
                                [[[UIAlertView alloc]initWithTitle:@"提示" message:@"该手机号已注册过,请直接登录,或者换个手机号再重试" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
                                //                        }else if(Register([data intValue])){
                            } else if([data intValue] == 502){
                                [[[UIAlertView alloc]initWithTitle:@"合发房银提醒您：" message:@"该推荐人不存在，请确认后再试" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
                            }else if([data intValue] == 0){
                                [MBProgressHUD showMessag:@"注册成功!" toView:[KAPPDelegate window]];
                                [self.navigationController popToRootViewControllerAnimated:YES];
                            }else{
                                [[[UIAlertView alloc]initWithTitle:@"提示" message:@"注册失败!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
                            }
                        } else {
                            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"注册失败!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
                        }
                    }];
                }else{
                    [ws registDistributeCharacterWithPhone:self.txt_phoneNumber.text andPassword:self.txt_password.text andRealname:self.txt_realname.text andCityId:self.cityId andRegionId:self.areaId andBlockId:self.streesId andRecommender:string_recommenderName andRecommendPhone:string_recommenderPhone andRecommendCode:string_recommenderCode andApplyChainId:[NSString stringWithFormat:@"%d", (self.currentRegistrationType + 1)] andIdentity:self.txt_idNumber.text andApplyPrice:string_stockCount andImage:self.string_idCardImagePath andResult:^(BOOL isSuccess, id result, NSString *data){
                        [MBProgressHUD hideHUDForView:[KAPPDelegate window] animated:YES];
                        NSLog(@"%s || result:%@ andReturnData:%@", __FUNCTION__, result, data);
                        if([data intValue] == 0){
                            [MBProgressHUD showMessag:@"注册成功!" toView:[KAPPDelegate window]];
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        }else if ([data intValue] == 501)  {
                            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"该手机号已注册过,请直接登录,或者换个手机号再重试" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
                            //                        }else if(Register([data intValue])){
                        } else if([data intValue] == 502){
                            [[[UIAlertView alloc]initWithTitle:@"合发房银提醒您：" message:@"该推荐人不存在，请确认后再试" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
                        } else {
                            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"注册失败!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
                        }
                    }];
                }
            }
//        }else{
//            UIAlertView *alertView_temp = [[UIAlertView alloc]initWithTitle:STRING_TITLE_ALERTVIEW message:@"请填写必要的注册信息。" delegate:self cancelButtonTitle:STRING_CANCEL_ALERTVIEW otherButtonTitles:nil, nil];
//            [alertView_temp show];
//        }
    }else{
        UIAlertView *alertView_temp = [[UIAlertView alloc]initWithTitle:STRING_TITLE_ALERTVIEW message:@"请先同意注册协议。" delegate:self cancelButtonTitle:STRING_CANCEL_ALERTVIEW otherButtonTitles:nil, nil];
        [alertView_temp show];
    }
}

-(void) uploadImage{
    NSMutableArray *array = [NSMutableArray new];
    if (self.isFrontImgViewClicked) {
        UpImgBean *bean = [UpImgBean new];
        bean.mainMark = 1;
        bean.type = 2;
        bean.img = self.imgView_idCardFront.image;
        [array addObject:bean];
        [self startUploadImage:array];
    }else{
        UIAlertView *alertView_temp = [[UIAlertView alloc]initWithTitle:STRING_TITLE_ALERTVIEW message:@"请先选择照片。" delegate:self cancelButtonTitle:STRING_CANCEL_ALERTVIEW otherButtonTitles:nil, nil];
        [alertView_temp show];
    }
}

-(void) startUploadImage : (NSArray *) imgs{
    [self onUploadImageBegan];
    FYUploadImgTask *task = [FYUploadImgTask new];
    [task upimg:imgs result:^(NSString *result) {
        
        [self onUploadImageComplete:result];
    }];
}

-(void) onUploadImageBegan {
    self.lb_idFront.text = @"上传中……";
};

-(void) onUploadImageComplete : (NSString *) result {
    if(result){
        self.lb_idFront.text = @"上传成功";
        NSLog(@"%s || imageUploadResult:%@", __FUNCTION__, result);
        [self.lb_idFront setUserInteractionEnabled:NO];
        self.isFrontImgViewSelected = YES;
        self.string_idCardImagePath = [NSString stringWithString:result];
    }else{
        self.lb_idFront.text = @"请重新上传";
    }
};


#pragma mark - 私有方法
-(void)startTimer{
    __block int timeout=30; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.btn_getValidateCode setTitle:@"获取验证码" forState:UIControlStateNormal];
                self.btn_getValidateCode.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.btn_getValidateCode setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal];
                self.btn_getValidateCode.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
- (void)setTitleOfView{
    NSString *string_title;
    switch (self.currentRegistrationType) {
        case FYMemberRegistration:
            string_title = TEXT_MEMBER;
            break;
        case FYBrokerRegistration:
            string_title = TEXT_BROKER;
            break;
        case FYPresidentRegistration:
            string_title = TEXT_PRESIDENT;
            break;
        case FYShareholderRegistration:
            string_title = TEXT_SHAREHOLDER;
            break;
        default:
            break;
    }
    self.navigationItem.title = string_title;
}
- (BOOL)checkEmptyTextField{
    BOOL isAllFilled = YES;
    for(UITextField *textField_temp in self.array_textFeild){
        if(self.currentRegistrationType == FYMemberRegistration){
            if(textField_temp == self.txt_idNumber || textField_temp == self.txt_stockCount){
                break;
            }
        } else if(self.currentRegistrationType != FYShareholderRegistration){
            if(textField_temp == self.txt_stockCount){
                break;
            }
        }
        if(self.seg_recommendWay.selectedSegmentIndex == 0){
            if(textField_temp == self.txt_recommendCode){
                break;
            }
        }else if(self.seg_recommendWay.selectedSegmentIndex == 1){
            if(textField_temp == self.txt_recommenderName || textField_temp == self.txt_recommenderPhone){
                break;
            }
        }
//        if(textField_temp == self.txt_recommendCode){
//            if(self.seg_recommendWay.selectedSegmentIndex == 0){
//                break;
//            }
//        } else if(textField_temp == self.txt_recommenderName || textField_temp == self.txt_recommenderPhone){
//            if(self.seg_recommendWay.selectedSegmentIndex == 1){
//                break;
//            }
//        }
        if(textField_temp.text.length <= 0 || [textField_temp.text isEqualToString:@""]){
            [textField_temp becomeFirstResponder];
            isAllFilled = NO;
        }
    }
    return isAllFilled;
}
- (BOOL)checkAllClear{
//    BOOL isAllPassed = YES;
    UIAlertView *alertView_temp;
    NSString *string_mobilePhone = self.txt_phoneNumber.text;
    if(![Tool validateLengthWithString:string_mobilePhone andType:textTypePhoneNumber] || ![Tool validateMobile:string_mobilePhone]){
//        isAllPassed = NO;
        alertView_temp = [[UIAlertView alloc]initWithTitle:STRING_TITLE_ALERTVIEW message:@"请填写正确的手机号码" delegate:self cancelButtonTitle:STRING_CANCEL_ALERTVIEW otherButtonTitles:nil, nil];
        [alertView_temp show];
        [self.txt_phoneNumber becomeFirstResponder];
        return NO;
    }
    if(![Tool validateLengthWithString:self.txt_validateNumber.text andType:textTypeValidateNumber]){
        alertView_temp = [[UIAlertView alloc]initWithTitle:STRING_TITLE_ALERTVIEW message:@"请填写6位验证码" delegate:self cancelButtonTitle:STRING_CANCEL_ALERTVIEW otherButtonTitles:nil, nil];
        [alertView_temp show];
        [self.txt_validateNumber becomeFirstResponder];
        return NO;
    }
    if(![Tool validateLengthWithString:self.txt_password.text andType:textTypePassword]){
        alertView_temp = [[UIAlertView alloc]initWithTitle:STRING_TITLE_ALERTVIEW message:@"密码长度应大于4且小于18位" delegate:self cancelButtonTitle:STRING_CANCEL_ALERTVIEW otherButtonTitles:nil, nil];
        [alertView_temp show];
        [self.txt_password becomeFirstResponder];
        return NO;
    }
    if(![self.txt_password.text isEqualToString:self.txt_confirmPassword.text]){
        alertView_temp = [[UIAlertView alloc]initWithTitle:STRING_TITLE_ALERTVIEW message:@"两次输入的密码不一致" delegate:self cancelButtonTitle:STRING_CANCEL_ALERTVIEW otherButtonTitles:nil, nil];
        [alertView_temp show];
        [self.txt_confirmPassword becomeFirstResponder];
        return NO;
    }
    if(![Tool validateLengthWithString:self.txt_realname.text andType:textTypeName]){
        alertView_temp = [[UIAlertView alloc]initWithTitle:STRING_TITLE_ALERTVIEW message:@"请填写姓名" delegate:self cancelButtonTitle:STRING_CANCEL_ALERTVIEW otherButtonTitles:nil, nil];
        [alertView_temp show];
        [self.txt_realname becomeFirstResponder];
        return NO;
    }
    if([self.cityId integerValue] < 1 || [self.areaId integerValue] < 1 || [self.streesId integerValue] < 1){
        alertView_temp = [[UIAlertView alloc]initWithTitle:STRING_TITLE_ALERTVIEW message:@"请选择完整的地区" delegate:self cancelButtonTitle:STRING_CANCEL_ALERTVIEW otherButtonTitles:nil, nil];
        [alertView_temp show];
        return NO;
    }
    if(self.currentRegistrationType != FYMemberRegistration && ![Tool validateLengthWithString:self.txt_idNumber.text andType:textTypeIDNumber]){
        alertView_temp = [[UIAlertView alloc]initWithTitle:STRING_TITLE_ALERTVIEW message:@"请填写正确的身份证号码" delegate:self cancelButtonTitle:STRING_CANCEL_ALERTVIEW otherButtonTitles:nil, nil];
        [alertView_temp show];
        [self.txt_idNumber becomeFirstResponder];
        return NO;
    }
    if(self.currentRegistrationType != FYMemberRegistration && (!self.isFrontImgViewSelected)){
        UIAlertView *alertView_temp = [[UIAlertView alloc]initWithTitle:STRING_TITLE_ALERTVIEW message:@"请上传身份证照片。" delegate:self cancelButtonTitle:STRING_CANCEL_ALERTVIEW otherButtonTitles:nil, nil];
        [alertView_temp show];
        return NO;
    }
    if(self.seg_recommendWay.selectedSegmentIndex == 0){
        if(![Tool validateLengthWithString:self.txt_recommenderName.text andType:textTypeName]){
            alertView_temp = [[UIAlertView alloc]initWithTitle:STRING_TITLE_ALERTVIEW message:@"请填写推荐人名字" delegate:self cancelButtonTitle:STRING_CANCEL_ALERTVIEW otherButtonTitles:nil, nil];
            [alertView_temp show];
            [self.txt_recommenderName becomeFirstResponder];
            return NO;
        }
        if(![Tool validateLengthWithString:self.txt_recommenderPhone.text andType:textTypePhoneNumber]){
            alertView_temp = [[UIAlertView alloc]initWithTitle:STRING_TITLE_ALERTVIEW message:@"请填写正确的推荐人手机号码" delegate:self cancelButtonTitle:STRING_CANCEL_ALERTVIEW otherButtonTitles:nil, nil];
            [alertView_temp show];
            [self.txt_recommenderPhone becomeFirstResponder];
            return NO;
        }
    }else{
        if(![Tool validateLengthWithString:self.txt_recommendCode.text andType:textTypeCode]){
            alertView_temp = [[UIAlertView alloc]initWithTitle:STRING_TITLE_ALERTVIEW message:@"请填写8位的推广代码" delegate:self cancelButtonTitle:STRING_CANCEL_ALERTVIEW otherButtonTitles:nil, nil];
            [alertView_temp show];
            [self.txt_recommendCode becomeFirstResponder];
            return NO;
        }
    }
    if(self.currentRegistrationType == FYShareholderRegistration && ![Tool validateLengthWithString:self.txt_stockCount.text andType:textTypeStock]){
        alertView_temp = [[UIAlertView alloc]initWithTitle:STRING_TITLE_ALERTVIEW message:@"请输入购买的股权数" delegate:self cancelButtonTitle:STRING_CANCEL_ALERTVIEW otherButtonTitles:nil, nil];
        [alertView_temp show];
        [self.txt_stockCount becomeFirstResponder];
        return NO;
    }
//    return isAllPassed;
    return YES;
}
- (UITableViewCell *)getCellWithIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.array_cellIdentify[indexPath.row]];
    if(self.currentRegistrationType == FYMemberRegistration){
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = TEXT_PHONENUMBER;
                [cell.contentView addSubview:self.txt_phoneNumber];
                break;
            case 1:
                [cell.contentView addSubview:self.lb_note];
                break;
            case 2:
                cell.textLabel.text = TEXT_VALIDATENUMBER;
                [cell.contentView addSubview:self.txt_validateNumber];
                [cell.contentView addSubview:self.btn_getValidateCode];
                break;
            case 3:
                cell.textLabel.text = TEXT_PASSWORD;
                [cell.contentView addSubview:self.txt_password];
                break;
            case 4:
                cell.textLabel.text = TEXT_CONFIRMPASSWORD;
                [cell.contentView addSubview:self.txt_confirmPassword];
                break;
            case 5:
                cell.textLabel.text = TEXT_REALNAME;
                [cell.contentView addSubview:self.txt_realname];
                break;
            case 6:
                cell.textLabel.text = TEXT_ADDRESS;
                [cell.contentView addSubview:self.txt_address];
                break;
            case 7:
                cell.textLabel.text = TEXT_REGISTERWAY;
                [cell.contentView addSubview:self.seg_recommendWay];
                break;
            case 8:
                if(self.seg_recommendWay.selectedSegmentIndex == 0){
                    [cell.contentView addSubview:self.view_recommendBy];
                }else{
                    [cell.contentView addSubview:self.view_recommended];
                }
                break;
            case 9:
                [cell.contentView addSubview:self.imgView_checkbox];
                [cell.contentView addSubview:self.btn_agreement];
                break;
            case 10:
                [cell.contentView addSubview:self.btn_submit];
                break;
            default:
                break;
        }
    } else if(self.currentRegistrationType == FYShareholderRegistration){
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = TEXT_PHONENUMBER;
                [cell.contentView addSubview:self.txt_phoneNumber];
                break;
            case 1:
                [cell.contentView addSubview:self.lb_note];
                break;
            case 2:
                cell.textLabel.text = TEXT_VALIDATENUMBER;
                [cell.contentView addSubview:self.txt_validateNumber];
                [cell.contentView addSubview:self.btn_getValidateCode];
                break;
            case 3:
                cell.textLabel.text = TEXT_PASSWORD;
                [cell.contentView addSubview:self.txt_password];
                break;
            case 4:
                cell.textLabel.text = TEXT_CONFIRMPASSWORD;
                [cell.contentView addSubview:self.txt_confirmPassword];
                break;
            case 5:
                cell.textLabel.text = TEXT_REALNAME;
                [cell.contentView addSubview:self.txt_realname];
                break;
            case 6:
                cell.textLabel.text = TEXT_ADDRESS;
                [cell.contentView addSubview:self.txt_address];
                break;
            case 7:
                cell.textLabel.text = TEXT_IDNUMBER;
                [cell.contentView addSubview:self.txt_idNumber];
                break;
            case 8:
                cell.textLabel.text = TEXT_IDCARDIMAGE;
                [cell.contentView addSubview:self.imgView_idCardFront];
//                [cell.contentView addSubview:self.imgView_idCardBack];
                [cell.contentView addSubview:self.lb_idFront];
//                [cell.contentView addSubview:self.lb_idBack];
                break;
            case 9:
                cell.textLabel.text = TEXT_REGISTERWAY;
                [cell.contentView addSubview:self.seg_recommendWay];
                break;
            case 10:
                if(self.seg_recommendWay.selectedSegmentIndex == 0){
                    [cell.contentView addSubview:self.view_recommendBy];
                }else{
                    [cell.contentView addSubview:self.view_recommended];
                }
                break;
            case 11:
                cell.textLabel.text = TEXT_STOCKS;
                [cell.contentView addSubview:self.txt_stockCount];
                [cell.contentView addSubview:self.lb_yuan];
                break;
            case 12:
                [cell.contentView addSubview:self.imgView_checkbox];
                [cell.contentView addSubview:self.btn_agreement];
                break;
            case 13:
                [cell.contentView addSubview:self.btn_submit];
                break;
            default:
                break;
        }
    } else {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = TEXT_PHONENUMBER;
                [cell.contentView addSubview:self.txt_phoneNumber];
                break;
            case 1:
                [cell.contentView addSubview:self.lb_note];
                break;
            case 2:
                cell.textLabel.text = TEXT_VALIDATENUMBER;
                [cell.contentView addSubview:self.txt_validateNumber];
                [cell.contentView addSubview:self.btn_getValidateCode];
                break;
            case 3:
                cell.textLabel.text = TEXT_PASSWORD;
                [cell.contentView addSubview:self.txt_password];
                break;
            case 4:
                cell.textLabel.text = TEXT_CONFIRMPASSWORD;
                [cell.contentView addSubview:self.txt_confirmPassword];
                break;
            case 5:
                cell.textLabel.text = TEXT_REALNAME;
                [cell.contentView addSubview:self.txt_realname];
                break;
            case 6:
                cell.textLabel.text = TEXT_ADDRESS;
                [cell.contentView addSubview:self.txt_address];
                break;
            case 7:
                cell.textLabel.text = TEXT_IDNUMBER;
                [cell.contentView addSubview:self.txt_idNumber];
                break;
            case 8:
                cell.textLabel.text = TEXT_IDCARDIMAGE;
                [cell.contentView addSubview:self.imgView_idCardFront];
//                [cell.contentView addSubview:self.imgView_idCardBack];
                [cell.contentView addSubview:self.lb_idFront];
//                [cell.contentView addSubview:self.lb_idBack];
                break;
            case 9:
                cell.textLabel.text = TEXT_REGISTERWAY;
                [cell.contentView addSubview:self.seg_recommendWay];
                break;
            case 10:
                if(self.seg_recommendWay.selectedSegmentIndex == 0){
                    [cell.contentView addSubview:self.view_recommendBy];
                }else{
                    [cell.contentView addSubview:self.view_recommended];
                }
                break;
            case 11:
                [cell.contentView addSubview:self.imgView_checkbox];
                [cell.contentView addSubview:self.btn_agreement];
                break;
            case 12:
                [cell.contentView addSubview:self.btn_submit];
                break;
            default:
                break;
        }
    }
    return cell;
}

- (UITextField *)getTextFieldInstanceWithRect:(CGRect)rect andIsNumberOnly:(BOOL)isNumberEntry andIsPassword:(BOOL)isPassword{
    UITextField *txt_temp = [[UITextField alloc]initWithFrame:rect];
    if(isNumberEntry){
        txt_temp.keyboardType = UIKeyboardTypeNumberPad;
    }
    if(isPassword){
        txt_temp.secureTextEntry = YES;
    }
    txt_temp.returnKeyType = UIReturnKeyDone;
    txt_temp.delegate = self;
    txt_temp.clearButtonMode = UITextFieldViewModeWhileEditing;
    [txt_temp setBorderStyle:UITextBorderStyleRoundedRect];
    return txt_temp;
}

- (CGSize)getContentSizeWithContent:(NSString *)content andFont:(UIFont *)font{
    CGSize size_content = [content sizeWithAttributes:@{NSFontAttributeName:font}];
    size_content.width = size_content.width + WIDTH_EXTRA_BUTTON;
    size_content.height = size_content.height + HEIGHT_EXTRA_BUTTON;
    return size_content;
}

- (CGRect)getTextFieldDefaultFrame{
    return CGRectMake(X_ORGIN_TEXTFIELD, Y_ORGIN_TEXTFIELD, WIDTH_TEXTFIELD, HEIGHT_TEXTFIELD);
}

- (CGRect)getCenterRectWithContent:(NSString *)content andFont:(UIFont *)font{
    CGSize size_content = [self getContentSizeWithContent:content andFont:font];
    CGRect rect_content = CGRectMake((320 - size_content.width) / 2, (HEIGHT_DEFAULT_CELL - size_content.height) / 2, size_content.width, size_content.height);
    return rect_content;
}

- (UIColor *)getColorWithRGB:(int)rgb{
    return HexRGB(rgb);
}

#pragma mark - setter/getter
#pragma mark - 控件变量
- (UIView *)view_recommendBy{
    if(_view_recommendBy == nil){
        _view_recommendBy = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, HEIGHT_RECOMMENDBY_CELL)];
        [_view_recommendBy addSubview:self.lb_recommendName];
        [_view_recommendBy addSubview:self.lb_recommendPhone];
        [_view_recommendBy addSubview:self.txt_recommenderName];
        [_view_recommendBy addSubview:self.txt_recommenderPhone];
    }
    return _view_recommendBy;
}

- (UIView *)view_recommended{
    if(_view_recommended == nil){
        _view_recommended = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, HEIGHT_DEFAULT_CELL)];
        [_view_recommended addSubview:self.lb_recommendCode];
        [_view_recommended addSubview:self.txt_recommendCode];
    }
    return _view_recommended;
}

- (UITableView *)tableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        UITapGestureRecognizer *tapGesture_temp = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doResignFirstResponder)];
        [_tableView addGestureRecognizer:tapGesture_temp];
    }
    return _tableView;
}

- (UITextField *)txt_phoneNumber{
    if(_txt_phoneNumber == nil){
        _txt_phoneNumber = [self getTextFieldInstanceWithRect:[self getTextFieldDefaultFrame] andIsNumberOnly:YES andIsPassword:NO];
        _txt_phoneNumber.placeholder = @"请输入11位手机号码";
    }
    return _txt_phoneNumber;
}

- (UITextField *)txt_password{
    if(_txt_password == nil){
        _txt_password = [self getTextFieldInstanceWithRect:[self getTextFieldDefaultFrame] andIsNumberOnly:NO andIsPassword:YES];
        _txt_password.placeholder = @"请输入4-18位的密码";
    }
    return _txt_password;
}

- (UITextField *)txt_confirmPassword{
    if(_txt_confirmPassword == nil){
        _txt_confirmPassword = [self getTextFieldInstanceWithRect:[self getTextFieldDefaultFrame] andIsNumberOnly:NO andIsPassword:YES];
        _txt_confirmPassword.placeholder = @"请再次输入您的密码";
    }
    return _txt_confirmPassword;
}

- (UITextField *)txt_realname{
    if(_txt_realname == nil){
        _txt_realname = [self getTextFieldInstanceWithRect:[self getTextFieldDefaultFrame] andIsNumberOnly:NO andIsPassword:NO];
        _txt_realname.placeholder = @"请输入您的真实姓名";
    }
    return _txt_realname;
}

- (UITextField *)txt_address{
    if(_txt_address == nil){
        _txt_address = [self getTextFieldInstanceWithRect:[self getTextFieldDefaultFrame] andIsNumberOnly:NO andIsPassword:NO];
        _txt_address.placeholder = @"请输入您的所在地区";
    }
    return _txt_address;
}

- (UITextField *)txt_idNumber{
    if(_txt_idNumber == nil){
        _txt_idNumber = [self getTextFieldInstanceWithRect:[self getTextFieldDefaultFrame] andIsNumberOnly:YES andIsPassword:NO];
        _txt_idNumber.placeholder = @"请填写您的身份证号码";
    }
    return _txt_idNumber;
}

- (UITextField *)txt_recommendCode{
    if(_txt_recommendCode == nil){
        _txt_recommendCode = [self getTextFieldInstanceWithRect:[self getTextFieldDefaultFrame] andIsNumberOnly:YES andIsPassword:NO];
        _txt_recommendCode.placeholder = @"请填写8位推广代码";
    }
    return _txt_recommendCode;
}

- (UITextField *)txt_recommenderName{
    if(_txt_recommenderName == nil){
        _txt_recommenderName = [self getTextFieldInstanceWithRect:[self getTextFieldDefaultFrame] andIsNumberOnly:NO andIsPassword:NO];
        _txt_recommenderName.placeholder = @"请填写推荐人的姓名";
    }
    return _txt_recommenderName;
}

- (UITextField *)txt_recommenderPhone{
    if(_txt_recommenderPhone == nil){
        _txt_recommenderPhone = [self getTextFieldInstanceWithRect:CGRectMake(X_ORGIN_TEXTFIELD, Y_ORGIN_TEXTFIELD + HEIGHT_TEXTFIELD + GAP_NOTE * 2 + 5, WIDTH_TEXTFIELD, HEIGHT_TEXTFIELD) andIsNumberOnly:YES andIsPassword:NO];
        _txt_recommenderPhone.placeholder = @"请填写推荐人的联系电话";
    }
    return _txt_recommenderPhone;
}

- (UITextField *)txt_validateNumber{
    if(_txt_validateNumber == nil){
        _txt_validateNumber = [self getTextFieldInstanceWithRect:CGRectMake(X_ORGIN_TEXTFIELD, Y_ORGIN_TEXTFIELD, WIDTH_TEXTFIELD_VALIDATE, HEIGHT_TEXTFIELD) andIsNumberOnly:YES andIsPassword:NO];
        _txt_validateNumber.placeholder = @"请填写验证码";
    }
    return _txt_validateNumber;
}

- (UITextField *)txt_stockCount{
    if(_txt_stockCount == nil){
        _txt_stockCount = [self getTextFieldInstanceWithRect:CGRectMake(X_ORGIN_TEXTFIELD, Y_ORGIN_TEXTFIELD, WIDTH_TEXTFIELD_STOCK, HEIGHT_TEXTFIELD) andIsNumberOnly:YES andIsPassword:NO];
    }
    return _txt_stockCount;
}

- (UIImageView *)imgView_idCardFront{
    if(_imgView_idCardFront == nil){
        _imgView_idCardFront = [[UIImageView alloc]init];
        [_imgView_idCardFront setFrame:CGRectMake(X_ORIGIN_IMAGEVIEW, Y_ORIGIN_IMAGEVIEW_FRONT, WIDTH_IMAGEVIEW, WIDTH_IMAGEVIEW)];
//        _imgView_idCardFront.backgroundColor = [UIColor lightGrayColor];
        NSString *path = [[NSBundle mainBundle]pathForResource:@"uploadPhoto@2x" ofType:@"png"];
        [_imgView_idCardFront setImage:[UIImage imageWithContentsOfFile:path]];
        UITapGestureRecognizer *tapGesture_temp = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doCallActionSheet:)];
        _imgView_idCardFront.tag = 900001;
        [_imgView_idCardFront addGestureRecognizer:tapGesture_temp];
        [_imgView_idCardFront setUserInteractionEnabled:YES];
        self.isFrontImgViewSelected = NO;
    }
    return _imgView_idCardFront;
}

- (UIImageView *)imgView_idCardBack{
    if(_imgView_idCardBack == nil){
        _imgView_idCardBack = [[UIImageView alloc]init];
        [_imgView_idCardBack setFrame:CGRectMake(X_ORIGIN_IMAGEVIEW, Y_ORIGIN_IMAGEVIEW_BACK, WIDTH_IMAGEVIEW, WIDTH_IMAGEVIEW)];
//        _imgView_idCardBack.backgroundColor = [UIColor lightGrayColor];
        NSString *path = [[NSBundle mainBundle]pathForResource:@"uploadPhoto@2x" ofType:@"png"];
        [_imgView_idCardBack setImage:[UIImage imageWithContentsOfFile:path]];
        UITapGestureRecognizer *tapGesture_temp = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doCallActionSheet:)];
        _imgView_idCardBack.tag = 900002;
        [_imgView_idCardBack addGestureRecognizer:tapGesture_temp];
        [_imgView_idCardBack setUserInteractionEnabled:YES];
        self.isBackImgViewSelected = NO;
    }
    return _imgView_idCardBack;
}

- (UIImageView *)imgView_checkbox{
    if(_imgView_checkbox == nil){
        _imgView_checkbox = [[UIImageView alloc]init];
        [_imgView_checkbox setFrame:CGRectMake(self.btn_agreement.frame.origin.x + 10, self.btn_agreement.frame.origin.y + 8, 15, 15)];
        NSString *path = [[NSBundle mainBundle]pathForResource:@"agreementUnclicked@2x" ofType:@"png"];
        [_imgView_checkbox setImage:[UIImage imageWithContentsOfFile:path]];
        UITapGestureRecognizer *tapGesture_temp = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doAgreementCheck)];
        [_imgView_checkbox addGestureRecognizer:tapGesture_temp];
        [_imgView_checkbox setUserInteractionEnabled:YES];
        self.isAgreementChosen = NO;
    }
    return _imgView_checkbox;
}

- (UISegmentedControl *)seg_recommendWay{
    if(_seg_recommendWay == nil){
        _seg_recommendWay = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:TEXT_RECOMMENDBY, TEXT_RECOMMENDED, nil]];
        [_seg_recommendWay setFrame:CGRectMake(X_ORGIN_TEXTFIELD, Y_ORGIN_TEXTFIELD, WIDTH_SEGEMENT, HEIGHT_TEXTFIELD)];
        [_seg_recommendWay addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_seg_recommendWay setSelectedSegmentIndex:0];
    }
    return _seg_recommendWay;
}

- (UILabel *)lb_note{
    if(_lb_note == nil){
        _lb_note = [[UILabel alloc]init];
        _lb_note.text = TEXT_NOTE;
        [_lb_note setFrame:CGRectMake(GAP_NOTE, GAP_NOTE, 320 - GAP_NOTE * 2, HEIGHT_NOTE - GAP_NOTE * 2)];
        _lb_note.textColor = [UIColor colorWithRed:205.0 green:205.0 blue:205.0 alpha:1];
        [_lb_note setTextColor:[self getColorWithRGB:0x66ccff]];
        _lb_note.font = [UIFont systemFontOfSize:SIZE_FONT_TEXT_NOTE];
        _lb_note.lineBreakMode = NSLineBreakByCharWrapping;
        _lb_note.numberOfLines = 0;
    }
    return _lb_note;
}

- (UILabel *)lb_idFront{
    if(_lb_idFront == nil){
        _lb_idFront = [[UILabel alloc]init];
        _lb_idFront.text = TEXT_IDCARDFRONT;
        [_lb_idFront setFrame:CGRectMake(X_ORIGIN_IMAGEVIEW + WIDTH_IMAGEVIEW + GAP_NOTE * 2 + 10, 35, 120, HEIGHT_TEXTFIELD)];
        _lb_idFront.textColor = [UIColor redColor];
        _lb_idFront.font = [UIFont systemFontOfSize:13.0];
        
        UITapGestureRecognizer *tapGestureRecognizer_temp = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onUploadImageButtonTouchedUpInside:)];
        [_lb_idFront addGestureRecognizer:tapGestureRecognizer_temp];
        
        [_lb_idFront setUserInteractionEnabled:YES];
    }
    return _lb_idFront;
}

- (UILabel *)lb_idBack{
    if(_lb_idBack == nil){
        _lb_idBack = [[UILabel alloc]init];
        _lb_idBack.text = TEXT_IDCARDBACK;
        [_lb_idBack setFrame:CGRectMake(X_ORIGIN_IMAGEVIEW + WIDTH_IMAGEVIEW + GAP_NOTE * 2, HEIGHT_IDCARD_CELL / 2 + HEIGHT_TEXTFIELD, 100, HEIGHT_TEXTFIELD)];
        _lb_idBack.textColor = [UIColor redColor];
        _lb_idBack.font = [UIFont systemFontOfSize:13.0];
    }
    return _lb_idBack;
}

- (UILabel *)lb_recommendName{
    if(_lb_recommendName == nil){
        _lb_recommendName = [[UILabel alloc]init];
        _lb_recommendName.text = TEXT_RECOMMENDERNAME;
        [_lb_recommendName setFrame:CGRectMake(15, 10, 120, 30)];
    }
    return _lb_recommendName;
}

- (UILabel *)lb_recommendPhone{
    if(_lb_recommendPhone == nil){
        _lb_recommendPhone = [[UILabel alloc]init];
        _lb_recommendPhone.text = TEXT_RECOMMENDERPHONE;
        [_lb_recommendPhone setFrame:CGRectMake(15, 50, 120, 30)];
    }
    return _lb_recommendPhone;
}

- (UILabel *)lb_recommendCode{
    if(_lb_recommendCode == nil){
        _lb_recommendCode = [[UILabel alloc]init];
        _lb_recommendCode.text = TEXT_RECOMMENDCODE;
        [_lb_recommendCode setFrame:CGRectMake(15, 10, 120, 30)];
    }
    return _lb_recommendCode;
}

- (UILabel *)lb_yuan{
    if(_lb_yuan == nil){
        _lb_yuan = [[UILabel alloc]init];
        _lb_yuan.text = TEXT_YUAN;
        [_lb_yuan setFrame:CGRectMake(X_ORGIN_TEXTFIELD + WIDTH_TEXTFIELD_STOCK + GAP_NOTE * 2, Y_ORGIN_TEXTFIELD, 40, HEIGHT_TEXTFIELD)];
    }
    return _lb_yuan;
}

- (UIButton *)btn_getValidateCode{
    if(_btn_getValidateCode == nil){
        _btn_getValidateCode = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_btn_getValidateCode setTitle:TEXT_GETVADALITE forState:UIControlStateNormal];
        _btn_getValidateCode.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_btn_getValidateCode setFrame:CGRectMake(X_ORGIN_TEXTFIELD + WIDTH_TEXTFIELD_VALIDATE , Y_ORGIN_TEXTFIELD, WIDTH_IMAGEVIEW, HEIGHT_TEXTFIELD)];
        [_btn_getValidateCode setTitleColor:[self getColorWithRGB:0x66ccff] forState:UIControlStateNormal];
        _btn_getValidateCode.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_btn_getValidateCode addTarget:self action:@selector(doGetValidateCode:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn_getValidateCode;
}

- (UIButton *)btn_agreement{
    if(_btn_agreement == nil){
        _btn_agreement = [[UIButton alloc]init];
        [_btn_agreement setTitle:TEXT_AGREEMENT forState:UIControlStateNormal];
        _btn_agreement.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_btn_agreement setFrame:[self getCenterRectWithContent:TEXT_AGREEMENT andFont:_btn_agreement.titleLabel.font]];
        [_btn_agreement setTitleColor:[self getColorWithRGB:0x66ccff] forState:UIControlStateNormal];
        _btn_agreement.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_btn_agreement addTarget:self action:@selector(doAgreementCheck) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn_agreement;
}

- (UIButton *)btn_submit{
    if(_btn_submit == nil){
        _btn_submit = [[UIButton alloc]init];
        [_btn_submit setTitle:TEXT_SUBMIT forState:UIControlStateNormal];
        [_btn_submit setFrame:[self getCenterRectWithContent:TEXT_SUBMIT andFont:_btn_submit.titleLabel.font]];
        _btn_submit.backgroundColor = [self getColorWithRGB:0x66ccff];
        _btn_submit.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_btn_submit setUserInteractionEnabled:YES];
        [_btn_submit addTarget:self action:@selector(doSubmitRegistration) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn_submit;
}

#pragma mark - 成员变量
- (NSArray *)array_textFeild{
    if(_array_textFeild == nil){
        _array_textFeild = [NSArray arrayWithObjects:self.txt_phoneNumber, self.txt_validateNumber, self.txt_password, self.txt_confirmPassword, self.txt_realname, self.txt_address, self.txt_idNumber, self.txt_recommenderName, self.txt_recommenderPhone, self.txt_recommendCode, self.txt_stockCount, nil];
    }
    return _array_textFeild;
}
- (NSArray *)array_cellIdentify{
    if(_array_cellIdentify == nil){
        NSMutableArray *array_temp = [NSMutableArray arrayWithObjects:@"phoneNumber", @"note", @"validate", @"password", @"confirmPassword", @"realname", @"address", @"registType", @"recommend", @"agreement", @"submit", nil];
        switch (self.currentRegistrationType) {
            case FYShareholderRegistration:
                [array_temp insertObject:@"stock" atIndex:9];
            case FYBrokerRegistration:
            case FYPresidentRegistration:
                [array_temp insertObject:@"idNumber" atIndex:7];
                [array_temp insertObject:@"idFront" atIndex:8];
                [array_temp insertObject:@"idBack" atIndex:9];
                break;
            default:
                break;
        }
        _array_cellIdentify = [NSArray arrayWithArray:array_temp];
    }
    return _array_cellIdentify;
}

@end

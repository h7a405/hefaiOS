//
//  PromotionHandlerViewController.m
//  HouseBank
//
//  Created by SilversRayleigh on 8/6/15.
//  Copyright (c) 2015年 QCloud. All rights reserved.
//

#import "PromotionHandlerViewController.h"
#import "Tool.h"

static NSInteger const COUNT_SECTION = 1;
static NSInteger const COUNT_ROW_SECTION = 6;
static CGFloat const DEFAULT_HEIGHT_ROW = 44.0;
static CGFloat const HEIGHT_ROW_RECOMMENDBY = 92.0;
static CGFloat const HEIGHT_ROW_IMG_IDCARD = 200.0;
static CGFloat const X_DEFAULT = 111.0;
static CGFloat const Y_DEFAULT = 7.0;
static CGFloat const WIDTH_DEFAULT = 190;
static CGFloat const HEIGHT_DEFAULT = 30;
static CGFloat const WIDTH_TEXTFIELD_STOCK = 100;
static CGFloat const WIDTH_IMAGEVIEW = 80;
static CGFloat const X_IMAGEVIEW = 120;
static CGFloat const Y_IMAGEVIEW_FRONT = 15;
static CGFloat const Y_IMAGEVIEW_BACK = Y_IMAGEVIEW_FRONT * 2 + WIDTH_IMAGEVIEW;
static CGFloat const WIDTH_SEGMENTCONTROL = 150;
static CGFloat const HEIGHT_BUTTON_EXTRA = 15;
static CGFloat const WIDTH_BUTTON_EXTRA = 40;
static CGFloat const GAP_DEFAULT = 5;

static NSString * const STRING_TITLE_ALERTVIEW = @"合发房银提醒您：";
static NSString * const STRING_CANCEL_ALERTVIEW = @"确定";


@interface PromotionHandlerViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIView *view_recommendBy;
@property (strong, nonatomic) UIView *view_recommended;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UITextField *txt_idNumber;
@property (strong, nonatomic) UITextField *txt_recommenderName;
@property (strong, nonatomic) UITextField *txt_recommenderPhone;
@property (strong, nonatomic) UITextField *txt_recommendCode;
@property (strong, nonatomic) UITextField *txt_stockCount;
@property (strong, nonatomic) UIImageView *imgView_idCardFront;
@property (strong, nonatomic) UIImageView *imgView_idCardBack;
@property (strong, nonatomic) UISegmentedControl *seg_recommendWay;
@property (strong, nonatomic) UILabel *lb_idNumber;
@property (strong, nonatomic) UILabel *lb_idCard;
@property (strong, nonatomic) UILabel *lb_idFront;
@property (strong, nonatomic) UILabel *lb_idBack;
@property (strong, nonatomic) UILabel *lb_recommendName;
@property (strong, nonatomic) UILabel *lb_recommendPhone;
@property (strong, nonatomic) UILabel *lb_recommendCode;
@property (strong, nonatomic) UILabel *lb_yuan;
@property (strong, nonatomic) UIButton *btn_submit;
@property (strong, nonatomic) UIButton *btn_cancel;

@property (strong, nonatomic) NSArray *array_textFeild;
@property (assign, nonatomic) BOOL isFrontImgViewClicked;
@property (assign, nonatomic) BOOL isFrontImgViewSelected;
@property (assign, nonatomic) BOOL isBackImgViewSelected;

@end

@implementation PromotionHandlerViewController

#pragma mark - life
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
    
    self.navigationItem.title = @"升级资料";
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
    if(indexPath.row == 1){
        return HEIGHT_ROW_IMG_IDCARD;
    } else if(indexPath.row == 3){
        if(self.seg_recommendWay.selectedSegmentIndex == 0){
            return HEIGHT_ROW_RECOMMENDBY;
        }
        else return DEFAULT_HEIGHT_ROW;
    } else{
        return DEFAULT_HEIGHT_ROW;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell%d", indexPath.row]];
    if(cell == nil){
        cell = [self getCellWithIndexPath:indexPath];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if([string isEqualToString:@"\n"]){
        [textField resignFirstResponder];
        return NO;
    } else if (string.length == 0){
        return YES;
    }
    if (self.txt_recommendCode == textField){
        if(textField.text.length >= 8){
            return NO;
        }
    } else if (self.txt_idNumber == textField){
        if(textField.text.length >= 18){
            return NO;
        }
    } else if (self.txt_recommenderPhone == textField){
        if(textField.text.length >= 11){
            return NO;
        }
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if(self.txt_recommendCode == textField || self.txt_recommenderName == textField || self.txt_recommenderPhone == textField || self.txt_stockCount == textField){
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
        self.isFrontImgViewSelected = YES;
    }else{
        self.imgView_idCardBack.image = image;
        self.isBackImgViewSelected = YES;
    }
}

#pragma mark - 事件响应
- (void)segmentValueChanged:(id)sender{
    NSUInteger index = 3;
    NSIndexPath * indexPath =  [NSIndexPath indexPathForRow:index inSection:0];
    NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    [self doResignFirstResponder];
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

- (void)doCancel{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)doSubmit{
    if([self checkAllClear]){
        
    }
}

#pragma mark - private
- (BOOL)checkEmptyTextField{
    BOOL isAllFilled = YES;
    for(UITextField *textField_temp in self.array_textFeild){
        if(textField_temp == self.txt_recommendCode){
            if(self.seg_recommendWay.selectedSegmentIndex == 0){
                break;
            }
        } else if(textField_temp == self.txt_recommenderName || textField_temp == self.txt_recommenderPhone){
            if(self.seg_recommendWay.selectedSegmentIndex == 1){
                break;
            }
        }
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
    if(![Tool validateLengthWithString:self.txt_idNumber.text andType:textTypeIDNumber]){
        alertView_temp = [[UIAlertView alloc]initWithTitle:STRING_TITLE_ALERTVIEW message:@"请填写正确的身份证号码" delegate:self cancelButtonTitle:STRING_CANCEL_ALERTVIEW otherButtonTitles:nil, nil];
        [alertView_temp show];
        [self.txt_idNumber becomeFirstResponder];
        return NO;
    }
    if(!self.isFrontImgViewSelected || !self.isBackImgViewSelected){
        alertView_temp = [[UIAlertView alloc]initWithTitle:@"合发房银提醒您：" message:@"请上传身份证照片。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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
    if(![Tool validateLengthWithString:self.txt_stockCount.text andType:textTypeStock]){
        alertView_temp = [[UIAlertView alloc]initWithTitle:STRING_TITLE_ALERTVIEW message:@"请输入购买的股权数" delegate:self cancelButtonTitle:STRING_CANCEL_ALERTVIEW otherButtonTitles:nil, nil];
        [alertView_temp show];
        [self.txt_stockCount becomeFirstResponder];
        return NO;
    }
    //    return isAllPassed;
    return YES;
}

- (UITableViewCell *)getCellWithIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"cell%d", indexPath.row]];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"身份证号码：";
            [cell.contentView addSubview:self.txt_idNumber];
            break;
        case 1:
            cell.textLabel.text = @"身份证照片：";
            [cell.contentView addSubview:self.imgView_idCardFront];
            [cell.contentView addSubview:self.imgView_idCardBack];
            [cell.contentView addSubview:self.lb_idFront];
            [cell.contentView addSubview:self.lb_idBack];
            break;
        case 2:
            cell.textLabel.text = @"推荐方式：";
            [cell.contentView addSubview:self.seg_recommendWay];
            break;
        case 3:
            if(self.seg_recommendWay.selectedSegmentIndex == 0){
                [cell.contentView addSubview:self.view_recommendBy];
            }else{
                [cell.contentView addSubview:self.view_recommended];
            }
            break;
        case 4:
            cell.textLabel.text = @"购买股权：";
            [cell.contentView addSubview:self.txt_stockCount];
            [cell.contentView addSubview:self.lb_yuan];
            break;
        case 5:
            [cell.contentView addSubview:self.btn_submit];
            [cell.contentView addSubview:self.btn_cancel];
        default:
            break;
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
    size_content.width = size_content.width + WIDTH_BUTTON_EXTRA;
    size_content.height = size_content.height + HEIGHT_BUTTON_EXTRA;
    return size_content;
}

- (CGRect)getTextFieldDefaultFrame{
    return CGRectMake(X_DEFAULT, Y_DEFAULT, WIDTH_DEFAULT, HEIGHT_DEFAULT);
}

- (CGRect)getCenterRectWithContent:(NSString *)content andFont:(UIFont *)font{
    CGSize size_content = [self getContentSizeWithContent:content andFont:font];
    CGRect rect_content = CGRectMake((320 - size_content.width) / 2, (DEFAULT_HEIGHT_ROW - size_content.height) / 2, size_content.width, size_content.height);
    return rect_content;
}
#pragma mark - getter / setter
- (UIView *)view_recommendBy{
    if(_view_recommendBy == nil){
        _view_recommendBy = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, HEIGHT_ROW_RECOMMENDBY)];
        [_view_recommendBy addSubview:self.lb_recommendName];
        [_view_recommendBy addSubview:self.lb_recommendPhone];
        [_view_recommendBy addSubview:self.txt_recommenderName];
        [_view_recommendBy addSubview:self.txt_recommenderPhone];
    }
    return _view_recommendBy;
}

- (UIView *)view_recommended{
    if(_view_recommended == nil){
        _view_recommended = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, HEIGHT_DEFAULT)];
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
- (UITextField *)txt_idNumber{
    if(_txt_idNumber == nil){
        _txt_idNumber = [self getTextFieldInstanceWithRect:[self getTextFieldDefaultFrame] andIsNumberOnly:YES andIsPassword:NO];
    }
    return _txt_idNumber;
}

- (UITextField *)txt_recommendCode{
    if(_txt_recommendCode == nil){
        _txt_recommendCode = [self getTextFieldInstanceWithRect:[self getTextFieldDefaultFrame] andIsNumberOnly:YES andIsPassword:NO];
    }
    return _txt_recommendCode;
}

- (UITextField *)txt_recommenderName{
    if(_txt_recommenderName == nil){
        _txt_recommenderName = [self getTextFieldInstanceWithRect:[self getTextFieldDefaultFrame] andIsNumberOnly:NO andIsPassword:NO];
    }
    return _txt_recommenderName;
}

- (UITextField *)txt_recommenderPhone{
    if(_txt_recommenderPhone == nil){
        _txt_recommenderPhone = [self getTextFieldInstanceWithRect:CGRectMake(X_DEFAULT, Y_DEFAULT + HEIGHT_DEFAULT + GAP_DEFAULT * 2 + 5, WIDTH_DEFAULT, HEIGHT_DEFAULT) andIsNumberOnly:YES andIsPassword:NO];
    }
    return _txt_recommenderPhone;
}
- (UITextField *)txt_stockCount{
    if(_txt_stockCount == nil){
        _txt_stockCount = [self getTextFieldInstanceWithRect:CGRectMake(X_DEFAULT, Y_DEFAULT, WIDTH_TEXTFIELD_STOCK, HEIGHT_DEFAULT) andIsNumberOnly:YES andIsPassword:NO];
    }
    return _txt_stockCount;
}

- (UIImageView *)imgView_idCardFront{
    if(_imgView_idCardFront == nil){
        _imgView_idCardFront = [[UIImageView alloc]init];
        [_imgView_idCardFront setFrame:CGRectMake(X_IMAGEVIEW, Y_IMAGEVIEW_FRONT, WIDTH_IMAGEVIEW, WIDTH_IMAGEVIEW)];
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
        [_imgView_idCardBack setFrame:CGRectMake(X_IMAGEVIEW, Y_IMAGEVIEW_BACK, WIDTH_IMAGEVIEW, WIDTH_IMAGEVIEW)];
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

- (UISegmentedControl *)seg_recommendWay{
    if(_seg_recommendWay == nil){
        _seg_recommendWay = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"推荐人", @"推广代码", nil]];
        [_seg_recommendWay setFrame:CGRectMake(X_DEFAULT, Y_DEFAULT, WIDTH_SEGMENTCONTROL, HEIGHT_DEFAULT)];
        [_seg_recommendWay addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_seg_recommendWay setSelectedSegmentIndex:0];
    }
    return _seg_recommendWay;
}
- (UILabel *)lb_idFront{
    if(_lb_idFront == nil){
        _lb_idFront = [[UILabel alloc]init];
        _lb_idFront.text = @"（正面）";
        [_lb_idFront setFrame:CGRectMake(X_IMAGEVIEW + WIDTH_IMAGEVIEW + GAP_DEFAULT * 2, HEIGHT_ROW_IMG_IDCARD / 4 - HEIGHT_DEFAULT / 2, 100, HEIGHT_DEFAULT)];
        _lb_idFront.textColor = [UIColor redColor];
        _lb_idFront.font = [UIFont systemFontOfSize:13.0];
    }
    return _lb_idFront;
}

- (UILabel *)lb_idBack{
    if(_lb_idBack == nil){
        _lb_idBack = [[UILabel alloc]init];
        _lb_idBack.text = @"（反面）";
        [_lb_idBack setFrame:CGRectMake(X_IMAGEVIEW + WIDTH_IMAGEVIEW + GAP_DEFAULT * 2, HEIGHT_ROW_IMG_IDCARD / 2 + HEIGHT_DEFAULT, 100, HEIGHT_DEFAULT)];
        _lb_idBack.textColor = [UIColor redColor];
        _lb_idBack.font = [UIFont systemFontOfSize:13.0];
    }
    return _lb_idBack;
}

- (UILabel *)lb_recommendName{
    if(_lb_recommendName == nil){
        _lb_recommendName = [[UILabel alloc]init];
        _lb_recommendName.text = @"分销推荐人：";
        [_lb_recommendName setFrame:CGRectMake(15, 10, 120, 30)];
    }
    return _lb_recommendName;
}

- (UILabel *)lb_recommendPhone{
    if(_lb_recommendPhone == nil){
        _lb_recommendPhone = [[UILabel alloc]init];
        _lb_recommendPhone.text = @"推荐人手机：";
        [_lb_recommendPhone setFrame:CGRectMake(15, 50, 120, 30)];
    }
    return _lb_recommendPhone;
}

- (UILabel *)lb_recommendCode{
    if(_lb_recommendCode == nil){
        _lb_recommendCode = [[UILabel alloc]init];
        _lb_recommendCode.text = @"推广代码：";
        [_lb_recommendCode setFrame:CGRectMake(15, 10, 120, 30)];
    }
    return _lb_recommendCode;
}

- (UILabel *)lb_yuan{
    if(_lb_yuan == nil){
        _lb_yuan = [[UILabel alloc]init];
        _lb_yuan.text = @"元";
        [_lb_yuan setFrame:CGRectMake(X_DEFAULT + WIDTH_TEXTFIELD_STOCK + GAP_DEFAULT * 2, Y_DEFAULT, 40, HEIGHT_DEFAULT)];
    }
    return _lb_yuan;
}
- (UIButton *)btn_submit{
    if(_btn_submit == nil){
        _btn_submit = [[UIButton alloc]init];
        [_btn_submit setTitle:@"提交" forState:UIControlStateNormal];
        [_btn_submit setFrame:CGRectMake(320 / 2 - WIDTH_IMAGEVIEW - 20, Y_DEFAULT, WIDTH_IMAGEVIEW, HEIGHT_DEFAULT)];
        _btn_submit.backgroundColor = [UIColor brownColor];
        _btn_submit.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_btn_submit addTarget:self action:@selector(doSubmit) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn_submit;
}
- (UIButton *)btn_cancel{
    if(_btn_cancel == nil){
        _btn_cancel = [[UIButton alloc]init];
        [_btn_cancel setTitle:@"取消" forState:UIControlStateNormal];
        [_btn_cancel setFrame:CGRectMake(320 - WIDTH_IMAGEVIEW - 80, Y_DEFAULT, WIDTH_IMAGEVIEW, HEIGHT_DEFAULT)];
        _btn_cancel.backgroundColor = [UIColor grayColor];
        _btn_cancel.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_btn_cancel addTarget:self action:@selector(doCancel) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn_cancel;
}

- (NSArray *)array_textFeild{
    if(_array_textFeild == nil){
        _array_textFeild = [NSArray arrayWithObjects:self.txt_idNumber, self.txt_recommenderName, self.txt_recommenderPhone, self.txt_recommendCode, self.txt_stockCount, nil];
    }
    return _array_textFeild;
}

@end

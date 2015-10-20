//
//  ContactInfoViewController.m
//  HouseBank
//
//  Created by CSC on 15/1/4.
//  Copyright (c) 2015年 QCloud. All rights reserved.
//

#import "ContactInfoViewController.h"
#import "FYUserDao.h"
#import "AddressBookWsImpl.h"
#import "MBProgressHUD+Add.h"
#import "Constants.h"
#import "AddNewContactViewController.h"

@interface ContactInfoViewController ()<AddContactDelegate>{
    NSDictionary *_contactInfo ;
}
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *mobile;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *source;
@property (weak, nonatomic) IBOutlet UILabel *level;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *industry;
@property (weak, nonatomic) IBOutlet UILabel *company;
@property (weak, nonatomic) IBOutlet UILabel *qq;
@property (weak, nonatomic) IBOutlet UILabel *position;
@property (weak, nonatomic) IBOutlet UILabel *weixin;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *memo;

- (void) initialize ;
- (void) initializeParams ;
- (IBAction)phone:(id)sender ;
- (IBAction)sms:(id)sender ;


@end

@implementation ContactInfoViewController

@synthesize contact = _contact ;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialize] ;
    [self initializeParams] ;
}

-(void) initialize{
    NSString *name = _contact[@"name"] ;
    self.navigationItem.title = name ;
    
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(rightBarBtn)];
    self.navigationItem.rightBarButtonItem = barBtn;
}

-(void) initializeParams{
    //    contactId = 159512;
    //    importantLevel = 1;
    //    mobilephone1 = "555-522-8243";
    //    name = AnnaAnna;
    
    MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AddressBookWsImpl *ws = [AddressBookWsImpl new];
    [ws requestContactInfo:_contact[@"contactId"] result:^(BOOL isSuccess, id result, NSString *data) {
        [mbp hide:YES];
        
        if (result && result != [NSNull null]) {
            _name.text = [TextUtil replaceNull:result[@"name"]];
            _nickName.text = [TextUtil replaceNull:result[@"nickname"]];
            _mobile.text = [TextUtil replaceNull:result[@"mobilephone1"]];
            _phone.text = [TextUtil replaceNull:result[@"telphone1"]];
            
            NSArray *sourceArray = ContactSource;
            if ([result[@"sourceId"] integerValue] < sourceArray.count) {
                _source.text = sourceArray[[result[@"sourceId"] integerValue]];
            }
            
            NSArray *levelArray = LevelStrs;
            if ([result[@"importantLevel"] integerValue]-1 < levelArray.count) {
                _level.text = levelArray[[result[@"importantLevel"] integerValue]-1];
            }
            
            NSArray *typeArray = ContactType;
            if ([result[@"linkType"] integerValue] < typeArray.count) {
                _type.text = typeArray[[result[@"linkType"] integerValue]];
            }
            
            _industry.text = [TextUtil replaceNull:result[@"industry"]];
            _company.text = [TextUtil replaceNull:result[@"company"]];
            _position.text = [TextUtil replaceNull:result[@"position"]];
            _qq.text = [TextUtil replaceNull:result[@"qq"]];
            _email.text = [TextUtil replaceNull:result[@"email"]];
            _weixin.text = [TextUtil replaceNull:result[@"weixin"]];
            _address.text = result[@"address"]==[NSNull null] ? @"":result[@"address"];
            _memo.text = [TextUtil replaceNull:result[@"memo"]];
            
            _contactInfo = result;
        }else{
            self.navigationItem.rightBarButtonItem = nil;
        }
    }];
}

-(void) rightBarBtn {
    AddNewContactViewController *vc = [AddNewContactViewController new];
    vc.isUpdate = YES;
    vc.contact = _contactInfo;
    vc.contactId = _contact[@"contactId"];
    vc.delegation = self;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)phone:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_contactInfo[@"mobilephone1"]]]];
}

- (IBAction)sms:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",_contactInfo[@"mobilephone1"]]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) finish{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) finishUpdate{
    [self performSelector:@selector(finish) withObject:nil afterDelay:0.8];
}

@end

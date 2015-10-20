//
//  IncomeAndExpenditureDetailViewController.h
//  HouseBank
//
//  Created by SilversRayleigh on 3/7/15.
//  Copyright (c) 2015年 QCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

#define INCOME @"moneyIn"
#define EXPENDITURE @"moneyOut"

#define LISTCOUNT @"totalSize"
#define DETAILREPORTLIST @"inOuts"
#define INCOMEREPORTLIST @"ins"
#define WITHDRAWREPORTLIST @"outs"

#define DETAILREPORTREMARK @"moneyType"
#define DETAILREPORTBALANCE @"restMoney"
#define DETAILREPORTDATE @"createDatetime"
#define DETAILREPORTAMOUNT @"moneyInOut"

#define INCOMEREPORTDATE @"createDatetime"
#define INCOMEREPORTTYPE @"contrType"
#define INCOMEREPORTSOURCE @"gainerLevel"
#define INCOMEREPORTINCOME @"gainMoney"
#define INCOMEREPORTAMOUT @"contrMoney"

#define WITHDRAWREPORTDATE @"createDatetime"
#define WITHDRAWREPORTAMOUNT @"drawMoney"
#define WITHDRAWREPORTFEE @"drawHand"
#define WITHDRAWREPORTSTATUS @"status"
#define WITHDRAWREPORTMONEY @"inAccount"

#define WITHDRAW @"drawMoney"
#define FEE @"drawHand"

typedef NS_ENUM(NSInteger, DetailSelection) {
    DETAILREPORT = 800001,
    INCOMEREPORT = 800002,
    WITHDRAWREPORT = 800003
};

@interface IncomeAndExpenditureDetailViewController : UIViewController

@end

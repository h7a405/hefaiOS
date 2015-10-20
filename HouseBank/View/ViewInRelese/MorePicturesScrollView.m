//
//  MorePicturesScrollView.m
//  HouseBank
//
//  Created by CSC on 15/1/22.
//  Copyright (c) 2015年 QCloud. All rights reserved.
//

#import "MorePicturesScrollView.h"

#define ScrollHeight 65.0

@interface MorePicturesScrollView ()<UIImagePickerControllerDelegate>{
    NSMutableArray *_array;
}

-(void) initialized ;
-(void) addBtnTapped ;

@end

@implementation MorePicturesScrollView

@synthesize delegation = _delegation;

-(id) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:rect(frame.origin.x, frame.origin.y, frame.size.width, ScrollHeight)]) {
        [self initialized];
    }
    return self;
}

-(void) initialized{
    float addButtonHeight = ScrollHeight ;
    UIButton *addBtn = [[UIButton alloc] initWithFrame:rect(10, 0, addButtonHeight, addButtonHeight)];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"btn_image_add"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addBtn];
}

-(void) addBtnTapped{
    if ([_delegation respondsToSelector:@selector(onAddBtnTapped:)]) {
        [_delegation onAddBtnTapped:self];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0){
};

-(void) addImage:(UIImage *)image{
    if (image) {
        if (!_array) {
            _array = [NSMutableArray new];
        }
        
        int _imageCount = _array.count + 1;
        
        float space = 5;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect(15 +ScrollHeight*_imageCount, space/2, ScrollHeight - space, ScrollHeight - space)];
        imageView.image = image;
        [self addSubview:imageView];
        [_array addObject:image];
        
        self.contentSize = CGSizeMake(10 + ScrollHeight *(_imageCount + 1), ScrollHeight);
    }
}

-(NSArray *) images{
    return _array;
}

- (void)dealloc{
    _array = nil;
}

@end

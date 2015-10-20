//
//  HouseMapViewController.m
//  HouseBank
//
//  Created by 植梧培 on 14-9-20.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "HouseMapViewController.h"

@interface HouseMapViewController ()<BMKMapViewDelegate>{
    BMKMapView *_mapView;
}
@end

@implementation HouseMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"房源详情";
    _mapView=[[BMKMapView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_mapView];
    _mapView.centerCoordinate=_location;
    _mapView.zoomLevel=19;
    _mapView.mapType=BMKMapTypeTrafficOn;
    BMKPointAnnotation*    pointAnnotation = [[BMKPointAnnotation alloc]init];
    
    pointAnnotation.coordinate = _location;
    [_mapView addAnnotation:pointAnnotation];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate=self;
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate=nil;
    [super viewWillDisappear:animated];
}

@end

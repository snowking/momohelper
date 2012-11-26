//
//  MMFindViewController.h
//  MomoHelper
//
//  Created by King on 12-11-14.
//  Copyright (c) 2012年 King. All rights reserved.
//

#import "NKViewController.h"
#import <MapKit/MapKit.h>

@interface MMFindViewController : NKViewController{
    
    MKMapView *map;
    
    
    UITextField *distanceField;
    
}

@property (nonatomic, assign) MKMapView *map;

@property (nonatomic, assign) UITextField *distanceField;

@end

//
//  MMFindViewController.h
//  MomoHelper
//
//  Created by King on 12-11-14.
//  Copyright (c) 2012年 King. All rights reserved.
//

#import "NKViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MMFindViewController : NKViewController <MKMapViewDelegate, CLLocationManagerDelegate>{
    
    MKMapView *map;
    
    
    UITextField *distanceField;
    BOOL regioned;
    
}

@property (nonatomic, assign) MKMapView *map;
@property (nonatomic, assign) UITextField *distanceField;

- (IBAction)addRegionWithDistance:(double)distance;

@end

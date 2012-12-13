//
//  MMFindViewController.m
//  MomoHelper
//
//  Created by King on 12-11-14.
//  Copyright (c) 2012年 King. All rights reserved.
//

#import "MMFindViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "RegionAnnotation.h"
#import "RegionAnnotationView.h"

@interface MMFindViewController ()

@end

@implementation MMFindViewController

@synthesize map;
@synthesize distanceField;


-(void)dealloc{

    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.titleLabel.text = @"寻Ta";
    
    [self addRightButtonWithTitle:@"历史"];
    [self addleftButtonWithTitle:@"重置"];
    
    
    
    
    self.distanceField = [[[UITextField alloc] initWithFrame:CGRectMake(0, 44, 280, 40)] autorelease];
    [self.contentView addSubview:distanceField];
    distanceField.backgroundColor = [UIColor lightGrayColor];
    
    NKNumberPad *numberPad = [NKNumberPad numberPadForTextField:distanceField];
    numberPad.target = self;
    numberPad.okAction = @selector(numberPadOK:);
    
    distanceField.inputView = numberPad;
    distanceField.font = [UIFont systemFontOfSize:16];
    distanceField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    distanceField.textAlignment = UITextAlignmentRight;
    distanceField.layer.borderWidth = 1.0;
    
    UILabel *km = [[UILabel alloc] initWithFrame:CGRectMake(279, 44, 41, 40)];
    km.text = @"km";
    km.backgroundColor = distanceField.backgroundColor;
    [self.contentView addSubview:km];
    km.layer.borderWidth = 1.0;
    km.textAlignment = UITextAlignmentCenter;
    [km release];
    
    
    self.map = [[[MKMapView alloc] initWithFrame:CGRectMake(0, 83, 320, NKContentHeight-83)] autorelease];
    [self.contentView addSubview:map];
    map.showsUserLocation = YES;
    map.layer.borderWidth = 1.0;
    map.delegate = self;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)leftButtonClick:(id)sender{
    
    
    
    
    
}


#pragma mark -
#pragma mark Notifications

- (void)keyboardWillShow:(NSNotification *)note{
    
    
    if (![distanceField isFirstResponder]) {
        return;
    }
    
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    CGRect frame = map.frame;
    frame.size.height = NKMainHeight - (keyboardBounds.size.height + frame.origin.y);

    
    [UIView animateWithDuration:[duration doubleValue] delay:0 options:UIViewAnimationOptionBeginFromCurrentState|[curve intValue] animations:^{
        map.frame = frame;
        
    } completion:^(BOOL finished) {
        
    }];
    
    
}

- (void)keyboardWillHide:(NSNotification *)note{

    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    CGRect frame = map.frame;
    frame.size.height = NKContentHeight-frame.origin.y;
    
    
    [UIView animateWithDuration:[duration doubleValue] delay:0 options:UIViewAnimationOptionBeginFromCurrentState|[curve intValue] animations:^{
        map.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
    
}

#pragma mark numberPad
-(void)numberPadOK:(id)sender{
    
    NSLog(@"%@", [NSNumber numberWithDouble:[distanceField.text doubleValue]]);
    
    [self addRegionWithDistance:[distanceField.text doubleValue]*1000];
}



#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	if([annotation isKindOfClass:[RegionAnnotation class]]) {
		RegionAnnotation *currentAnnotation = (RegionAnnotation *)annotation;
		NSString *annotationIdentifier = [currentAnnotation title];
		RegionAnnotationView *regionView = (RegionAnnotationView *)[map dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
		
		if (!regionView) {
			regionView = [[[RegionAnnotationView alloc] initWithAnnotation:annotation] autorelease];
			regionView.map = map;
			
			// Create a button for the left callout accessory view of each annotation to remove the annotation and region being monitored.
			UIButton *removeRegionButton = [UIButton buttonWithType:UIButtonTypeCustom];
			[removeRegionButton setFrame:CGRectMake(0., 0., 25., 25.)];
			[removeRegionButton setImage:[UIImage imageNamed:@"RemoveRegion"] forState:UIControlStateNormal];
			
			regionView.leftCalloutAccessoryView = removeRegionButton;
		} else {
			regionView.annotation = annotation;
			regionView.theAnnotation = annotation;
		}
		
		// Update or add the overlay displaying the radius of the region around the annotation.
		[regionView updateRadiusOverlay];
		
		return regionView;
	}
	
	return nil;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    if (!regioned) {
        
        regioned = YES;
        MKCoordinateRegion location = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 1000.0, 1000.0);
        [map setRegion:location animated:YES];
    }
    
    
}


- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
	if([overlay isKindOfClass:[MKCircle class]]) {
		// Create the view for the radius overlay.
		MKCircleView *circleView = [[[MKCircleView alloc] initWithOverlay:overlay] autorelease];
		circleView.strokeColor = [UIColor purpleColor];
		circleView.fillColor = [[UIColor purpleColor] colorWithAlphaComponent:0.4];
		
		return circleView;
	}
	
	return nil;
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
	if([annotationView isKindOfClass:[RegionAnnotationView class]]) {
		RegionAnnotationView *regionView = (RegionAnnotationView *)annotationView;
		RegionAnnotation *regionAnnotation = (RegionAnnotation *)regionView.annotation;
		
		// If the annotation view is starting to be dragged, remove the overlay and stop monitoring the region.
		if (newState == MKAnnotationViewDragStateStarting) {
			[regionView removeRadiusOverlay];
        
		}
		
		// Once the annotation view has been dragged and placed in a new location, update and add the overlay and begin monitoring the new region.
		if (oldState == MKAnnotationViewDragStateDragging && newState == MKAnnotationViewDragStateEnding) {
			[regionView updateRadiusOverlay];
			
			CLRegion *newRegion = [[CLRegion alloc] initCircularRegionWithCenter:regionAnnotation.coordinate radius:regionAnnotation.radius identifier:[NSString stringWithFormat:@"%f, %f", regionAnnotation.coordinate.latitude, regionAnnotation.coordinate.longitude]];
			regionAnnotation.region = newRegion;
			[newRegion release];
			
		}
	}
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
	RegionAnnotationView *regionView = (RegionAnnotationView *)view;
	RegionAnnotation *regionAnnotation = (RegionAnnotation *)regionView.annotation;
	
	// Stop monitoring the region, remove the radius overlay, and finally remove the annotation from the map.
	[regionView removeRadiusOverlay];
	[map removeAnnotation:regionAnnotation];
}



#pragma mark - RegionsViewController
/*
 This method creates a new region based on the center coordinate of the map view.
 A new annotation is created to represent the region and then the application starts monitoring the new region.
 */
- (IBAction)addRegionWithDistance:(double)distance { // m, not km
	if ([CLLocationManager regionMonitoringAvailable]) {
		// Create a new region based on the center of the map view.
		CLLocationCoordinate2D coord = map.userLocation.coordinate;
		CLRegion *newRegion = [[CLRegion alloc] initCircularRegionWithCenter:coord
																	  radius:distance
																  identifier:[NSString stringWithFormat:@"%f, %f", coord.latitude, coord.longitude]];
		
		// Create an annotation to show where the region is located on the map.
		RegionAnnotation *myRegionAnnotation = [[RegionAnnotation alloc] initWithCLRegion:newRegion];
		myRegionAnnotation.coordinate = newRegion.center;
		myRegionAnnotation.radius = newRegion.radius;
        
        
        
        MKCoordinateRegion location = MKCoordinateRegionMakeWithDistance(newRegion.center, newRegion.radius*1.5, newRegion.radius*1.5);
        [map setRegion:location animated:YES];
        regioned = NO;
        
		
		[map addAnnotation:myRegionAnnotation];
		
		[myRegionAnnotation release];
		
		// Start monitoring the newly created region
		
		[newRegion release];
	}
	else {
		NSLog(@"Region monitoring is not available.");
	}
}

@end

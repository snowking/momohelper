//
//  MMFindViewController.m
//  MomoHelper
//
//  Created by King on 12-11-14.
//  Copyright (c) 2012年 King. All rights reserved.
//

#import "MMFindViewController.h"
#import <QuartzCore/QuartzCore.h>

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
    
    self.distanceField = [[[UITextField alloc] initWithFrame:CGRectMake(0, 44, 320, 40)] autorelease];
    [self.contentView addSubview:distanceField];
    distanceField.backgroundColor = [UIColor lightGrayColor];
    distanceField.inputView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)] autorelease];
    distanceField.inputView.backgroundColor = [UIColor grayColor];
    distanceField.font = [UIFont systemFontOfSize:16];
    distanceField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    distanceField.layer.borderWidth = 1.0;
    
    self.map = [[[MKMapView alloc] initWithFrame:CGRectMake(0, 83, 320, NKContentHeight-83)] autorelease];
    [self.contentView addSubview:map];
    map.showsUserLocation = YES;
    map.layer.borderWidth = 1.0;
    

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


@end

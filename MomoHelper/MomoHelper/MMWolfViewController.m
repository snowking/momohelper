//
//  MMWolfViewController.m
//  MomoHelper
//
//  Created by King on 12-11-14.
//  Copyright (c) 2012年 King. All rights reserved.
//

#import "MMWolfViewController.h"

@interface MMWolfViewController ()

@end

@implementation MMWolfViewController

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
    // Do any additional setup after loading the view from its nib.
    
    self.titleLabel.text = @"狼群";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

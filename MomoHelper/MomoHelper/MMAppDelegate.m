//
//  MMAppDelegate.m
//  MomoHelper
//
//  Created by King on 12-11-14.
//  Copyright (c) 2012年 King. All rights reserved.
//

#import "MMAppDelegate.h"
#import "NKUI.h"

#import "MMFindViewController.h"
#import "MMWolfViewController.h"

@implementation MMAppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    // Config
    [[NKConfig sharedConfig] setNavigatorHeight:49];
    [[NKConfig sharedConfig] setNavigatorChangeAnimate:YES];
    [[NKConfig sharedConfig] setNavigatorShowAnimate:YES];
    [[NKConfig sharedConfig] setDomainURL:@"http://lab.isou.hk/isou/api"];
    [[NKConfig sharedConfig] setParseDataKey:nil];
    
    NKUI *ui = [NKUI sharedNKUI];
    ui.needLogin = NO;
    ui.homeClass = [MMFindViewController class];
    ui.welcomeCalss = [MMFindViewController class];
    
    [ui addTabs:[NSArray arrayWithObjects:[NSArray arrayWithObjects:
                                           [NKSegment segmentWithSize:CGSizeMake(240, 49) color:[UIColor lightGrayColor] andTitle:@"寻Ta"],
                                           [NKSegment segmentWithSize:CGSizeMake(80, 49) color:[UIColor grayColor] andTitle:@"狼群"],
                                           nil],
                 [NSArray arrayWithObjects:[MMFindViewController class], [MMWolfViewController class], nil],
                 nil]];
    
    UINavigationController *navi = [[[UINavigationController alloc] initWithRootViewController:ui] autorelease];
    navi.view.backgroundColor = [UIColor clearColor];
    //navi.supportedInterfaceOrientations =
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320, NKMainHeight)];
    back.image = [[UIImage imageNamed:@"appBackground.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(100, 50, 100, 50)];
    [navi.view insertSubview:back atIndex:0];
    [back release];
    [navi setNavigationBarHidden:YES];
    self.window.rootViewController = navi;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

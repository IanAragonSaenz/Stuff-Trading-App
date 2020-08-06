//
//  AppDelegate.m
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 12/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
@import FBSDKCoreKit;
#import <PFFacebookUtils.h>
#import <ChameleonFramework/Chameleon.h>
#import "Constants.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    ParseClientConfiguration *config = [ParseClientConfiguration   configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        configuration.applicationId = kAppId;
        configuration.clientKey = kClientId;
        configuration.server = @"https://parseapi.back4app.com";
    }];
    [Parse initializeWithConfiguration:config];
    
    [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];
    
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor flatWhiteColorDark];
    pageControl.currentPageIndicatorTintColor =[UIColor flatMintColor];
    pageControl.backgroundColor = [UIColor whiteColor];
    
    [UINavigationBar.appearance setTintColor:[UIColor flatWhiteColor]];
    [UINavigationBar.appearance setBarTintColor:[UIColor flatMintColor]];
    [UINavigationBar.appearance setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor flatWhiteColor]}];
    
    [UISegmentedControl.appearance setSelectedSegmentTintColor:[UIColor flatMintColor]];
    [UISegmentedControl.appearance setBackgroundColor:[UIColor flatWhiteColor]];
    
    [UITabBar.appearance setTintColor:[UIColor flatMintColor]];
    [UITabBar.appearance setBarTintColor:[UIColor flatWhiteColor]];
    
    [UIButton.appearance setTintColor:[UIColor flatBlackColor]];
    return YES;
}

#pragma mark - Facebook Handlers

- (BOOL)application:(UIApplication *)app openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    return [[FBSDKApplicationDelegate sharedInstance] application:app openURL:url options:options];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  [FBSDKAppEvents activateApp];
}

#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end

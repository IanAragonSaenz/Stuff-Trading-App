//
//  RootViewController.h
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 24/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController <UIPageViewControllerDataSource>

#pragma mark - Public Methods
- (void)goToPreviousContentViewController;
- (void)goToNextContentViewController;

@end

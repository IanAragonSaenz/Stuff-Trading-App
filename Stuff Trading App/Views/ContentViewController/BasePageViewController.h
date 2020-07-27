//
//  BasePageViewController.h
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 24/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BasePageViewController : UIViewController

@property (nonatomic, strong) RootViewController *rootViewController;
@property (strong, nonatomic) UINavigationItem *navItem;

@end

NS_ASSUME_NONNULL_END

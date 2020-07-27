//
//  RootViewController.m
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 24/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import "RootViewController.h"
#import "BasePageViewController.h"

@interface RootViewController ()

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *contentPageRestorationIDs;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _contentPageRestorationIDs = @[@"feedViewController", @"feedMapViewController"];
    
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"pageViewController"];
    self.pageViewController.dataSource = self;
    
    UIViewController *startingViewController = [self viewControllerAtIndex:0];
    
    [self.pageViewController setViewControllers:@[startingViewController]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
    
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);
    
    // Add the page view controller to this root view controller.
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

#pragma mark - Public Methods

- (void)goToPreviousContentViewController {
    UIViewController *currentViewController = [self.pageViewController.viewControllers objectAtIndex:0];
    NSString *vcRestorationID = currentViewController.restorationIdentifier;
    NSUInteger index = [self.contentPageRestorationIDs indexOfObject:vcRestorationID];
    
    UIViewController *previousViewController = [self viewControllerAtIndex:index - 1];
    
    [self.pageViewController setViewControllers:@[previousViewController]
                                      direction:UIPageViewControllerNavigationDirectionReverse
                                       animated:YES
                                     completion:nil];
}

- (void)goToNextContentViewController {
    UIViewController *currentViewController = [self.pageViewController.viewControllers objectAtIndex:0];
    NSString *vcRestorationID = currentViewController.restorationIdentifier;
    NSUInteger index = [self.contentPageRestorationIDs indexOfObject:vcRestorationID];
    
    UIViewController *nextViewController = [self viewControllerAtIndex:index + 1];
    
    [self.pageViewController setViewControllers:@[nextViewController]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:nil];
}

#pragma mark - UIPageViewController DataSource

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return self.contentPageRestorationIDs.count;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSString *viewControllerRestorationIdentifier = viewController.restorationIdentifier;
    NSUInteger index = [self.contentPageRestorationIDs indexOfObject:viewControllerRestorationIdentifier];
    
    if (index == 0) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index - 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSString *viewControllerRestorationIdentifier = viewController.restorationIdentifier;
    NSUInteger index = [self.contentPageRestorationIDs indexOfObject:viewControllerRestorationIdentifier];
    
    if (index == self.contentPageRestorationIDs.count - 1) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index + 1];
}

#pragma mark - Get View Controller at Index

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    // Checks if index is out of bounds
    if (index >= self.contentPageRestorationIDs.count) {
        return nil;
    }
    
    // Create a new view controller
    BasePageViewController *contentViewController = (BasePageViewController *)[self.storyboard instantiateViewControllerWithIdentifier:self.contentPageRestorationIDs[index]];

    // Set any data from the view controller
    contentViewController.rootViewController = self;
    contentViewController.navItem = self.navigationItem;
    
    return contentViewController;
}
 
- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

@end


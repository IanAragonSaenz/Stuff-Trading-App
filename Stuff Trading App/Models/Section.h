//
//  Section.h
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 22/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Section : PFObject <PFSubclassing>

@property (strong, nonatomic) NSString *name;

@end

NS_ASSUME_NONNULL_END

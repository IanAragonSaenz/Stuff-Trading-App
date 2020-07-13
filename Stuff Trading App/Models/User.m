//
//  User.m
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 13/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import "User.h"

@implementation User

@dynamic image;

+ (User *)user{
    return (User *)[PFUser user];
}

@end

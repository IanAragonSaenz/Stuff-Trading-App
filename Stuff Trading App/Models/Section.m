//
//  Section.m
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 22/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import "Section.h"

@implementation Section

@dynamic name;

+ (nonnull NSString *)parseClassName {
    return @"Section";
}

+ (void)fetchSections:(void (^)(NSArray *sections, NSError *error))completion {
    PFQuery *query = [PFQuery queryWithClassName:@"Section"];
    [query orderByAscending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable sections, NSError * _Nullable error) {
        if(error) {
            completion(nil, error);
        } else {
            completion(sections, nil);
        }
    }];
}

@end

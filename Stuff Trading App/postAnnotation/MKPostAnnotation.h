//
//  MKPostAnnotation.h
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 27/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKPostAnnotation : NSObject <MKAnnotation>

@property (nonatomic, strong) Post *post;

@end

NS_ASSUME_NONNULL_END

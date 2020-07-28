//
//  PostAnnotation.h
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 27/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostAnnotation : MKPointAnnotation

@property (nonatomic, strong) Post *post;
+ (PostAnnotation *)setAnnotation:(Post *)post;

@end

NS_ASSUME_NONNULL_END

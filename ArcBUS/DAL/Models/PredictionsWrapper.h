//
//  PredictionsWrapper.h
//  ArcusMBTA
//
//  Created by David C. Thor on 1/22/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PredictionsDirection.h"

@interface PredictionsWrapper : NSObject

@property (nonatomic, strong) NSString *agencyTitle;
@property (nonatomic, strong) NSString *routeTitle;
@property (nonatomic, strong) NSString *routeTag;
@property (nonatomic, strong) NSString *stopTitle;
@property (nonatomic, strong) NSString *stopTag;
@property (nonatomic, strong) NSString *dirTitleBecauseNoPredictions;
@property (nonatomic, strong) NSArray *directions;

- (id)initWithData:(NSDictionary *)data;
- (PredictionsDirection *)getDirectionForTitle:(NSString *)title;

@end

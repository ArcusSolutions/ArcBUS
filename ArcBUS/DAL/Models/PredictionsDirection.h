//
//  PredictionsDirection.h
//  ArcusMBTA
//
//  Created by David C. Thor on 1/22/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Prediction.h"

@interface PredictionsDirection : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *predictions;

- (id)initWithData:(NSDictionary *)data;

@end

//
//  PredictionsDirection.m
//  ArcusMBTA
//
//  Created by David C. Thor on 1/22/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import "PredictionsDirection.h"

@implementation PredictionsDirection

- (id)initWithData:(NSDictionary *)data
{
    self = [super init];
    
    self.title = [data objectForKey:@"title"];
    
    NSMutableArray *predictions = [[NSMutableArray alloc] init];
    
    NSObject *predictionObj = [data objectForKey:@"prediction"];
    if ([predictionObj isKindOfClass:[NSDictionary class]]) {
        Prediction *prediction = [[Prediction alloc] initWithData:[data objectForKey:@"prediction"]];
        [predictions addObject:prediction];
    } else {
        for (NSDictionary *predictionDict in [data objectForKey:@"prediction"]) {
            Prediction *prediction = [[Prediction alloc] initWithData:predictionDict];
            [predictions addObject:prediction];
        }
    }
    
    self.predictions = [NSArray arrayWithArray:predictions];
    
    return self;
}

@end

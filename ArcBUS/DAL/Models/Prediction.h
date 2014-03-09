//
//  Prediction.h
//  ArcusMBTA
//
//  Created by David C. Thor on 1/22/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Prediction : NSObject

@property (nonatomic) NSInteger epochTime;
@property (nonatomic) NSInteger seconds;
@property (nonatomic) NSInteger minutes;
@property (nonatomic, assign) BOOL isDeparture;
@property (nonatomic, assign) BOOL affectedByLayover;
@property (nonatomic, strong) NSString *dirTag;
@property (nonatomic, strong) NSString *vehicle;
@property (nonatomic, strong) NSString *block;
@property (nonatomic, strong) NSString *tripTag;

- (id)initWithData:(NSDictionary *)data;

@end

//
//  TwitterDataServiceDelegate.h
//  ArcBUS
//
//  Created by David C. Thor on 2/22/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TwitterDataServiceDelegate <NSObject>

- (void)searchResultsReceived:(NSArray *)results;
- (void)bannerReceived:(NSDictionary *)banner;

@end
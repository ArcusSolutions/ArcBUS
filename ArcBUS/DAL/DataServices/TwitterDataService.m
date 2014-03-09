//
//  TwitterDataService.m
//  ArcBUS
//
//  Created by David C. Thor on 2/22/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import "TwitterDataService.h"

@implementation TwitterDataService

- (id)init
{
    self = [super init];
    self.twitterAPI = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:NSLocalizedString(@"Twitter App Consumer Key", nil)
                                                      consumerSecret:NSLocalizedString(@"Twitter App Consumer Secret", nil)];
    return self;
}


- (id)initWithDelegate:(id<TwitterDataServiceDelegate>)delegate
{
    self = [self init];
    self.delegate = delegate;
    return self;
}


- (void)getSearchResultsForQuery:(NSString *)query
{
    [self.twitterAPI verifyCredentialsWithSuccessBlock:^(NSString *bearerToken) {
        [self.twitterAPI getSearchTweetsWithQuery:query
                             successBlock:^(NSDictionary *searchMetadata, NSArray *statuses) {
                                 [self.delegate searchResultsReceived:statuses];
                             } errorBlock:^(NSError *error) {
                                 [self.delegate searchResultsReceived:nil];
                             }];
    } errorBlock:^(NSError *error) {
        [self.delegate searchResultsReceived:nil];
    }];
}


- (void)getTimelineWithScreenname:(NSString *)screenname
{
    [self.twitterAPI verifyCredentialsWithSuccessBlock:^(NSString *bearerToken) {
        [self.twitterAPI getUserTimelineWithScreenName:screenname
                                          successBlock:^(NSArray *statuses) {
                                              [self.delegate searchResultsReceived:statuses];
                                          } errorBlock:^(NSError *error) {
                                              [self.delegate searchResultsReceived:nil];
                                          }];
    } errorBlock:^(NSError *error) {
        [self.delegate searchResultsReceived:nil];
    }];
}


- (void)getBannerForScreenname:(NSString *)screenname
{
    [self.twitterAPI verifyCredentialsWithSuccessBlock:^(NSString *bearerToken) {
        [self.twitterAPI getUsersProfileBannerForUserID:@"1"
                                           orScreenName:screenname
                                           successBlock:^(NSDictionary *banner) {
                                               [self.delegate bannerReceived:banner];
                                           } errorBlock:^(NSError *error) {
                                               [self.delegate bannerReceived:nil];
                                           }];
    } errorBlock:^(NSError *error) {
        [self.delegate bannerReceived:nil];
    }];
}

@end

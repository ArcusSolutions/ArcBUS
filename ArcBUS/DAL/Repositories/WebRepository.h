//
//  WebRepository.h
//  Prototype
//
//  Created by Michael Muesch on 1/14/14.
//  Copyright (c) 2014 ArcusSolutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DatabaseRepository.h"

@interface WebRepository : NSObject

@property(nonatomic,strong) DatabaseRepository *databaseRepository;

-(NSString*) getWithUrl:(NSString*) url;
-(NSString*) postWithUrl:(NSString*) url andBody:(NSString*) body;
-(NSString*) putWithUrl:(NSString*) url andBody:(NSString*) body;
-(NSString*) deleteWithUrl:(NSString*) url andBody:(NSString*) body;

@end
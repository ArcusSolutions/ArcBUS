//
//  DatabaseRepository.h
//  ArcusMBTA
//
//  Created by imac on 1/28/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DatabaseRepository : NSObject

@property(nonatomic,strong) NSString *databasePath;

- (NSString *)escape:(NSObject *)value;
-(void) executeQuery:(NSString*)query;
-(NSString *) getColumnIndex:(int)index fromQuery:(NSString*)query;

@end

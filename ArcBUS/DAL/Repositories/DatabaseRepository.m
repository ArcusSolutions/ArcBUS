//
//  DatabaseRepository.m
//  ArcusMBTA
//
//  Created by imac on 1/28/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import "DatabaseRepository.h"

@implementation DatabaseRepository

static DatabaseRepository *databaseRepository;

-(id) init
{
    if(databaseRepository == nil)
    {
        databaseRepository = [super init];
        sqlite3 *database = nil;
        NSString *documentDirectory = NSSearchPathForDirectoriesInDomains
        (NSDocumentDirectory, NSUserDomainMask, YES)[0];
        databaseRepository.databasePath = [[NSString alloc] initWithString:
                        [documentDirectory stringByAppendingPathComponent: @"database.db"]];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath: self.databasePath ] == NO)
        {
            const char *dbpath = [self.databasePath UTF8String];
            if (sqlite3_open(dbpath, &database) == SQLITE_OK)
            {
                sqlite3_close(database);
            }
            else {
                NSLog(@"Failed to open/create database");
            }
        }    
    }
    self = databaseRepository;
    return self;
}

- (NSString *)escape:(NSObject *)value {
    if (value == nil)
        return nil;
    NSString *escapedValue = nil;
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSMutableString class]]) {
        NSString *valueString = (NSString *) value;
        char *theEscapedValue = sqlite3_mprintf("'%q'", [valueString UTF8String]);
        escapedValue = [NSString stringWithUTF8String:(const char *)theEscapedValue];
        sqlite3_free(theEscapedValue);
    } else
        escapedValue = [NSString stringWithFormat:@"%@", value];
    return escapedValue;
}

-(void) executeQuery:(NSString *)query
{
    sqlite3 *database = nil;
    const char *dbpath = [self.databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        char *errMsg;
        sqlite3_exec(database, [query UTF8String], NULL, NULL, &errMsg);
        sqlite3_close(database);
    }
}

-(NSString *) getColumnIndex:(int)index fromQuery:(NSString *)query
{
    sqlite3 *database;
    sqlite3_stmt *statement;
    if (sqlite3_open([self.databasePath UTF8String], &database) == SQLITE_OK)
    {
        const char *query_stmt = [query UTF8String];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                 return [[NSString alloc] initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 0)];

            }
            else{
                return nil;
            }
            sqlite3_reset(statement);
        }
    }
    return nil;
}

@end

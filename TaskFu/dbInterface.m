//
//  dbInterface.m
//  TaskFu
//
//  Created by Johannes du Plessis on 2013/04/15.
//  Copyright (c) 2013 Johannes du Plessis. All rights reserved.
//

#import "dbInterface.h"

@implementation dbInterface

+ (void) loadDB {
    


    
    sqlite3 *database;
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths lastObject];
    NSString *databasePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"tasks.sqlite"];
    //NSString* databasePath = [documentsDirectory stringByAppendingPathComponent:@"tasks.sqlite"];
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        
        sqlite3_stmt *statement;
        NSString *querySQL = @"SELECT * FROM tasks";
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            NSLog(@"Yes");
        } else {
            NSLog(@"%s", sqlite3_errmsg(database));
        }
        
    } else {
        
        NSLog(@"Failed to open database at %@ with error %s", databasePath, sqlite3_errmsg(database));
        sqlite3_close (database);
        
    }
    
}


//nodes -> id / name / theme / background
//tasks -> id / attached_id / node / name / notes / link / date / icon / prime / x / y


+ (int) addNode {
    
    // DB init
    
    sqlite3 *database;
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths lastObject];
    NSString *databasePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"taskDatabase.sql"];
    // NSString* databasePath = [documentsDirectory stringByAppendingPathComponent:@"taskDatabase.sql"];
    
    //DB query
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        
        sqlite3_stmt *statement;
       // NSString *querySQL = @"INSERT INTO nodes (name,theme,background) VALUES ('General','brown','03.jpg')";
        
        NSString *querySQL = @"SELECT * FROM nodes";
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            NSLog(@"Yes");
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSString *phoneField =
                [[NSString alloc] initWithUTF8String:
                 (const char *) sqlite3_column_text(statement, 1)];
                
                NSLog(@"%@",phoneField);
                
            }
            sqlite3_finalize(statement);
        } else {
            NSLog(@"%s", sqlite3_errmsg(database));
        }
        
    } else {
        
        NSLog(@"Failed to open database at %@ with error %s", databasePath, sqlite3_errmsg(database));
        sqlite3_close (database);
        
    }
    
    return 1 ;
    
}

+ (void) editNode:(int)nodeID {
    
}

+ (void) deleteNode:(int)nodeID {
    
}

+ (NSArray*)getNode:(int)nodeID {
    
}

+ (int) addTask {
    
    return 1 ;
    
}

+ (void) editTask:(int)taskID  {
    
}

+ (void) deleteTask:(int)taskID  {
    
}

+ (NSArray*)getTask:(int)taskID {
    
}

@end

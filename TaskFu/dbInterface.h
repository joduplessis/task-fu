//
//  dbInterface.h
//  TaskFu
//
//  Created by Johannes du Plessis on 2013/04/15.
//  Copyright (c) 2013 Johannes du Plessis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface dbInterface : NSObject {

}

+ (void) loadDB ;

+ (int) addNode ;
+ (void) editNode:(int)nodeID ;
+ (void) deleteNode:(int)nodeID ;
+ (NSArray*)getNode:(int)nodeID ;

+ (int) addTask ;
+ (void) editTask:(int)taskID  ;
+ (void) deleteTask:(int)taskID  ;
+ (NSArray*)getTask:(int)taskID ;

@end

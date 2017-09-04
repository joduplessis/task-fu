//
//  globalVariables.h
//  Task Fu
//
//  Created by Johannes du Plessis on 2013/04/26.
//  Copyright (c) 2013 Johannes du Plessis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface globalVariables : NSObject {
    int hasBeenDeleted ;
}

@property (assign) int hasBeenDeleted ;

+ (void) setDeleted:(int)val ;
+ (int) getDeleted ;

@end

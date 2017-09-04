//
//  globalVariables.m
//  Task Fu
//
//  Created by Johannes du Plessis on 2013/04/26.
//  Copyright (c) 2013 Johannes du Plessis. All rights reserved.
//

#import "globalVariables.h"

@implementation globalVariables

static int hasBeenDeleted  = 0 ;

+ (void) setDeleted:(int)val {
    hasBeenDeleted = val ;
}

+ (int) getDeleted {
    return hasBeenDeleted ;
}

@end
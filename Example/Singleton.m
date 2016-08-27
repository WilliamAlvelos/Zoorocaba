//
//  Singleton.m
//  Zoorocaba
//
//  Created by William Alvelos on 05/05/16.
//  Copyright © 2016 Metaio GmbH. All rights reserved.
//

#import "Singleton.h"

static Singleton *mySingleton;

@implementation Singleton

@synthesize bananas;

#pragma mark SingletonDescption stuff

+ (Singleton *)mySingleton
{
    if(!mySingleton){
        mySingleton = [[Singleton alloc]init];
    }
    
    return mySingleton;
}

+ (id)allocWithZone:(NSZone *)zone
{
    if (!mySingleton) {
        mySingleton = [super allocWithZone:zone];
        return mySingleton;
    } else {
        return mySingleton;
    }
}

- (id)copyWithZone:(NSZone*) zone
{
    return self;
}


@end

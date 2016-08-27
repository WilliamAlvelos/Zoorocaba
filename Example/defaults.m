//
//  Singleton.m
//  Zoorocaba
//
//  Created by William Alvelos on 05/05/16.
//  Copyright © 2016 Metaio GmbH. All rights reserved.
//

#import "defaults.h"

@implementation defaults


-(void)save:(NSMutableArray *)array{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:array forKey:@"array"];
    [defaults synchronize];
}
-(NSMutableArray*)get{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray*array = [defaults objectForKey:@"array"];
    return array;
}


-(id)initWithName:(NSMutableArray*)name_
{
    self = [super init];
    if (self) {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:name_ forKey:@"array"];
    }
    return self;
}

@end

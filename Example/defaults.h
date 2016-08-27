//
//  defaults.h
//  Zoorocaba
//
//  Created by William Alvelos on 06/05/16.
//  Copyright © 2016 Metaio GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface defaults : NSObject

-(void)save:(NSMutableArray*)array;
-(NSMutableArray*)get;
-(id)initWithName:(NSMutableArray*)name_;

@end
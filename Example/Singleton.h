//
//  Header.h
//  Zoorocaba
//
//  Created by William Alvelos on 05/05/16.
//  Copyright © 2016 Metaio GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Singleton : NSObject {
    NSMutableArray *bananas;
}

@property (nonatomic, retain) NSMutableArray *bananas;

@end

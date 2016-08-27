//
//  ZooUtil.h
//  Zoorocaba
//
//  Created by William Alvelos on 10/03/16.
//  Copyright © 2016 Metaio GmbH. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface ZooUtil : NSObject{
    NSMutableArray *bananas;
}

@property (nonatomic, retain) NSMutableArray *bananas;


+ (BOOL)raio:(CLLocationCoordinate2D)localizacao ponto:(CLLocationCoordinate2D)ponto;
+ (float)latitude1:(float)lat1 longitude1:(float)long1 latitude2:(float)lat2 longitude2:(float)long2;


@end


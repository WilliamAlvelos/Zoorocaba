//
//  ZooUtil.m
//  Zoorocaba
//
//  Created by William Alvelos on 10/03/16.
//  Copyright © 2016 Metaio GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZooUtil.h"

@implementation ZooUtil : NSObject


+ (BOOL)raio:(CLLocationCoordinate2D)localizacao ponto:(CLLocationCoordinate2D)ponto{
    
    float calculo = 0;
    
    float LY = localizacao.latitude;
    float LX = localizacao.longitude;

    float PY = ponto.latitude;
    float PX = ponto.longitude;
    
    calculo = sqrt((PX - LX) * (PX - LX) + (PY - LY) * (PY - LY));
    
    
//    printf("calculo %f\n", calculo);
    
    if(calculo < 0.0001){
        return true;
    }
    else{
        return false ;
    }
}


+ (float)latitude1:(float)lat1 longitude1:(float)long1 latitude2:(float)lat2 longitude2:(float)long2{
    

    float calculo = 0;
    
    float LY = lat1;
    float LX = long1;
    
    float PY = lat2;
    float PX = long2;
    
    calculo = sqrt((PX - LX) * (PX - LX) + (PY - LY) * (PY - LY));
    
    //    printf("calculo %f\n", calculo);
    
    return calculo;
}





@end
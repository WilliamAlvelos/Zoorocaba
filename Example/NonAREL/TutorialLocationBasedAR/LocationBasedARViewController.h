// Copyright 2007-2014 metaio GmbH. All rights reserved.
#import "NonARELTutorialViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>
#import <metaioSDK/IMetaioSDK.h>
#import <MapKit/MapKit.h>

namespace metaio
{
    class IGeometry;   // forward declaration
}

@interface LocationBasedARViewController : NonARELTutorialViewController <MKMapViewDelegate, CLLocationManagerDelegate>{
    MKMapView * mapView;
    metaio::IAnnotatedGeometriesGroup* annotatedGeometriesGroup;
    metaio::IGeometry* londonGeo;
    metaio::IGeometry* romeGeo;
    metaio::IGeometry* parisGeo;
    metaio::IGeometry* tokyoGeo;
    metaio::IGeometry* metaioMan;
    metaio::IRadar* m_radar;
    
    metaio::LLACoordinate   m_currentLocation;

    std::vector<metaio::IRadar> locais;
    NSMutableArray *latitude;
    NSMutableArray *longitude;

}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property(nonatomic, retain) CLLocationManager *locationManager;
@property metaio::LLACoordinate userLocation;

- (metaio::IGeometry*)loadUpdatedAnnotation:(metaio::IGeometry*)geometry userData:(void*)userData existingAnnotation:(metaio::IGeometry*)existingAnnotation;

@end

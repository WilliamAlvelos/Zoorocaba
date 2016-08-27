// Copyright 2007-2014 metaio GmbH. All rights reserved.
#import <QuartzCore/QuartzCore.h>
#import "LocationBasedARViewController.h"
#include <metaioSDK/Common/SensorsComponentIOS.h>
#include <metaioSDK/IMetaioSDKIOS.h>
#import "Singleton.h"
#import "ZooUtil.h"
#import "defaults.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include <vector>
#import <math.h>

class AnnotatedGeometriesGroupCallback : public metaio::IAnnotatedGeometriesGroupCallback
{
public:
	AnnotatedGeometriesGroupCallback(LocationBasedARViewController* _vc) : vc(_vc) {}

	virtual metaio::IGeometry* loadUpdatedAnnotation(metaio::IGeometry* geometry, void* userData, metaio::IGeometry* existingAnnotation) override
	{
		return [vc loadUpdatedAnnotation:geometry userData:userData existingAnnotation:existingAnnotation];
	}

	LocationBasedARViewController* vc;
};

@interface LocationBasedARViewController ()

@property (nonatomic, assign) AnnotatedGeometriesGroupCallback *annotatedGeometriesGroupCallback;
@property (strong, nonatomic) IBOutlet UILabel *latitude;
@property (strong, nonatomic) IBOutlet UILabel *longitude;
@property int posicao1;
@property int posicao;
@property std::vector<metaio::LLACoordinate>data;
@property UIImageView *myImage;
//@property metaio::IGeometry* locations[5];

@property (strong, nonatomic) IBOutlet UILabel *distancia;
@property (strong, nonatomic) IBOutlet UIImageView *setinha;


@property (strong, nonatomic) IBOutlet UILabel *angulo;

- (UIImage*)getAnnotationImageForTitle:(NSString*)title;
@end


@implementation LocationBasedARViewController

@synthesize mapView;

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    CLLocationCoordinate2D location;
    location.latitude = userLocation.coordinate.latitude;
    location.longitude = userLocation.coordinate.longitude;

    m_currentLocation.latitude = userLocation.coordinate.latitude;
    m_currentLocation.longitude = userLocation.coordinate.longitude;

    region.span = span;
    region.center = location;
    [mapView setRegion:region animated:YES];
    
    metaio::LLACoordinate tokyo = metaio::LLACoordinate(userLocation.coordinate.latitude, userLocation.coordinate.longitude, 0, 0);
    
    self.latitude.text = [[NSString alloc] initWithFormat:@"%f", m_currentLocation.longitude];
    self.longitude.text = [[NSString alloc] initWithFormat:@"%f", m_currentLocation.latitude];
    
    //defaults *a = [[defaults alloc]init];
    //NSMutableArray*array = [a get];
    
    //NSLog(@"%@", array);
    
    
   // double angulo = (m_currentLocation.latitude - [[latitude objectAtIndex:_posicao + 1] floatValue])/(m_currentLocation.longitude - [[longitude objectAtIndex:_posicao + 1] floatValue]);
    //ver se esta funcionando corretamente
    //_setinha.transform = CGAffineTransformMakeRotation(atan(angulo));
    
    
    //_setinha.layer.transform = CGAffineTransformMakeRotation(1.5);
    
    //NSLog(@" angulo %lf", angulo);
    
    self.distancia.text = [NSString stringWithFormat:@"Distancia: %lf", [ZooUtil latitude1:m_currentLocation.latitude longitude1:m_currentLocation.longitude latitude2:[[latitude objectAtIndex:_posicao + 1] floatValue] longitude2:[[longitude objectAtIndex:_posicao + 1] floatValue]]];
    
    
    [self removePoints:location];
    
    
}

-(void)PointIn{
    CLLocationCoordinate2D P1;
    P1.latitude = -23.669241;
    P1.longitude= -46.700534;
    
    
    if(_posicao == 1){
        
        parisGeo->setScale(0);
        m_radar->remove(parisGeo);
        annotatedGeometriesGroup->removeGeometry(parisGeo);
        
        
        
        londonGeo->setScale(100.f);
        _posicao++;
        
    }
    
    
    //self.distancia.text = [NSString stringWithFormat:@"Distancia para o ponto: %lf", [ZooUtil latitude1:[[latitude objectAtIndex:_posicao] floatValue] longitude1:[[longitude objectAtIndex:_posicao] floatValue] latitude2:[[latitude objectAtIndex:_posicao + 1] floatValue] longitude2:[[longitude objectAtIndex:_posicao + 1] floatValue]]];
    
    //double angulo = ([[latitude objectAtIndex:_posicao] floatValue] - [[latitude objectAtIndex:_posicao + 1] floatValue])/([[longitude objectAtIndex:_posicao] floatValue] - [[longitude objectAtIndex:_posicao + 1] floatValue]);
    //ver se esta funcionando corretamente
    //_setinha.transform = CGAffineTransformMakeRotation(atan(angulo));
    
    
    //_setinha.transform = CGAffineTransformMakeRotation(30.0);
}


-(void)removePoints: (CLLocationCoordinate2D)location{
    
    bool test = false;
    
    CLLocationCoordinate2D biblioteca;
    biblioteca.latitude = -23.669329;
    biblioteca.longitude = -46.701016;
    
//    self.locations = {tokyoGeo, parisGeo};
    
    test = [ZooUtil raio:biblioteca ponto:location];
    
    if(test && _posicao == 0){
        m_radar->remove(tokyoGeo);
        tokyoGeo->setScale(0);
        annotatedGeometriesGroup->removeGeometry(tokyoGeo);
        
        
        parisGeo->setScale(100.f);
        _posicao++;
    }
    
    CLLocationCoordinate2D P1;
    P1.latitude = -23.669241;
    P1.longitude= -46.700534;
    
    test = [ZooUtil raio:P1 ponto:location];
    
    if(test && _posicao == 1){
        
        parisGeo->setScale(0);
        m_radar->remove(parisGeo);
        annotatedGeometriesGroup->removeGeometry(parisGeo);
        
        //self.distancia.text = [NSString stringWithFormat:@"%lf", [ZooUtil raio:P1 p:location]];
        
        londonGeo->setScale(100.f);
        _posicao++;
        
    }
    
    CLLocationCoordinate2D placa;
    placa.latitude = -23.668961;
    placa.longitude= -46.700067;
    
    test = [ZooUtil raio:placa ponto:location];
    
    if(test && _posicao == 2){
        m_radar->remove(londonGeo);
        londonGeo->setScale(0);
        annotatedGeometriesGroup->removeGeometry(londonGeo);
        
        //self.distancia.text = [NSString stringWithFormat:@"%lf", [ZooUtil raio:placa p:location]];

        romeGeo->setScale(100.f);
        _posicao++;
        
    }
    
    CLLocationCoordinate2D P2;
    P2.latitude = -23.670177;
    P2.longitude= -46.698888;
    
    test = [ZooUtil raio:P2 ponto:location];
    
    if(test && _posicao == 3){
        m_radar->remove(romeGeo);
        romeGeo->setScale(0);
        
        //self.distancia.text = [NSString stringWithFormat:@"%lf", [ZooUtil raio:P2 p:location]];
        
        annotatedGeometriesGroup->removeGeometry(romeGeo);
        
        metaioMan->setScale(100.f);
        _posicao++;
    }
    
    CLLocationCoordinate2D animal;
    animal.latitude = -23.669719;
    animal.longitude = -46.698213;
    
    test = [ZooUtil raio:animal ponto:location];
    
    if(test && _posicao == 4){
        m_radar->remove(metaioMan);
        metaioMan->setScale(0);
        annotatedGeometriesGroup->removeGeometry(metaioMan);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alerta"
                                                        message:@"Você Liberou a carta"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles: nil,nil];
        [alert show];
    }
    
    
    //self.distancia.text = [NSString stringWithFormat:@"Distancia para o ponto: %lf", [ZooUtil latitude1:[[latitude objectAtIndex:_posicao] floatValue] longitude1:[[longitude objectAtIndex:_posicao] floatValue] latitude2:[[latitude objectAtIndex:_posicao + 1] floatValue] longitude2:[[longitude objectAtIndex:_posicao + 1] floatValue]]];
    
    //double angulo = ([[latitude objectAtIndex:_posicao] floatValue] - [[latitude objectAtIndex:_posicao + 1] floatValue])/([[longitude objectAtIndex:_posicao] floatValue] - [[longitude objectAtIndex:_posicao + 1] floatValue]);
    //ver se esta funcionando corretamente
    //_setinha.transform = CGAffineTransformMakeRotation(atan(angulo));
    //atan(((inicio - p->y)/(inicio - p->x)))

}



- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error"
                               message:error.description
                               delegate:nil
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error"
                               message: error.description
                               delegate:nil
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:nil];
    [errorAlert show];
}






#pragma mark - UIViewController lifecycle

- (void) viewDidLoad
{
	[super viewDidLoad];
    
//    Grafo *teste = [[Grafo alloc]init];
//    
//    grafo->main();
    //this does not work
    
    self.posicao = 0;
    
    CGRect sizeView = self.view.bounds;
    
    sizeView.size.width = sizeView.size.width - 500;
    
    
    mapView = [[MKMapView alloc]
               initWithFrame:sizeView
               ];
    mapView.showsUserLocation = YES;
    mapView.mapType = MKMapTypeStandard;
    mapView.delegate = self;
//    mapView.hidden = true;
    mapView.zoomEnabled = YES;
    [self.view addSubview:mapView];
 
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate= self;
    _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    _locationManager.distanceFilter=kCLDistanceFilterNone;
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager startMonitoringSignificantLocationChanges];
    [_locationManager startUpdatingLocation];
    
    
	
	if (!m_pMetaioSDK->setTrackingConfiguration("GPS")){
		NSLog(@"Failed to set the tracking configuration");
	}

	annotatedGeometriesGroup = m_pMetaioSDK->createAnnotatedGeometriesGroup();
	self.annotatedGeometriesGroupCallback = new AnnotatedGeometriesGroupCallback(self);
	annotatedGeometriesGroup->registerCallback(self.annotatedGeometriesGroupCallback);

	// Clamp geometries' Z position to range [5000;200000] no matter how close or far they are away.
	// This influences minimum and maximum scaling of the geometries (easier for development).
	m_pMetaioSDK->setLLAObjectRenderingLimits(5, 200);

	// Set render frustum accordingly
	m_pMetaioSDK->setRendererClippingPlaneLimits(10, 220000);
    
    //adiciona valores para latitude

    [latitude addObject:[NSNumber numberWithDouble:-23.669719]];
    [latitude addObject:[NSNumber numberWithDouble:-23.668993]];
    [latitude addObject:[NSNumber numberWithDouble:-23.670177]];
    [latitude addObject:[NSNumber numberWithDouble:-23.669241]];
    [latitude addObject:[NSNumber numberWithDouble:-23.669329]];
    
    
    //adiciona valores para longitude
    
    [longitude addObject:[NSNumber numberWithDouble:-46.698213]];
    [longitude addObject:[NSNumber numberWithDouble:-46.700067]];
    [longitude addObject:[NSNumber numberWithDouble:-46.698888]];
    [longitude addObject:[NSNumber numberWithDouble:-46.700534]];
    [longitude addObject:[NSNumber numberWithDouble:-46.701016]];
    
	// let's create LLA objects for known cities
	metaio::LLACoordinate munich = metaio::LLACoordinate(-23.669719, -46.698213, -30, 0);
	metaio::LLACoordinate london = metaio::LLACoordinate(-23.668993 , -46.700067, 0, 0);
	metaio::LLACoordinate rome = metaio::LLACoordinate(-23.670177,  -46.698888, 0, 0);
	metaio::LLACoordinate paris = metaio::LLACoordinate(-23.669241, -46.700534, 0, 0);
	metaio::LLACoordinate tokyo = metaio::LLACoordinate(-23.669329,  -46.701016, 0, 0);
	
	// Load some POIs. Each of them has the same shape at its geoposition. We pass a string
	// (const char*) to IAnnotatedGeometriesGroup::addGeometry so that we can use it as POI title
	// in the callback, in order to create an annotation image with the title on it.
    //annotatedGeometriesGroup->addGeometry(londonGeo, (void*)"BIBLIOTECA");

	londonGeo = [self createPOIGeometry:london];
    londonGeo->setScale(0);
    
	parisGeo = [self createPOIGeometry:paris];
    parisGeo->setScale(0);
	
	romeGeo = [self createPOIGeometry:rome];
    romeGeo->setScale(0);
	
	tokyoGeo = [self createPOIGeometry:tokyo];
    tokyoGeo->setScale(100.f);
    
//    [self locais] = arrayWithObjects:londonGeo, parisGeo, romeGeo, tokyoGeo, nil];
	
	// load a 3D model and put it in Munich
	NSString* metaioManModel = [[NSBundle mainBundle] pathForResource:@"metaioman"
															   ofType:@"md2"
														  inDirectory:@"tutorialContent_crossplatform/TutorialLocationBasedAR/Assets"];
    
	if (metaioManModel)
	{
        const char *utf8Path = [metaioManModel fileSystemRepresentation];
		metaioMan = m_pMetaioSDK->createGeometry(metaio::Path::fromUTF8(utf8Path));
		metaioMan->setTranslationLLA(munich);
		metaioMan->setLLALimitsEnabled(true);
		metaioMan->setScale(0);
	}
	else
	{
		NSLog(@"Model not found");
	}

	// Create radar object
	m_radar = m_pMetaioSDK->createRadar();
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *assetFolder = @"tutorialContent_crossplatform/TutorialLocationBasedAR/Assets";
    NSString *radarPath = [mainBundle pathForResource:@"radar"
                                               ofType:@"png"
                                          inDirectory:assetFolder];
    const char *radarUtf8Path = [radarPath UTF8String];
    
    m_radar->setBackgroundTexture(metaio::Path::fromUTF8(radarUtf8Path));
    
    NSString *yellowPath = [mainBundle pathForResource:@"yellow"
                                                ofType:@"png"
                                           inDirectory:assetFolder];
    const char *yellowUtf8Path = [yellowPath UTF8String];
    m_radar->setObjectsDefaultTexture(metaio::Path::fromUTF8(yellowUtf8Path));
    m_radar->setRelativeToScreen(metaio::IGeometry::ANCHOR_TL);
    
	// Add geometries to the radar
    m_radar->add(tokyoGeo);
    m_radar->add(romeGeo);
    m_radar->add(londonGeo);
    m_radar->add(parisGeo);

    
}


- (void)viewWillDisappear:(BOOL)animated
{
	// as soon as the view disappears, we stop rendering and stop the camera
	m_pMetaioSDK->stopCamera();
	[super viewWillDisappear:animated];
	
	annotatedGeometriesGroup->registerCallback(NULL);
	if (self.annotatedGeometriesGroupCallback) {
		delete self.annotatedGeometriesGroupCallback;
		self.annotatedGeometriesGroupCallback = NULL;
	}
}


- (void)drawFrame
{
    // make pins appear upright
	if (m_pMetaioSDK && m_pSensorsComponent)
	{
		const metaio::SensorValues sensorValues = m_pSensorsComponent->getSensorValues();

		float heading = 0.0f;
		if (sensorValues.hasAttitude())
		{
			float m[9];
			sensorValues.attitude.getRotationMatrix(m);

			metaio::Vector3d v(m[6], m[7], m[8]);
			v = v.getNormalized();

			heading = -atan2(v.y, v.x) - (float)M_PI_2;
		}

		metaio::IGeometry* geos[] = {londonGeo, parisGeo, romeGeo, tokyoGeo};
		const metaio::Rotation rot((float)M_PI_2, 0.0f, -heading);
		for (int i = 0; i < 4; ++i)
		{
			geos[i]->setRotation(rot);
            
            //NSLog(@"%@", rot);
            //pegar o valor que ta rotacionando para utilizar na setinha
		}
	}

	[super drawFrame];
}


#pragma mark - Handling Touches

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//	// Here's how to pick a geometry
//	UITouch *touch = [touches anyObject];
//	CGPoint loc = [touch locationInView:self.glkView];
//	
//	// get the scale factor (will be 2 for retina screens)
//	float scale = self.glkView.contentScaleFactor;
//	
//	// ask sdk if the user picked an object
//	// the 'true' flag tells sdk to actually use the vertices for a hit-test, instead of just the bounding box
//	 metaio::IGeometry* model = m_pMetaioSDK->getGeometryFromViewportCoordinates(loc.x * scale, loc.y * scale, true);
//	
//	if ( model )
//	{
//		metaio::LLACoordinate modelCoordinate = model->getTranslationLLA();
//		NSLog(@"You picked a model at location %f, %f!", modelCoordinate.latitude, modelCoordinate.longitude);
//		m_radar->setObjectsDefaultTexture([[[NSBundle mainBundle] pathForResource:@"yellow"
//																		   ofType:@"png"
//																	  inDirectory:@"tutorialContent_crossplatform/TutorialLocationBasedAR/Assets"] UTF8String]);
//		m_radar->setObjectTexture(model, [[[NSBundle mainBundle] pathForResource:@"red"
//																		  ofType:@"png"
//																	 inDirectory:@"tutorialContent_crossplatform/TutorialLocationBasedAR/Assets"] UTF8String]);
//        
//        
//	}
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	// Implement if you need to handle touches
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	// Implement if you need to handle touches
}


#pragma mark - Helper methods

- (metaio::IGeometry*)createPOIGeometry:(const metaio::LLACoordinate&)lla
{
	NSString* poiModelPath = [[NSBundle mainBundle] pathForResource:@"ExamplePOI"
															 ofType:@"obj"
														inDirectory:@"tutorialContent_crossplatform/TutorialLocationBasedAR/Assets"];
	assert(poiModelPath);
    
    const char *utf8Path = [poiModelPath fileSystemRepresentation];
    metaio::IGeometry* geo = m_pMetaioSDK->createGeometry(metaio::Path::fromUTF8(utf8Path));
	geo->setTranslationLLA(lla);
	geo->setLLALimitsEnabled(true);
	geo->setScale(100.f);
	return geo;
}

- (metaio::IGeometry*)loadUpdatedAnnotation:(metaio::IGeometry*)geometry userData:(void*)userData existingAnnotation:(metaio::IGeometry*)existingAnnotation{
	if (existingAnnotation){
		// We don't update the annotation if e.g. distance has changed
		return existingAnnotation;
	}

	if (!userData)
	{
		return 0;
	}

    // use this method to create custom annotations
	//UIImage* img = [self getAnnotationImageForTitle:[NSString stringWithUTF8String:(const char*)userData]];

    UIImage* thumbnail = [UIImage imageNamed:@"AppIcon72x72~ipad"];
    UIImage* img = metaio::createAnnotationImage(
                                         [NSString stringWithFormat:@"%s", (const char*)userData],
                                         geometry->getTranslationLLA(),
                                         m_currentLocation,
                                         thumbnail,
                                         nil,
                                         0
                                         );

	return m_pMetaioSDK->createGeometryFromCGImage([[NSString stringWithFormat:@"%s", (const char*)userData] UTF8String], img.CGImage, true, false);
}




/** This is an example for how you can create custom annotations for your objects */
- (UIImage*)getAnnotationImageForTitle:(NSString*)title{
    
	UIImage* bgImage = [UIImage imageNamed:@"tutorialContent_crossplatform/TutorialLocationBasedAR/Assets/POI_bg.png"];
	assert(bgImage);

	// Make bgImage.size the real resolution
	bgImage = [UIImage imageWithCGImage:bgImage.CGImage scale:1 orientation:UIImageOrientationUp];

	UIGraphicsBeginImageContext(bgImage.size);
	CGContextRef currContext = UIGraphicsGetCurrentContext();

	// Mirror the context transformation to draw the images correctly (CG has different coordinates)
	CGContextSaveGState(currContext);
	CGContextScaleCTM(currContext, 1.0, -1.0);

	CGContextDrawImage(currContext, CGRectMake(0, 0, bgImage.size.width, -bgImage.size.height), bgImage.CGImage);

	CGContextRestoreGState(currContext);

	// Add title
	CGContextSetRGBFillColor(currContext, 1.0f, 1.0f, 1.0f, 1.0f);
	CGContextSetTextDrawingMode(currContext, kCGTextFill);
	CGContextSetShouldAntialias(currContext, true);

	const CGFloat fontSize = floor(bgImage.size.height * 2.0);
	const CGFloat border = floor(bgImage.size.height * 0.1);
	CGRect titleRect = CGRectMake(border, border, bgImage.size.width - 2*border, bgImage.size.height - 2*border);
	const CGSize titleActualSize = [title sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:titleRect.size lineBreakMode:NSLineBreakByTruncatingTail];

	// Vertically center text
	titleRect.origin.y += (titleRect.size.height - titleActualSize.height) / 2.0f;

	[title drawInRect:titleRect
			 withFont:[UIFont systemFontOfSize:fontSize]
		lineBreakMode:NSLineBreakByTruncatingTail
			alignment:NSTextAlignmentCenter];

	// Create composed UIImage from the context
	UIImage* finalImage = UIGraphicsGetImageFromCurrentImageContext();

	UIGraphicsEndImageContext();

	return finalImage;
}

- (IBAction)alertAction:(UIButton*)sender {
    sender.hidden = true;
}


@end

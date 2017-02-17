//
//  LocationViewController.m
//  Party Maker
//
//  Created by intern on 2/14/17.
//  Copyright © 2017 intern. All rights reserved.
//

#import "LocationViewController.h"
#import "CreatePartyViewController.h"

static double SOFTHEME_LATITUDE = 50.428994f;
static double SOFTHEME_LONGTITUDE = 30.518234f;

@interface LocationViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) NSString *address;

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpTapGestureRecognizer];
    [self createInitialAnnotation];
    [self setUpNavigationItem];
}

// set up the navigation bar
- (void) setUpNavigationItem {
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(onDoneButtonClicked:)];
    
    self.navigationItem.leftBarButtonItem = doneButton;
}

- (void) onDoneButtonClicked:(UIBarButtonItem*) sender {
    NSArray *viewControllers = [self.navigationController viewControllers];
    XIBViewController *createPartyViewController = [viewControllers objectAtIndex:viewControllers.count - 2];
    
    CLLocationCoordinate2D currentPinLocation = [self getPinLocation];
    [createPartyViewController setPartyLatitude:currentPinLocation.latitude andLongtitude:currentPinLocation.longitude];
    [createPartyViewController setChooseLocationButtonTitle:self.address];
    
    [self.navigationController popToViewController:createPartyViewController animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(SOFTHEME_LATITUDE, SOFTHEME_LONGTITUDE);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.1f, 0.1f);
    MKCoordinateRegion region = {coord, span};
    [self.mapView setRegion:region];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// create an initial annotation
- (void) createInitialAnnotation {
    MKPointAnnotation *initialAnnotation = [[MKPointAnnotation alloc] init];
    [initialAnnotation setCoordinate:CLLocationCoordinate2DMake(SOFTHEME_LATITUDE, SOFTHEME_LONGTITUDE)];
    
    [self.mapView addAnnotation:initialAnnotation];
    [self.mapView selectAnnotation:initialAnnotation animated:YES];
}

// get the annotationView for annotations
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    static NSString *reuseId = @"pin";
    MKPinAnnotationView *pin = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
    if (!pin)
    {
        pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
        pin.draggable = YES;
        pin.canShowCallout = YES;
        [pin setPinTintColor:[UIColor blueColor]];
    }
    else
    {
        pin.annotation = annotation;
    }
    
    return pin;
}

// handle the pin drag
- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)annotationView
didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState
{
    if (newState == MKAnnotationViewDragStateEnding)
    {
        CLLocationCoordinate2D droppedAt = annotationView.annotation.coordinate;
        [self makeReverseGeocoding:droppedAt ForAnnotation:annotationView.annotation];
        
    }
}

// set up the tap gesture recognizer
- (void) setUpTapGestureRecognizer {
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapClicked:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.mapView addGestureRecognizer:tapGestureRecognizer];
}

- (void) mapClicked:(UIGestureRecognizer*) recognizer {
    CGPoint point = [recognizer locationInView:self.mapView];
    
    CLLocationCoordinate2D tapPoint = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    
    NSLog(@"%lu", (unsigned long)self.mapView.annotations.count);
    
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    
    [annotation setCoordinate:tapPoint];

    [self makeReverseGeocoding:tapPoint ForAnnotation:annotation];
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotation:annotation];
}

// geocode annotation
- (void) makeReverseGeocoding:(CLLocationCoordinate2D) location
                ForAnnotation:(MKPointAnnotation*) annotation {
    if (!self.geocoder) {
        self.geocoder = [[CLGeocoder alloc] init];
    }
    
    CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
    
    [self.geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemark, NSError *error) {
        
        //initialize the title to "unknown" in case geocode has failed...
        NSString *annTitle = @"Address unknown";
        
        //set the title if we got any placemarks...
        if (placemark.count > 0)
        {
            CLPlacemark *topResult = [placemark objectAtIndex:0];
            annotation.title = [self getAnnotationTitleWith:topResult];
            annotation.subtitle = [self getAnnotationSubtitleWith:topResult];
        }
        else {
            annotation.title = annTitle;
        }
    }];
}

- (NSString*) getAnnotationTitleWith:(CLPlacemark*) placemark {
    NSString *country = placemark.country;
    if (!country) {
        country = @"Address is not identified...";
    }
    
    NSString *locality = placemark.locality;
    if (!locality) {
        locality = @"";
    }
    
    NSString *annotationTitle = [NSString stringWithFormat:@"%@ %@", country, locality];
    
    self.address = annotationTitle;
    
    return annotationTitle;
}

- (NSString*) getAnnotationSubtitleWith:(CLPlacemark*) placemark {
    NSString *subLocality = placemark.subLocality;
    if (!subLocality) {
        subLocality = @"";
    }
    
    NSString *thoroughfare = placemark.thoroughfare;
    if (!thoroughfare) {
        thoroughfare = @"";
    }

    NSString *annotationSubtitle = [NSString stringWithFormat:@"%@ %@", subLocality, thoroughfare];
    
    if (![annotationSubtitle isEqualToString:@" "]) {
        self.address = annotationSubtitle;
    }
    
    return annotationSubtitle;
}

- (CLLocationCoordinate2D) getPinLocation {
    NSLog(@"%lu", (unsigned long)self.mapView.annotations.count);
    return [[self.mapView.annotations lastObject] coordinate];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

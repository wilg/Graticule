//
//  GHDetailViewController.m
//  Graticule
//
//  Created by Wil Gieseler on 11/4/12.
//  Copyright (c) 2012 Wil Gieseler. All rights reserved.
//

#import "GHDetailViewController.h"
#import "GHGeohash.h"

@interface GHDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation GHDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

//    if (self.geohash) {
//                
//        [self.map addAnnotation:self.geohash];
//        //[self.map setRegion:MKCoordinateRegionMake(geohash.destination, MKCoordinateSpanMake(1, 1))];
////        [self.map setCenterCoordinate:self.map.userLocation.location.coordinate animated:YES];
//        
//        self.detailDescriptionLabel.text = [self.geohash description];
//    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
//    NSLog(@"Updated: %@", map.centerCoordinate);
    GHGeohash *newGeohash = [GHGeohash currentMeetupForStartLocation:self.map.centerCoordinate];
    GHGeohash *previousGeohash = self.geohash;
    self.geohash = newGeohash;
    
    NSLog(@"Geohash: %@", newGeohash);
    if (!previousGeohash || ![previousGeohash sharesGraticuleWith:newGeohash]) {
        if (previousGeohash)
            [self.map removeAnnotation: previousGeohash];
        [self.map addAnnotation: self.geohash];

        if (self.graticuleOverlay)
            [self.map removeOverlay:self.graticuleOverlay];
        self.graticuleOverlay = [self.geohash boundingPolygon];
        [self.map addOverlay:self.graticuleOverlay];

        self.detailDescriptionLabel.text = [self.geohash description];
    }
//    if (!self.geohash) {
//        [self.map setRegion:MKCoordinateRegionMake(newGeohash.destination, MKCoordinateSpanMake(1, 1))];
//    }
//    self.geohash = newGeohash;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolygon class]])
    {
        MKPolygonView*    aView = [[MKPolygonView alloc] initWithPolygon:(MKPolygon*)overlay];
        
        aView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:0.2];
        aView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        aView.lineWidth = 3;
        aView.alpha=.3; // This line is changing transparancy level of overlay
        return aView;
    }
    return nil;
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end

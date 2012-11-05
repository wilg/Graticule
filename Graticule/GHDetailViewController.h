//
//  GHDetailViewController.h
//  Graticule
//
//  Created by Wil Gieseler on 11/4/12.
//  Copyright (c) 2012 Wil Gieseler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "GHGeohash.h"

@interface GHDetailViewController : UIViewController <UISplitViewControllerDelegate, MKMapViewDelegate>

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) GHGeohash *geohash;
@property (strong, nonatomic) GHGeohash *previousGeohash;
@property (strong, nonatomic) MKPolygon *graticuleOverlay;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet MKMapView *map;
@end

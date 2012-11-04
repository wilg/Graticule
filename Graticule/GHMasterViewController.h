//
//  GHMasterViewController.h
//  Graticule
//
//  Created by Wil Gieseler on 11/4/12.
//  Copyright (c) 2012 Wil Gieseler. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GHDetailViewController;

@interface GHMasterViewController : UITableViewController

@property (strong, nonatomic) GHDetailViewController *detailViewController;

@end

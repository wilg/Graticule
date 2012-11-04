//
//  GHDetailViewController.h
//  Graticule
//
//  Created by Wil Gieseler on 11/4/12.
//  Copyright (c) 2012 Wil Gieseler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GHDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end

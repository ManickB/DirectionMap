//
//  FlyOverView.h
//  MapTutorial
//
//  Created by ViVID on 10/5/16.
//  Copyright © 2016 ViVID. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#define SharedAppdelegate ((AppDelegate *)[[UIApplication sharedApplication]delegate])
@import MapKit;

@interface FlyOverView : UIViewController<MKMapViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
@property(strong,nonatomic)NSString * AddressName;
@property(strong,nonatomic)NSString * Flylat;
@property(strong,nonatomic)NSString * Flylong;
@property (strong, nonatomic) IBOutlet MKMapView *mapview;

@end

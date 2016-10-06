//
//  StreetView.h
//  MapTutorial
//
//  Created by ViVID on 9/14/16.
//  Copyright © 2016 ViVID. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#define SharedAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])
@import GoogleMaps;

@interface StreetView : ViewController<GMSPanoramaViewDelegate,UIAlertViewDelegate>
@property(nonatomic,strong)NSString *CountryName;
@property(nonatomic,strong)NSString * LatValue;
@property(nonatomic,strong)NSString * LongValue;
@property(nonatomic,assign)CLLocationCoordinate2D panoramaNear;
@end

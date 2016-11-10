//
//  MapKitView.h
//  MapTutorial
//
//  Created by ViVID on 9/24/16.
//  Copyright © 2016 ViVID. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ViewController.h"
#import "DetailsViewController.h"
#import "DirectionCollectionCell.h"
#import "StreetView.h"
#import "FlyOverView.h"
#define SharedAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])
@import CoreLocation;
@import MapKit;
@protocol HandleMapSearch <NSObject>
- (void)dropPinZoomIn:(MKPlacemark *)placemark;
@end
@interface MapKitView : UIViewController<CLLocationManagerDelegate,HandleMapSearch, MKMapViewDelegate,UISearchControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIAlertViewDelegate>
{
    CLLocation *newLocation;
    BOOL checkLoction;
    NSDictionary *currentLocationAddress;
    NSString *getOverlineColor;
    MKMapItem *SourceItem;
    MKMapItem *DestinationItem;
    UIBarButtonItem*RightBarButtItem;
    BOOL annotationPin;
    BOOL CheckINFo;
    BOOL checkVisible;
    BOOL checkStartInfo;
    MKRoute *route;
    UIButton *StartButt;
    NSString *sourceTitle;
    NSString *DesTitle;
    NSString *DirectionINdication;
}
@property (strong, nonatomic) IBOutlet MKMapView *mapview;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segementOutlet;

- (IBAction)DirectionControl:(UISegmentedControl *)sender;
@property (strong, nonatomic) IBOutlet UIView *DirectionControlView;
- (IBAction)clearBUtt:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *FTaddressLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *NavigationActivity;
- (IBAction)BacktoDirection:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *DirectionResultView;
@property (strong, nonatomic) IBOutlet UILabel *DirectionResultlbl;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *DirectionActivity;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) NSArray *routeSteps;
@property (strong, nonatomic) IBOutlet UILabel *DirectonResultlbl2;
@property (strong, nonatomic) IBOutlet UILabel *Time;
@property (strong, nonatomic) IBOutlet UILabel *Distance;
@property (strong, nonatomic) IBOutlet UIButton *detailsOutlet;
- (IBAction)DetailsButt:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *InfoView;
- (IBAction)MapTypeControlButt:(UISegmentedControl *)sender;
@property (assign, nonatomic) NSInteger Topvalue;
@property (assign, nonatomic) NSInteger bottomValue;
@property (assign, nonatomic) NSInteger infoValue;
@property (assign, nonatomic) NSInteger CollectionValue;
@property (assign, nonatomic) NSInteger mapRectVAlue;
@property (strong, nonatomic) NSString * CheckZoom;
@property (strong, nonatomic) NSString * DistanceStep;
@property (strong, nonatomic) NSString * AddressStep;
//
@property (strong, nonatomic) IBOutlet UICollectionView *AddCollectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageCtrl;
@property (strong, nonatomic) IBOutlet UIView *CollectionControlView;
@property (strong, nonatomic) IBOutlet UIButton *IdeaButt;
- (IBAction)ActionOFIdea:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *DirectionIndImg;

@end

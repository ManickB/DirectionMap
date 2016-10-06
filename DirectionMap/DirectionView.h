//
//  DirectionView.h
//  MapTutorial
//
//  Created by ViVID on 9/23/16.
//  Copyright © 2016 ViVID. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DirectionSearchCell.h"
//#define Appdelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#import "AppDelegate.h"
#define SharedAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])
@import MapKit;

@interface DirectionView : UIViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *LocationSeacrhedArr;
    BOOL checkFromTo;
}
@property MKMapView *mapView;
@property NSArray<MKMapItem *> *matchingItems;
- (IBAction)NavigationCancelButt:(id)sender;

- (IBAction)NavigateRouteButt:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *FromText;
@property (strong, nonatomic) IBOutlet UITextField *ToText;
@property(strong,nonatomic)NSDictionary *currentDicAddress;
@property (strong, nonatomic) IBOutlet UIButton *RouteOutlet;
@property(strong,nonatomic)NSString *currentAddress;
- (IBAction)cancelButtAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *CurrentLOcView;
@property (strong, nonatomic) IBOutlet UIView *CommonCurrLocView;
@property (strong, nonatomic) IBOutlet UITableView *SearchLocationTable;
- (IBAction)FromTextButt:(UITextField *)sender;
- (IBAction)ToTextButt:(UITextField *)sender;
@property (strong, nonatomic)NSString *getBacktoDirection;
@property (strong, nonatomic)NSString *ReFromAdd;
@property (strong, nonatomic)NSString *ReToAdd;
@end

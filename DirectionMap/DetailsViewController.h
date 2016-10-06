//
//  DetailsViewController.h
//  MapTutorial
//
//  Created by ViVID on 9/30/16.
//  Copyright © 2016 ViVID. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "DetailViewCell.h"
#import "MapKitView.h"
#define SharedAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@interface DetailsViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *getInstructionArr;
    NSMutableArray *getDistanceArr;
  
}
@property(nonatomic,strong)MKRoute *routesDetails;
@property(nonatomic,strong)NSString*getRouteINfo;
- (IBAction)backButt:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *DetailsTable;
@property (strong, nonatomic) IBOutlet UIImageView *DirectionIndicateImg;
@end

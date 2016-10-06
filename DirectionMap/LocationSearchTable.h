//
//  LocationSearchTable.h
//  MapTutorial
//
//  Created by ViVID on 9/16/16.
//  Copyright © 2016 ViVID. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKitView.h"
@import MapKit;
@class HandleMapSearch;
@interface LocationSearchTable : UITableViewController<UISearchResultsUpdating>
@property MKMapView *mapView;
@property id <HandleMapSearch> handleMapSearchDelegate;

@end

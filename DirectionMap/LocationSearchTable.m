//
//  LocationSearchTable.m
//  MapTutorial
//
//  Created by ViVID on 9/16/16.
//  Copyright © 2016 ViVID. All rights reserved.
//

#import "LocationSearchTable.h"

@interface LocationSearchTable ()
@property NSArray<MKMapItem *> *matchingItems;

@end

@implementation LocationSearchTable

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController;
{
    NSString *searchBarText = searchController.searchBar.text;
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = searchBarText;
    request.region = _mapView.region;
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        self.matchingItems = response.mapItems;
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 0;
//}


//func parseAddress(selectedItem:MKPlacemark) -> String {
//    
//    // put a space between "4" and "Melrose Place"
//    let firstSpace = (selectedItem.subThoroughfare != nil &&
//                      selectedItem.thoroughfare != nil) ? " " : ""
//    
//    // put a comma between street and city/state
//    let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) &&
//    (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
//    
//    // put a space between "Washington" and "DC"
//    let secondSpace = (selectedItem.subAdministrativeArea != nil &&
//                       selectedItem.administrativeArea != nil) ? " " : ""
//    
//    let addressLine = String(
//                             format:"%@%@%@%@%@%@%@",
//                             // street number
//                             selectedItem.subThoroughfare ?? "",
//                             firstSpace,
//                             // street name
//                             selectedItem.thoroughfare ?? "",
//                             comma,
//                             // city
//                             selectedItem.locality ?? "",
//                             secondSpace,
//                             // state
//                             selectedItem.administrativeArea ?? ""
//                             )
//    
//    return addressLine
//}
//
//}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_matchingItems count];
}
- (NSString *)parseAddress:(MKPlacemark *)selectedItem {
    // put a space between "4" and "Melrose Place"
    NSString *firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? @" " : @"";
    // put a comma between street and city/state
    NSString *comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? @", " : @"";
    // put a space between "Washington" and "DC"
    NSString *secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? @" " : @"";
    NSString *addressLine = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",
                             (selectedItem.subThoroughfare == nil ? @"" : selectedItem.subThoroughfare),
                             firstSpace,
                             (selectedItem.thoroughfare == nil ? @"" : selectedItem.thoroughfare),
                             comma,
                             // city
                             (selectedItem.locality == nil ? @"" : selectedItem.locality),
                             secondSpace,
                             // state
                             (selectedItem.administrativeArea == nil ? @"" : selectedItem.administrativeArea)
                             ];
    return addressLine;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    MKPlacemark *selectedItem = _matchingItems[indexPath.row].placemark;
    cell.textLabel.text = selectedItem.name;
    cell.detailTextLabel.text = [self parseAddress:selectedItem];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MKPlacemark *selectedItem = _matchingItems[indexPath.row].placemark;
    [_handleMapSearchDelegate dropPinZoomIn:(selectedItem)];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  DirectionView.m
//  MapTutorial
//
//  Created by ViVID on 9/23/16.
//  Copyright © 2016 ViVID. All rights reserved.
//

#import "DirectionView.h"
@import MapKit;

@interface DirectionView ()

@end

@implementation DirectionView
@synthesize FromText,ToText,currentAddress,CommonCurrLocView,CurrentLOcView,matchingItems,SearchLocationTable,currentDicAddress,RouteOutlet,getBacktoDirection,ReFromAdd,ReToAdd;

- (void)viewDidLoad {
    [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated
{
    matchingItems=[[NSMutableArray alloc]init];
    if (getBacktoDirection.length == 0)
    {
    RouteOutlet.enabled=NO;
    [CommonCurrLocView setHidden:YES];
    CurrentLOcView.layer.cornerRadius=5.0f;
    currentAddress=[NSString stringWithFormat:@"%@",[currentDicAddress objectForKey:@"FormattedAddressLines"]];
    if (currentAddress.length != 0)
    {
        NSLog(@"%@",currentAddress);
//        NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:@"CurrentLocation"];
//        NSRange selectedRange = NSMakeRange(0, 14);
//        [string addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:selectedRange];
        FromText.text=[NSString stringWithFormat:@"Current Location"];
        checkFromTo=NO;
        [self getSearch:[currentDicAddress objectForKey:@"City"]];
    }
    else
    {
        FromText.text=@"";
        ToText.text=@"";
        [CommonCurrLocView setHidden:YES];
    }
    }
    else
    {
        [CommonCurrLocView setHidden:YES];
        FromText.text=[NSString stringWithFormat:@"%@",ReFromAdd];
        ToText.text=[NSString stringWithFormat:@"%@",ReToAdd];
        [self getSearch:ReToAdd];
    }
    SearchLocationTable.delegate=self;
    SearchLocationTable.dataSource=self;
    [SearchLocationTable reloadData];
    SearchLocationTable.sectionIndexBackgroundColor=[UIColor whiteColor];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == FromText)
    {
        checkFromTo=NO;
        if (FromText.text.length != 0)
        {
            if ([FromText.text isEqualToString:@"Current Location"])
            {
            [CommonCurrLocView setHidden:NO];
            [self getSearch:[currentDicAddress objectForKey:@"City"]];
            }
            else
            {
            [self getSearch:FromText.text];
            }
        }
        else if(FromText.text.length == 0)
        {
            [self getSearch:currentAddress];
        }
        else
        {
            [self getSearch:textField.text];
        }
    }
    else if (textField == ToText)
    {
        checkFromTo=YES;
        if(FromText.text.length != 0 && ToText.text.length == 0)
        {
            [self getSearch:[currentDicAddress objectForKey:@"City"]];
        }
        else if(FromText.text.length == 0 && ToText.text.length == 0)
        {
            [self getSearch:currentAddress];
        }
        else
        {
            [self getSearch:textField.text];
        }
    }
    if (FromText.text.length != 0 && ToText.text.length != 0)
    {
         RouteOutlet.enabled=YES;
    }
    else
    {
          RouteOutlet.enabled=NO;
    }
    
   
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == FromText)
    {
        checkFromTo=NO;
        if (FromText.text.length != 0)
        {
            [CommonCurrLocView setHidden:YES];
            [self getSearch:[currentDicAddress objectForKey:@"City"]];
        }
        else if(FromText.text.length == 0)
        {
            [self getSearch:currentAddress];
        }
        else
        {
            [self getSearch:textField.text];
        }
    }
    else if (textField == ToText)
    {
        checkFromTo=YES;
        if(FromText.text.length != 0 && ToText.text.length == 0)
        {
            [self getSearch:[currentDicAddress objectForKey:@"City"]];
        }
        else if(FromText.text.length == 0 && ToText.text.length == 0)
        {
            [self getSearch:currentAddress];
        }
        else
        {
            [self getSearch:textField.text];
        }
    }

}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}
- (IBAction)NavigationCancelButt:(id)sender
{
   SharedAppDelegate.FromDirection=@"";
   SharedAppDelegate.ToDirection=@"";
   [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)NavigateRouteButt:(id)sender
{
    if (FromText.text.length !=0)
    {
        if (ToText.text.length!=0)
        {
            SharedAppDelegate.FromDirection=@"";
            SharedAppDelegate.ToDirection=@"";
            SharedAppDelegate.FromDirection=FromText.text;
            SharedAppDelegate.ToDirection=ToText.text;
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Your To Address is Empty" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
    }
    else
    {
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Your From Address is Empty" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (FromText.text.length != 0 && ToText.text.length != 0)
    {
         RouteOutlet.enabled=YES;
    }
    else
    {
         RouteOutlet.enabled=NO;
    }
    if (textField == FromText)
    {
        checkFromTo=NO;
        if (FromText.text.length != 0)
        {
            [self getSearch:[currentDicAddress objectForKey:@"City"]];
        }
        else if(FromText.text.length == 0)
        {
            [self getSearch:currentAddress];
        }
        else
        {
            [self getSearch:textField.text];
        }
    }
    else if (textField == ToText)
    {
        checkFromTo=YES;
        if(FromText.text.length != 0 && ToText.text.length == 0)
        {
            [self getSearch:[currentDicAddress objectForKey:@"City"]];
        }
        else if(FromText.text.length == 0 && ToText.text.length == 0)
        {
            [self getSearch:currentAddress];
        }
        else
        {
            [self getSearch:textField.text];
        }
    }
    return [textField resignFirstResponder];
}
- (IBAction)FromTextButt:(UITextField *)sender
{
    if (FromText.text.length != 0 && ToText.text.length != 0)
    {
        RouteOutlet.enabled=YES;
    }
    else
    {
        RouteOutlet.enabled=NO;
    }
        checkFromTo=NO;
        if(FromText.text.length == 0)
        {
            [self getSearch:currentAddress];
        }
        else
        {
            [self getSearch:sender.text];
        }
}

- (IBAction)ToTextButt:(UITextField *)sender
{
    NSLog(@"%@",sender.text);
    if (FromText.text.length != 0 && ToText.text.length != 0)
    {
        RouteOutlet.enabled=YES;
    }
    else
    {
        RouteOutlet.enabled=NO;
    }
        checkFromTo=YES;
        if(FromText.text.length != 0 && ToText.text.length == 0)
        {
            [self getSearch:[currentDicAddress objectForKey:@"City"]];
        }
        else if(FromText.text.length == 0 && ToText.text.length == 0)
        {
            [self getSearch:currentAddress];
        }
        else
        {
            [self getSearch:sender.text];
        }
}
- (IBAction)cancelButtAction:(id)sender
{
        FromText.text=@"";
        [CommonCurrLocView setHidden:YES];
        [self getSearch:currentAddress];
        [SearchLocationTable reloadData];

}
-(void)getSearch:(NSString *)text
{
    NSString *searchBarText=text;
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = searchBarText;
    request.region = _mapView.region;
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (response == nil)
        {
            NSLog(@"%@",response.mapItems);
            NSLog(@"%@",error);
        }
        else
        {
        self.matchingItems = response.mapItems;
        [self.SearchLocationTable reloadData];
        }
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return matchingItems.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DirectionSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DirectionSearchCell"];
    MKPlacemark *selectedItem = matchingItems[indexPath.row].placemark;
    NSString *parkViewStreet=[NSString stringWithFormat:@"%@",[currentDicAddress objectForKey:@"Name"]];
    [parkViewStreet stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    if ([parkViewStreet isEqualToString:selectedItem.name])
    {
        cell.TitleLab.text = @"Current Location";
        cell.Subtitlelab.text = [self parseAddress:selectedItem];
        cell.IndicateIcon.image=[UIImage imageNamed:@"Location.png"];
    }
    else
    {
        cell.TitleLab.text = selectedItem.name;
        cell.Subtitlelab.text = [self parseAddress:selectedItem];
        cell.IndicateIcon.image=[UIImage imageNamed:@"CellSearch.png"];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     MKPlacemark *selectedItem = matchingItems[indexPath.row].placemark;
//    NSLog(@"%f", selectedItem.region.center.latitude);
//    NSLog(@"%f", selectedItem.region.center.longitude);
    if (checkFromTo == NO)
    {
        //FromText
        if ([FromText.text isEqualToString:@"Current Location"])
        {
             SharedAppDelegate.FromDirection=[NSString stringWithFormat:@"%@",currentAddress];
        }
        else
        {
            SharedAppDelegate.FromDirection=[NSString stringWithFormat:@"%@ ,%@",selectedItem.name,[self parseAddress:selectedItem]];
        }
        FromText.text=[NSString stringWithFormat:@"%@ ,%@",selectedItem.name,[self parseAddress:selectedItem]];
        [FromText resignFirstResponder];
    }
    else  if (checkFromTo == YES)
    {
        //ToText
     SharedAppDelegate.ToDirection=[NSString stringWithFormat:@"%@ ,%@",selectedItem.name,[self parseAddress:selectedItem]];
        ToText.text=[NSString stringWithFormat:@"%@ ,%@",selectedItem.name,[self parseAddress:selectedItem]];
        [ToText resignFirstResponder];
    }
    if (FromText.text.length != 0 && ToText.text.length != 0)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
   
    return 0.01f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.textColor=[UIColor whiteColor];
    myLabel.frame = CGRectMake(10, 0, 320, 30);
    myLabel.font = [UIFont fontWithName:@"Verdana" size:15];
    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor=[UIColor blackColor];
    [headerView addSubview:myLabel];
    return headerView;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    if ([FromText.text isEqualToString:@"Current Location"]&&ToText.text.length==0)
    {
        sectionName=[NSString stringWithFormat:@"RECENTS"];
    }
    else if(FromText.text.length == 0&&ToText.text.length == 0)
    {
    sectionName=[NSString stringWithFormat:@"RECENTS"];
    }
    else if(FromText.text.length != 0||ToText.text.length != 0)
    {
     sectionName=[NSString stringWithFormat:@"BEST MATCHES"];
    }
    return sectionName;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    UILabel *Label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, screenRect.size.width, 50)];
    Label.text=@"Powered by Manick";
    Label.textColor=[UIColor darkGrayColor];
    Label.font=[UIFont fontWithName:@"Arial" size:13];
    Label.textAlignment=NSTextAlignmentCenter;
    [view addSubview:Label];
    return view;
    //    return [UIView new];
}
@end

//
//  MapKitView.m
//  MapTutorial
//
//  Created by ViVID on 9/24/16.
//  Copyright © 2016 ViVID. All rights reserved.
//

#import "MapKitView.h"
#import "DirectionView.h"
#import "LocationSearchTable.h"

@interface MapKitView ()
{
    CLLocationManager *locationManager;
    UISearchController *resultSearchController;
    MKPlacemark *selectedPin;
}
@end

@implementation MapKitView
@synthesize mapview,DirectionControlView,segementOutlet,FTaddressLabel,NavigationActivity,DirectionResultlbl,DirectionResultView,DirectionActivity,toolBar,routeSteps,DirectonResultlbl2,Time,Distance,detailsOutlet;
@synthesize InfoView,Topvalue,bottomValue,infoValue,mapRectVAlue,CheckZoom,AddressStep,DistanceStep,AddCollectionView,CollectionValue,pageCtrl,CollectionControlView;
@synthesize DirectionIndImg,IdeaButt;
- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [CollectionControlView setHidden:YES];
    [InfoView setHidden:YES];
    DirectionControlView.hidden=YES;
    DirectionResultView.hidden=YES;
    toolBar.hidden=YES;
    self.navigationController.navigationBarHidden = YES;
    [self performSelector:@selector(aftercall) withObject:nil afterDelay:0.0f];
}
-(void)aftercall
{
    [StartButt setEnabled:NO];
    InfoView.layer.cornerRadius=5.0f;
    DirectionResultView.layer.cornerRadius=7.0f;
    detailsOutlet.layer.borderColor=[UIColor whiteColor].CGColor;
    detailsOutlet.layer.borderWidth=2.0f;
    detailsOutlet.layer.masksToBounds=YES;
    if (SharedAppDelegate.FromDirection.length == 0)
    {
        if (SharedAppDelegate.CheckStreetDirection.length == 0)
        {
            [self originalNavigation];
        }
        else
        {
            SharedAppDelegate.CheckStreetDirection=@"";
        }
    }
    else if (SharedAppDelegate.FromDirection.length != 0)
    {
        toolBar.hidden=NO;
        mapview.delegate=self;
        [mapview removeAnnotations:[mapview annotations]];
        [mapview removeOverlays:mapview.overlays];
        toolBar.barTintColor=[UIColor blackColor];
        toolBar.translucent=NO;
        UIButton *btnName = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnName setFrame:CGRectMake(16, 7, 30, 30)];
        [btnName setBackgroundImage:[UIImage imageNamed:@"Near(white).png"] forState:UIControlStateNormal];
        [btnName addTarget:self action:@selector(CurrentLocateButt:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *locationItem = [[UIBarButtonItem alloc] initWithCustomView:btnName];
        UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIButton *INfoName = [UIButton buttonWithType:UIButtonTypeCustom];
        [INfoName setFrame:CGRectMake(273, 7, 30, 30)];
        [INfoName setBackgroundImage:[UIImage imageNamed:@"info(white).png"] forState:UIControlStateNormal];
        [INfoName addTarget:self action:@selector(InfoButt:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *InfoItem = [[UIBarButtonItem alloc] initWithCustomView:INfoName];
        
        StartButt = [UIButton buttonWithType:UIButtonTypeCustom];
        [StartButt setFrame:CGRectMake(140, 7, 50, 50)];
        [StartButt setTintColor:[UIColor whiteColor]];
        [StartButt setTitle:@"Start" forState:UIControlStateNormal];
        [StartButt addTarget:self action:@selector(StartButt:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *StartItem = [[UIBarButtonItem alloc] initWithCustomView:StartButt];
        
        NSArray *itemsArray = [NSArray arrayWithObjects:locationItem,flexButton,StartItem,flexButton,InfoItem, nil];
        [toolBar setItems:itemsArray];
        self.navigationController.navigationBarHidden =YES;
        [segementOutlet setSelectedSegmentIndex:0];
        NSString *getFirstWordFrom=[[SharedAppDelegate.FromDirection componentsSeparatedByString:@","]objectAtIndex:0];
        NSString *getFirstWordTo=[[SharedAppDelegate.ToDirection componentsSeparatedByString:@","]objectAtIndex:0];
        NSString *combine=[NSString stringWithFormat:@"%@ to %@",getFirstWordFrom,getFirstWordTo];
        FTaddressLabel.layer.cornerRadius=3.0f;
        FTaddressLabel.layer.masksToBounds=YES;
        FTaddressLabel.text=combine;
        [NavigationActivity setHidden:NO];
        [DirectionActivity setHidden:NO];
        [self performSelector:@selector(showsubview) withObject:nil afterDelay:0.0f];
        [self performSelector:@selector(findDirectionFromAppleServer) withObject:nil afterDelay:0.1f];
    }
}
-(void)showsubview
{
    Topvalue=0;
    bottomValue=0;
    //Top View
    DirectionControlView.hidden=NO;
    CGRect newFrame = DirectionControlView.frame;
    if (Topvalue ==  newFrame.size.height)
    {
        Topvalue = newFrame.size.height;
    }
    else
    {
        Topvalue = 0;
        newFrame.origin.y=0;
    }
    newFrame.origin.y += Topvalue;
    NSLog(@"%f",newFrame.origin.x);
    NSLog(@"%f",newFrame.origin.y);
    NSLog(@"%f",newFrame.size.width);
    NSLog(@"%f",newFrame.size.height);
    [UIView animateWithDuration:0.5f animations:^{
        DirectionControlView.frame =newFrame;
    }];
    
    //BottomView
    [DirectionResultlbl setHidden:YES];
    [DirectonResultlbl2 setHidden:YES];
    [Time setHidden:YES];
    [Distance setHidden:YES];
    [detailsOutlet setHidden:YES];
    [DirectionIndImg setHidden:YES];
    [IdeaButt setHidden:YES];
    DirectionResultView.hidden=NO;
    CGRect newBottomFrame = DirectionResultView.frame;
    if (bottomValue == newBottomFrame.size.height)
    {
        bottomValue =newBottomFrame.size.height;
    }
    else
    {
        bottomValue =0;
        newBottomFrame.origin.y=toolBar.frame.origin.y-DirectionResultView.frame.size.height-2;
    }
    newBottomFrame.origin.y -= bottomValue;
    [UIView animateWithDuration:0.5f animations:^{
        DirectionResultView.frame =newBottomFrame;
    }];
  
}
-(void)originalNavigation
{
    self.navigationController.navigationBarHidden = NO;
    toolBar.hidden=NO;
    mapview.delegate=self;
    [mapview removeAnnotations:[mapview annotations]];
    [mapview removeOverlays:mapview.overlays];
//    toolBar.barTintColor=[UIColor colorWithRed:(243/255.0f) green:(243/255.0f) blue:(243/255.0f) alpha:100];
    toolBar.translucent=NO;
    UIButton *btnName = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnName setFrame:CGRectMake(16, 7, 30, 30)];
    [btnName setBackgroundImage:[UIImage imageNamed:@"NearMe.png"] forState:UIControlStateNormal];
    [btnName addTarget:self action:@selector(CurrentLocateButt:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *locationItem = [[UIBarButtonItem alloc] initWithCustomView:btnName];
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIButton *INfoName = [UIButton buttonWithType:UIButtonTypeCustom];
    [INfoName setFrame:CGRectMake(273, 7, 30, 30)];
    [INfoName setBackgroundImage:[UIImage imageNamed:@"Info.png"] forState:UIControlStateNormal];
    [INfoName addTarget:self action:@selector(InfoButt:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *InfoItem = [[UIBarButtonItem alloc] initWithCustomView:INfoName];
    NSArray *itemsArray = [NSArray arrayWithObjects:locationItem, flexButton,InfoItem, nil];
    [toolBar setItems:itemsArray];
    self.navigationController.navigationBar.translucent = YES;
    //    self.navigationController.navigationBar.backgroundColor = [UIColor lightGrayColor];
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(243/255.0f) green:(243/255.0f)  blue:(243/255.0f)  alpha:50];
    UIButton *BAckButt = [UIButton buttonWithType:UIButtonTypeCustom];
    [BAckButt setBackgroundImage:[UIImage imageNamed:@"Direction.png"] forState:UIControlStateNormal];
    [BAckButt.layer setMasksToBounds:YES];
    BAckButt.frame=CGRectMake(3, 7, 30, 30);
    [BAckButt addTarget:self action:@selector(BackBUtt:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* BackBarButtItem = [[UIBarButtonItem alloc] initWithCustomView:BAckButt];
    [self.navigationItem setLeftBarButtonItem:BackBarButtItem];
    
    UIButton *RightButt = [UIButton buttonWithType:UIButtonTypeCustom];
    [RightButt setBackgroundImage:[UIImage imageNamed:@"BlackBack.png"] forState:UIControlStateNormal];
    [RightButt.layer setMasksToBounds:YES];
    RightButt.frame=CGRectMake(0, 0, 30, 30);
    [RightButt addTarget:self action:@selector(RightButt:) forControlEvents:UIControlEventTouchUpInside];
    RightBarButtItem = [[UIBarButtonItem alloc] initWithCustomView:RightButt];
    [self.navigationItem setRightBarButtonItem:RightBarButtItem];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    LocationSearchTable *locationSearch = [storyboard instantiateViewControllerWithIdentifier:@"LocationSearchTable"];
    resultSearchController = [[UISearchController alloc] initWithSearchResultsController:locationSearch];
    resultSearchController.searchResultsUpdater = locationSearch;
    UISearchBar *SearchBar= resultSearchController.searchBar;
    [SearchBar sizeToFit];
    SearchBar.placeholder = @"Search for places";
    self.navigationItem.titleView = resultSearchController.searchBar;
    resultSearchController.hidesNavigationBarDuringPresentation = NO;
    resultSearchController.dimsBackgroundDuringPresentation = YES;
    resultSearchController.delegate=self;
    self.definesPresentationContext = YES;
    locationSearch.mapView = mapview;
    locationSearch.handleMapSearchDelegate = self;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
}
#pragma mark - UINavigationBar Actions
- (void)willPresentSearchController:(UISearchController *)searchController
{
    [self.navigationItem setRightBarButtonItem:nil animated:true];
}

- (void)willDismissSearchController:(UISearchController *)searchController
{
    [self.navigationItem setRightBarButtonItem:RightBarButtItem animated:true];
    [self originalNavigation];
}

- (void)navigationBarButtonItemAction {
    float windowLayerSpeed = [UIApplication sharedApplication].keyWindow.layer.speed;
    [UIApplication sharedApplication].keyWindow.layer.speed = (windowLayerSpeed == 1.0) ? 0.1 : 1.0;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
}

-(void)RightButt:(UIButton *)sender
{
    SharedAppDelegate.FromDirection=@"";
    SharedAppDelegate.ToDirection=@"";
    UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *view =[story instantiateViewControllerWithIdentifier:@"ViewController"];
    [self.navigationController pushViewController:view animated:YES];
}

- (IBAction)clearBUtt:(id)sender {
    checkStartInfo=YES;
    //TopView
    CGRect newFrame = DirectionControlView.frame;
    newFrame.origin.y -=  newFrame.size.height;
    [UIView animateWithDuration:0.5f animations:^{
        DirectionControlView.frame=newFrame;
    }];
    Topvalue= newFrame.size.height;
    //BottomView
    CGRect BottomFrame = DirectionResultView.frame;
    BottomFrame.origin.y +=  BottomFrame.size.height+2;
    [UIView animateWithDuration:0.5f animations:^{
        DirectionResultView.frame=BottomFrame;
    }];
    bottomValue= BottomFrame.size.height;
    
    self.navigationController.navigationBarHidden =NO;
    [self originalNavigation];
    [mapview removeAnnotations:[mapview annotations]];
    [mapview removeOverlays:mapview.overlays];
}
- (IBAction)BacktoDirection:(id)sender
{
    UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DirectionView *view=[story instantiateViewControllerWithIdentifier:@"DirectionView"];
    view.ReFromAdd=[NSString stringWithFormat:@"%@",SharedAppDelegate.FromDirection];
    view.ReToAdd=[NSString stringWithFormat:@"%@",SharedAppDelegate.ToDirection];
    view.getBacktoDirection=@"iamback";
    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:view];
    [self presentViewController:navigationController animated:YES completion:nil];
}
-(void)BackBUtt:(UIButton *)sender
{
    if (newLocation.coordinate.latitude !=0)
    {
    UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DirectionView *view=[story instantiateViewControllerWithIdentifier:@"DirectionView"];
    view.currentDicAddress=[currentLocationAddress copy];
    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:view];
    [self presentViewController:navigationController animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Directions" message:@"Sorry ,your currnt location is not avilable .pls 'Debug Your Location' and Try Again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DirectionView *view=[story instantiateViewControllerWithIdentifier:@"DirectionView"];
        UINavigationController *navigationController =
        [[UINavigationController alloc] initWithRootViewController:view];
        [self presentViewController:navigationController animated:YES completion:nil];
    }
}

#pragma mark - UIToolBar Actions
-(void)StartButt:(UIButton*)sender
{
    checkStartInfo=YES;
    CGRect InfoFrame = InfoView.frame;
    InfoFrame.origin.y +=  InfoFrame.size.height;
    [UIView animateWithDuration:0.5f animations:^{
        InfoView.frame=InfoFrame;
    }];
    infoValue= InfoFrame.size.height;
    DirectionINdication=[NSString stringWithFormat:@"%@",getOverlineColor];
    //TopView
    CGRect newFrame = DirectionControlView.frame;
    newFrame.origin.y -=  newFrame.size.height;
    [UIView animateWithDuration:0.5f animations:^{
        DirectionControlView.frame=newFrame;
    }];
    Topvalue= newFrame.size.height;
    //BottomView
    CGRect BottomFrame = DirectionResultView.frame;
    BottomFrame.origin.y +=  BottomFrame.size.height+2;
    [UIView animateWithDuration:0.5f animations:^{
        DirectionResultView.frame=BottomFrame;
    }];
    bottomValue= BottomFrame.size.height;
//    self.navigationController.navigationBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(243/255.0f) green:(243/255.0f)  blue:(243/255.0f)  alpha:50];
    self.navigationItem.titleView = nil;
    UIButton *EndButt = [UIButton buttonWithType:UIButtonTypeCustom];
    [EndButt setTitle:@"End" forState:UIControlStateNormal];
    [EndButt setTitleColor:[UIColor colorWithRed:(0/255.0f) green:(122/255.0f) blue:(255/255.0f) alpha:100] forState:UIControlStateNormal];
    EndButt.frame=CGRectMake(3, 7, 50, 50);
    [EndButt addTarget:self action:@selector(endbutt:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* EndButtItem = [[UIBarButtonItem alloc] initWithCustomView:EndButt];
    [self.navigationItem setLeftBarButtonItem:EndButtItem];
    
    UIButton *OverViewButt = [UIButton buttonWithType:UIButtonTypeCustom];
    [OverViewButt setTitleColor:[UIColor colorWithRed:(0/255.0f) green:(122/255.0f) blue:(255/255.0f) alpha:100] forState:UIControlStateNormal];
    [OverViewButt setTitle:@"Overview" forState:UIControlStateNormal];
    OverViewButt.frame=CGRectMake(240, 7, 100, 100);
    [OverViewButt addTarget:self action:@selector(OverView:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *OverViewBarButtItem = [[UIBarButtonItem alloc] initWithCustomView:OverViewButt];
    [self.navigationItem setRightBarButtonItem:OverViewBarButtItem];
    
    toolBar.barTintColor=[UIColor colorWithRed:(243/255.0f) green:(243/255.0f) blue:(243/255.0f) alpha:100];
    toolBar.translucent=NO;
    UIButton *btnName = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnName setFrame:CGRectMake(16, 7, 30, 30)];
    [btnName setBackgroundImage:[UIImage imageNamed:@"NearMe.png"] forState:UIControlStateNormal];
    [btnName addTarget:self action:@selector(CurrentLocateButt:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *locationItem = [[UIBarButtonItem alloc] initWithCustomView:btnName];
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIButton *INfoName = [UIButton buttonWithType:UIButtonTypeCustom];
    [INfoName setFrame:CGRectMake(273, 7, 30, 30)];
    [INfoName setBackgroundImage:[UIImage imageNamed:@"Info.png"] forState:UIControlStateNormal];
    [INfoName addTarget:self action:@selector(InfoButt:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *InfoItem = [[UIBarButtonItem alloc] initWithCustomView:INfoName];
    NSArray *itemsArray = [NSArray arrayWithObjects:locationItem, flexButton,InfoItem, nil];
    [toolBar setItems:itemsArray];
    CollectionControlView.hidden=NO;
    CollectionValue=0;
    CGRect newCollectionFrame = CollectionControlView.frame;
    if (CollectionValue == newCollectionFrame.size.height)
    {
        CollectionValue =newCollectionFrame.size.height;
    }
    else
    {
        CollectionValue =0;
        newCollectionFrame.origin.y=64;
    }
    newCollectionFrame.origin.y -= CollectionValue;
    [UIView animateWithDuration:0.5f animations:^{
        CollectionControlView.frame =newCollectionFrame;
    }];
    AddCollectionView.delegate=self;
    AddCollectionView.dataSource=self;
    [AddCollectionView reloadData];
}
- (void)CurrentLocateButt:(UIButton*)sender
{
    mapview.showsUserLocation=YES;
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    MKCoordinateRegion region = MKCoordinateRegionMake(newLocation.coordinate, span);
    [mapview setRegion:region animated:true];
}
- (void)InfoButt:(UIButton *)sender
{
    if (checkStartInfo == NO)
    {
    if ([DirectionResultView isHidden] == NO)
    {
        if(checkVisible == NO)
        {
        CGRect BottomFrame = DirectionResultView.frame;
        BottomFrame.origin.y +=  BottomFrame.size.height+2;
        [UIView animateWithDuration:0.5f animations:^{
            DirectionResultView.frame=BottomFrame;
        }];
        bottomValue= BottomFrame.size.height;
        checkVisible=YES;
        }
    }
    if (CheckINFo == NO)
    {
        //InfoView
        InfoView.hidden=NO;
        CGRect newinfoFrame = InfoView.frame;
        if (infoValue == newinfoFrame.size.height)
        {
            infoValue =newinfoFrame.size.height;
        }
        else
        {
            infoValue =0;
            newinfoFrame.origin.y = toolBar.frame.origin.y-InfoView.frame.size.height-2;
        }
        newinfoFrame.origin.y -= infoValue;
        [UIView animateWithDuration:0.5f animations:^{
            InfoView.frame =newinfoFrame;
        }];
        CheckINFo=YES;
    }
    else if (CheckINFo == YES)
    {
        //InfoView
        CGRect InfoFrame = InfoView.frame;
        InfoFrame.origin.y +=  InfoFrame.size.height;
        [UIView animateWithDuration:0.5f animations:^{
            InfoView.frame=InfoFrame;
        }];
        infoValue= InfoFrame.size.height;
        CheckINFo=NO;
        if (checkVisible == YES)
        {
            DirectionResultView.hidden=NO;
            CGRect newBottomFrame = DirectionResultView.frame;
            if (bottomValue == newBottomFrame.size.height)
            {
                bottomValue =newBottomFrame.size.height+2;
            }
            else
            {
                bottomValue =0;
                newBottomFrame.origin.y=toolBar.frame.origin.y-DirectionResultView.frame.size.height-2;
            }
            newBottomFrame.origin.y -= bottomValue;
            [UIView animateWithDuration:0.5f animations:^{
                DirectionResultView.frame =newBottomFrame;
            }];
            checkVisible=NO;
        }
    }
    }
    else if(checkStartInfo == YES)
    {
        InfoView.hidden=NO;
        CGRect newinfoFrame = InfoView.frame;
        if (infoValue == newinfoFrame.size.height)
        {
            infoValue =newinfoFrame.size.height;
        }
        else
        {
            infoValue =0;
            newinfoFrame.origin.y = toolBar.frame.origin.y-InfoView.frame.size.height-2;
        }
        newinfoFrame.origin.y -= infoValue;
        [UIView animateWithDuration:0.5f animations:^{
            InfoView.frame =newinfoFrame;
        }];

    }
}

-(void)OverView:(UIButton *)sender
{
    CheckINFo=NO;
    checkVisible=NO;
    getOverlineColor=[NSString stringWithFormat:@"%@",DirectionINdication];
    [mapview addOverlay:route.polyline];
    MKMapRect zoomRect = MKMapRectNull;
    for (int idx = 0; idx < sizeof(route.polyline.points); idx++)
    {
        MKMapPoint annotationPoint = route.polyline.points[idx];
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
        if (MKMapRectIsNull(zoomRect)) {
            zoomRect = pointRect;
        } else {
            zoomRect = MKMapRectUnion(zoomRect, pointRect);
        }
    }
    zoomRect = MKMapRectInset(zoomRect, -70000, -70000);
    [mapview setVisibleMapRect:zoomRect animated:YES];
}
-(void)endbutt:(UIButton *)sender
{
    checkStartInfo=NO;
    getOverlineColor=[NSString stringWithFormat:@"%@",DirectionINdication];
    [mapview addOverlay:route.polyline];
    MKMapRect zoomRect = MKMapRectNull;
        MKMapPoint annotationPoint = route.polyline.points[0];
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
        if (MKMapRectIsNull(zoomRect)) {
            zoomRect = pointRect;
        } else {
            zoomRect = MKMapRectUnion(zoomRect, pointRect);
        }
    zoomRect = MKMapRectInset(zoomRect, -3000, -3000);
    [mapview setVisibleMapRect:zoomRect animated:YES];
      self.navigationController.navigationBarHidden =YES;
    CGRect CollFrame = CollectionControlView.frame;
    CollFrame.origin.y -=  CollFrame.size.height;
    [UIView animateWithDuration:0.5f animations:^{
        CollectionControlView.frame=CollFrame;
    }];
    CollectionValue= CollFrame.size.height;
    
    DirectionControlView.hidden=NO;
    CGRect newFrame = DirectionControlView.frame;
    if (Topvalue ==  newFrame.size.height)
    {
        Topvalue = newFrame.size.height;
    }
    else
    {
        Topvalue = 0;
        newFrame.origin.y=0;
    }
    newFrame.origin.y += Topvalue;
    [UIView animateWithDuration:0.5f animations:^{
        DirectionControlView.frame =newFrame;
    }];
    
    //BottomView
    DirectionResultView.hidden=NO;
    CGRect newBottomFrame = DirectionResultView.frame;
    if (bottomValue == newBottomFrame.size.height)
    {
        bottomValue =newBottomFrame.size.height+2;
    }
    else
    {
        bottomValue =0;
        newBottomFrame.origin.y=toolBar.frame.origin.y-DirectionResultView.frame.size.height-2;
    }
    newBottomFrame.origin.y -= bottomValue;
    [UIView animateWithDuration:0.5f animations:^{
        DirectionResultView.frame =newBottomFrame;
    }];
    toolBar.barTintColor=[UIColor blackColor];
    toolBar.translucent=NO;
    UIButton *btnName = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnName setFrame:CGRectMake(16, 7, 30, 30)];
    [btnName setBackgroundImage:[UIImage imageNamed:@"Near(white).png"] forState:UIControlStateNormal];
    [btnName addTarget:self action:@selector(CurrentLocateButt:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *locationItem = [[UIBarButtonItem alloc] initWithCustomView:btnName];
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIButton *INfoName = [UIButton buttonWithType:UIButtonTypeCustom];
    [INfoName setFrame:CGRectMake(273, 7, 30, 30)];
    [INfoName setBackgroundImage:[UIImage imageNamed:@"info(white).png"] forState:UIControlStateNormal];
    [INfoName addTarget:self action:@selector(InfoButt:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *InfoItem = [[UIBarButtonItem alloc] initWithCustomView:INfoName];
    
    StartButt = [UIButton buttonWithType:UIButtonTypeCustom];
    [StartButt setFrame:CGRectMake(140, 7, 50, 50)];
    [StartButt setTintColor:[UIColor whiteColor]];
    [StartButt setTitle:@"Start" forState:UIControlStateNormal];
    [StartButt addTarget:self action:@selector(StartButt:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *StartItem = [[UIBarButtonItem alloc] initWithCustomView:StartButt];
    
    NSArray *itemsArray = [NSArray arrayWithObjects:locationItem,flexButton,StartItem,flexButton,InfoItem, nil];
    [toolBar setItems:itemsArray];

}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index=   scrollView.contentOffset.x / scrollView.frame.size.width;
    pageCtrl.currentPage = index;
}
#pragma mark - Collection Actions
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    pageCtrl.numberOfPages=routeSteps.count;
    return routeSteps.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DirectionCollectionCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"DirectionCollectionCell" forIndexPath:indexPath];
    cell.AddressLbl.text=[NSString stringWithFormat:@"%@",[routeSteps objectAtIndex:indexPath.row]];
    MKRouteStep *POlyrout=route.steps[indexPath.row];
    mapview.delegate = self;
    getOverlineColor=@"zoom";
    [mapview addOverlay:POlyrout.polyline];
    [mapview setVisibleMapRect:POlyrout.polyline.boundingMapRect animated:NO];
    return cell;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = AddCollectionView.frame.size.width;
    pageCtrl.currentPage = AddCollectionView.contentOffset.x / pageWidth;
}
#pragma mark - Map Direction Control
- (IBAction)DirectionControl:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex)
    {
        case 0:
              getOverlineColor=@"drive";
            break;
        case 1:
            getOverlineColor=@"walking";
            break;
        case 2:
               getOverlineColor=@"transit";
            break;
        default:
            break;
    }
    [DirectionResultlbl setHidden:YES];
    [DirectonResultlbl2 setHidden:YES];
    [Time setHidden:YES];
    [Distance setHidden:YES];
    [detailsOutlet setHidden:YES];
    [IdeaButt setHidden:YES];
    [DirectionIndImg setHidden:YES];
    [NavigationActivity setHidden:NO];
    [DirectionActivity setHidden:NO];
    [self findDirectionsFrom:SourceItem to:DestinationItem];
}
//-(void)startNavigationWithStartPlacemark:(CLPlacemark *)startPlacemark endPlacemark:(CLPlacemark*)endPlacemark
//{
//    //0,创建起点
//    MKPlacemark * startMKPlacemark = [[MKPlacemark alloc]initWithPlacemark:startPlacemark];
//    //0,创建终点
//    MKPlacemark * endMKPlacemark = [[MKPlacemark alloc]initWithPlacemark:endPlacemark];
//    
//    //1,设置起点位置
//    MKMapItem * startItem = [[MKMapItem alloc]initWithPlacemark:startMKPlacemark];
//    //2,设置终点位置
//    MKMapItem * endItem = [[MKMapItem alloc]initWithPlacemark:endMKPlacemark];
//    //3,起点,终点数组
//    NSArray * items = @[startItem ,endItem];
//    
//    //4,设置地图的附加参数,是个字典
//    NSMutableDictionary * dictM = [NSMutableDictionary dictionary];
//    //导航模式(驾车,步行)
//    if ([self.pathType isEqualToString:@"D"]) {
//        dictM[MKLaunchOptionsDirectionsModeKey] = MKLaunchOptionsDirectionsModeDriving;
//    }
//    else if ([self.pathType isEqualToString:@"W"]) {
//        dictM[MKLaunchOptionsDirectionsModeKey] = MKLaunchOptionsDirectionsModeWalking;
//    }
//    else{
//        dictM[MKLaunchOptionsDirectionsModeKey] = MKLaunchOptionsDirectionsModeTransit;
//    }
//    //地图显示的模式
//    dictM[MKLaunchOptionsMapTypeKey] = MKMapTypeStandard;
//    
//    //只要调用MKMapItem的open方法,就可以调用系统自带地图的导航
//    //Items:告诉系统地图从哪到哪
//    //launchOptions:启动地图APP参数(导航的模式/是否需要先交通状况/地图的模式/..)
//    [MKMapItem openMapsWithItems:items launchOptions:dictM];
//}
#pragma mark - Map Direction Actions
- (void)findDirectionFromAppleServer
{
    CLGeocoder *geocode=[[CLGeocoder alloc]init];
    [geocode geocodeAddressString:SharedAppDelegate.FromDirection completionHandler:^(NSArray *placemark , NSError *error)
     {
         CLPlacemark * Fromplace = [placemark objectAtIndex:0];
         CLLocationCoordinate2D FromDic=Fromplace.location.coordinate;
         MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
         annotation.coordinate = Fromplace.location.coordinate;
         annotation.title = Fromplace.name;
         sourceTitle=[NSString stringWithFormat:@"%@",annotation.title];
         annotation.subtitle = [NSString stringWithFormat:@"%@ %@",
                                (Fromplace.locality == nil ? @"" : Fromplace.locality),
                                (Fromplace.administrativeArea == nil ? @"" : Fromplace.administrativeArea)
                                ];
         [mapview addAnnotation:annotation];
         [geocode geocodeAddressString:SharedAppDelegate.ToDirection completionHandler:^(NSArray *placemark , NSError *error)
          {
              CLPlacemark * Toplace = [placemark objectAtIndex:0];
              CLLocationCoordinate2D ToDic=Toplace.location.coordinate;
              MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
              annotation.coordinate = Toplace.location.coordinate;
              annotation.title = Toplace.name;
              DesTitle=[NSString stringWithFormat:@"%@",annotation.title];
              annotation.subtitle = [NSString stringWithFormat:@"%@ %@",
                                     (Toplace.locality == nil ? @"" : Toplace.locality),
                                     (Toplace.administrativeArea == nil ? @"" : Toplace.administrativeArea)
                                     ];
              [mapview addAnnotation:annotation];
              MKPlacemark *First=[[MKPlacemark alloc]initWithCoordinate:FromDic addressDictionary:nil];
              SourceItem=[[MKMapItem alloc]initWithPlacemark:First];
              SourceItem.name=Toplace.name;
              MKPlacemark *Second=[[MKPlacemark alloc]initWithCoordinate:ToDic addressDictionary:nil];
              DestinationItem=[[MKMapItem alloc]initWithPlacemark:Second];
              DestinationItem.name=Fromplace.name;
              getOverlineColor=@"drive";
              [self findDirectionsFrom:SourceItem to:DestinationItem];
          }];
     }];
}

- (void)findDirectionsFrom:(MKMapItem *)source
                        to:(MKMapItem *)destination
{
    //[self.mapView setUserTrackingMode:MKUserTrackingModeNone];
    MKDirectionsRequest *request= [[MKDirectionsRequest alloc] init];
    request.source = source;
    request.destination = destination;
    if ([getOverlineColor isEqualToString:@"drive"])
    {
     request.transportType=MKDirectionsTransportTypeAutomobile;
    }
    else  if ([getOverlineColor isEqualToString:@"walking"])
    {
    request.transportType=MKDirectionsTransportTypeWalking;
    }
    else  if ([getOverlineColor isEqualToString:@"transit"])
    {
    request.transportType=MKDirectionsTransportTypeTransit;
    }
    request.requestsAlternateRoutes = NO;
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    __block typeof(self) weakSelf = self;
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error)
    {
        [NavigationActivity setHidden:YES];
         [DirectionActivity setHidden:YES];
         if (error) {
             [mapview removeOverlays:mapview.overlays];
             if ([getOverlineColor isEqualToString:@"drive"])
             {
                 [DirectionIndImg setImage:[UIImage imageNamed:@"Car(white).png"]];
             }
             else  if ([getOverlineColor isEqualToString:@"walking"])
             {
                 [DirectionIndImg setImage:[UIImage imageNamed:@"Walk(white).png"]];
             }
             else  if ([getOverlineColor isEqualToString:@"transit"])
             {
                 [DirectionIndImg setImage:[UIImage imageNamed:@"Train(white).png"]];
             }
             [DirectionResultlbl setHidden:NO];
             [DirectonResultlbl2 setHidden:NO];
             [IdeaButt setHidden:NO];
             [Time setHidden:YES];
             [Distance setHidden:YES];
             [detailsOutlet setHidden:YES];
             [DirectionIndImg setHidden:NO];
             NSLog(@"Error is %@",error);
             [StartButt setEnabled:NO];
         }
         else
         {
            [StartButt setEnabled:YES];
             [DirectionResultlbl setHidden:YES];
             [DirectonResultlbl2 setHidden:YES];
             [IdeaButt setHidden:YES];
            [mapview removeOverlays:mapview.overlays];
             [weakSelf didLoadedDirections:response];
         }
     }];
}
- (void)didLoadedDirections:(MKDirectionsResponse *)response
{
    route = [response.routes firstObject];
    [mapview addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
    NSMutableArray *_steps = [NSMutableArray arrayWithCapacity:[route.steps count]];
    for (MKRouteStep *step in route.steps) {
        [_steps addObject:[step instructions]];
    }
    routeSteps = _steps;
    NSString *MIle=[NSString stringWithFormat:@"%f", route.distance/1609.344];
    NSString *KM=[NSString stringWithFormat:@"%0.1f",[MIle floatValue]/0.62137];
    NSString *routeMInute=[NSString stringWithFormat:@"%0.f",route.expectedTravelTime/60];
    NSString *routeHours=[NSString stringWithFormat:@"%0.2f hours",[routeMInute floatValue]*0.016666667];
    [Time setHidden:NO];
    [Distance setHidden:NO];
    [detailsOutlet setHidden:NO];
    [DirectionIndImg setHidden:NO];
    if ([getOverlineColor isEqualToString:@"drive"])
    {
        [DirectionIndImg setImage:[UIImage imageNamed:@"Car(white).png"]];
    }
    else  if ([getOverlineColor isEqualToString:@"walking"])
    {
        [DirectionIndImg setImage:[UIImage imageNamed:@"Walk(white).png"]];
    }
    else  if ([getOverlineColor isEqualToString:@"transit"])
    {
        [DirectionIndImg setImage:[UIImage imageNamed:@"Train(white).png"]];
    }

    //Set visible map rect
    if (CheckZoom.length != 0)
    {
        Time.text=[NSString stringWithFormat:@"-- Minutes"];
        Distance.text=[NSString stringWithFormat:@"%@  KM ~ %@",DistanceStep,AddressStep];
        MKRouteStep *POlyrout=route.steps[mapRectVAlue];
        mapview.delegate = self;
        [mapview addOverlay:POlyrout.polyline];
        [mapview setVisibleMapRect:POlyrout.polyline.boundingMapRect animated:NO];
        CheckZoom=@"";
    }
    else
    {
    Time.text=[NSString stringWithFormat:@"%@ Minutes",routeMInute];
    Distance.text=[NSString stringWithFormat:@"%@  KM ~ %@",KM,[_steps objectAtIndex:0]];
    MKMapRect zoomRect = MKMapRectNull;
    for (int idx = 0; idx < sizeof(route.polyline.points); idx++)
    {
        MKMapPoint annotationPoint = route.polyline.points[idx];
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
        if (MKMapRectIsNull(zoomRect)) {
            zoomRect = pointRect;
        } else {
            zoomRect = MKMapRectUnion(zoomRect, pointRect);
        }
    }
    zoomRect = MKMapRectInset(zoomRect, -3000, -3000);
    [mapview setVisibleMapRect:zoomRect animated:YES];
    }
}
-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *polylineRender;
    if ([getOverlineColor isEqualToString:@"drive"])
    {
        polylineRender = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        polylineRender.lineWidth = 3.0f;
        polylineRender.strokeColor = [UIColor orangeColor];
    }
   else if ([getOverlineColor isEqualToString:@"walking"])
    {
        polylineRender = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        polylineRender.lineWidth = 3.0f;
        polylineRender.strokeColor = [UIColor blueColor];
    }
   else if ([getOverlineColor isEqualToString:@"transit"])
   {
       polylineRender = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
       polylineRender.lineWidth = 3.0f;
       polylineRender.strokeColor = [UIColor redColor];
   }
   else if ([getOverlineColor isEqualToString:@"zoom"])
   {
       polylineRender = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
       polylineRender.lineWidth = 3.0f;
       polylineRender.strokeColor = [UIColor blackColor];
   }
    return polylineRender;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
//{
//    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
//        [locationManager requestLocation];
//    }
//}
//- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
//{
//    NSLog(@"error: %@", error);
//}
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_6_0)
{
    newLocation = [locations objectAtIndex:0];
//    NSLog(@"%f",newLocation.coordinate.latitude);
    if (newLocation != nil)
    {
        if(checkLoction == NO)
        {
        NSLog(@"%f",newLocation.coordinate.latitude);
        NSLog(@"%f",newLocation.coordinate.longitude);
        CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
        [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            NSLog(@"%@",[placemark.addressDictionary objectForKey:@"FormattedAddressLines"]);
//            currentLocationAddress=[NSString stringWithFormat:@"%@",[placemark.addressDictionary objectForKey:@"FormattedAddressLines"]];
            currentLocationAddress=placemark.addressDictionary;
        }];
            checkLoction=YES;
        }
    }

}
- (void)dropPinZoomIn:(MKPlacemark *)placemark
{
     [mapview removeAnnotations:[mapview annotations]];
    // cache the pin
    selectedPin = placemark;
    resultSearchController.searchBar.text=placemark.name;
    // clear existing pins
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = placemark.coordinate;
    annotation.title = placemark.name;
    annotation.subtitle = [NSString stringWithFormat:@"%@ %@",
                           (placemark.locality == nil ? @"" : placemark.locality),
                           (placemark.administrativeArea == nil ? @"" : placemark.administrativeArea)
                           ];
    [mapview addAnnotation:annotation];
    MKCoordinateSpan span = MKCoordinateSpanMake(0.00, 0.00);
    MKCoordinateRegion region = MKCoordinateRegionMake(placemark.coordinate, span);
    [mapview setRegion:region animated:true];
    toolBar.barTintColor=[UIColor colorWithRed:(243/255.0f) green:(243/255.0f) blue:(243/255.0f) alpha:100];
    toolBar.translucent=NO;
    UIButton *btnName = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnName setFrame:CGRectMake(16, 7, 30, 30)];
    [btnName setBackgroundImage:[UIImage imageNamed:@"NearMe.png"] forState:UIControlStateNormal];
    [btnName addTarget:self action:@selector(CurrentLocateButt:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *locationItem = [[UIBarButtonItem alloc] initWithCustomView:btnName];
    UIButton *Panromabtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [Panromabtn setFrame:CGRectMake(140, 7, 30, 30)];
    [Panromabtn setBackgroundImage:[UIImage imageNamed:@"StreetView.png"] forState:UIControlStateNormal];
    [Panromabtn addTarget:self action:@selector(ActofPanroma:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *PanromaItem = [[UIBarButtonItem alloc] initWithCustomView:Panromabtn];
    UIButton *ThreeDbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ThreeDbtn setFrame:CGRectMake(180, 7, 30, 30)];
    [ThreeDbtn setBackgroundImage:[UIImage imageNamed:@"3DIcon.png"] forState:UIControlStateNormal];
    [ThreeDbtn addTarget:self action:@selector(ActofThreeD:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *ThreeDItem = [[UIBarButtonItem alloc] initWithCustomView:ThreeDbtn];
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIButton *INfoName = [UIButton buttonWithType:UIButtonTypeCustom];
    [INfoName setFrame:CGRectMake(273, 7, 30, 30)];
    [INfoName setBackgroundImage:[UIImage imageNamed:@"Info.png"] forState:UIControlStateNormal];
    [INfoName addTarget:self action:@selector(InfoButt:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *InfoItem = [[UIBarButtonItem alloc] initWithCustomView:INfoName];
    NSArray *itemsArray = [NSArray arrayWithObjects:locationItem,flexButton ,PanromaItem,flexButton,ThreeDItem,flexButton,InfoItem, nil];
    [toolBar setItems:itemsArray];
}
-(void)ActofThreeD:(UIButton *)sender
{
    UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FlyOverView *view=[story instantiateViewControllerWithIdentifier:@"FlyOverView"];
    view.Flylat=[NSString stringWithFormat:@"%f",selectedPin.coordinate.latitude];
    view.Flylong=[NSString stringWithFormat:@"%f",selectedPin.coordinate.longitude];
    view.AddressName=[NSString stringWithFormat:@"%@",selectedPin.name];
    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:view];
    [self presentViewController:navigationController animated:YES completion:nil];
}
-(void)ActofPanroma:(UIButton *)sender
{
    UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    StreetView *view=[story instantiateViewControllerWithIdentifier:@"StreetView"];
    view.LatValue=[NSString stringWithFormat:@"%f",selectedPin.coordinate.latitude];
    view.LongValue=[NSString stringWithFormat:@"%f",selectedPin.coordinate.longitude];
    view.CountryName=[NSString stringWithFormat:@"%@",selectedPin.name];
    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:view];
    [self presentViewController:navigationController animated:YES completion:nil];
}
//- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
//{
//    if ([annotation isKindOfClass:[MKUserLocation class]]) {
//        //return nil so map view draws "blue dot" for standard user location
//        return nil;
//    }
//    
//    static NSString *reuseId = @"pin";
//    
//    MKPinAnnotationView *pinView = (MKPinAnnotationView *) [mapview dequeueReusableAnnotationViewWithIdentifier:reuseId];
//    if (pinView == nil) {
//        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
//        pinView.enabled = YES;
//        pinView.canShowCallout = YES;
//        pinView.tintColor = [UIColor orangeColor];
//    } else {
//        pinView.annotation = annotation;
//    }
//    
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//    [button setBackgroundImage:[UIImage imageNamed:@"car"]
//                      forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(getDirections) forControlEvents:UIControlEventTouchUpInside];
//    pinView.leftCalloutAccessoryView = button;
//    
//    return pinView;
//}
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
                //return nil so map view draws "blue dot" for standard user location
                return nil;
    }
   static NSString *reuseId = @"pin";
    MKPinAnnotationView *aView=(MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseId ];
//    if (aView==nil) {
    aView=[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:reuseId];
    if ([sourceTitle isEqualToString:annotation.title])
    {
          aView.pinColor = MKPinAnnotationColorGreen;
    }
    else  if ([DesTitle isEqualToString:annotation.title])
    {
          aView.pinColor = MKPinAnnotationColorRed;
    }
    else
    {
          aView.pinColor = MKPinAnnotationColorGreen;
    }
//        aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//        //        aView.image=[UIImage imageNamed:@"arrow"];
        aView.animatesDrop=TRUE;
        aView.canShowCallout = YES;
        aView.calloutOffset = CGPointMake(-5, 5);
//    }
    
    return aView;
}
#pragma mark - Map Details
- (IBAction)DetailsButt:(id)sender
{
    UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailsViewController *view=[story instantiateViewControllerWithIdentifier:@"DetailsViewController"];
    view.routesDetails=route;
    view.getRouteINfo=getOverlineColor;
    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:view];
    [self presentViewController:navigationController animated:YES completion:nil];
}
#pragma mark - Map Type
- (IBAction)MapTypeControlButt:(UISegmentedControl *)sender
{
    if (checkStartInfo == YES)
    {
        switch (sender.selectedSegmentIndex) {
            case 0:
                [mapview setMapType:MKMapTypeStandard];
                break;
            case 1:
                [mapview setMapType:MKMapTypeHybrid];
                break;
            case 2:
                [mapview setMapType:MKMapTypeSatellite];
                break;
            default:
                break;
        }
        CGRect InfoFrame = InfoView.frame;
        InfoFrame.origin.y += InfoFrame.size.height;
        [UIView animateWithDuration:0.5f animations:^{
            InfoView.frame=InfoFrame;
        }];
        infoValue= InfoFrame.size.height;
    }
    else if(checkStartInfo == NO)
    {
    switch (sender.selectedSegmentIndex) {
        case 0:
            [mapview setMapType:MKMapTypeStandard];
            break;
        case 1:
            [mapview setMapType:MKMapTypeHybrid];
            break;
        case 2:
            [mapview setMapType:MKMapTypeSatellite];
            break;
        default:
            break;
    }
    CGRect InfoFrame = InfoView.frame;
    InfoFrame.origin.y += InfoFrame.size.height;
    [UIView animateWithDuration:0.5f animations:^{
        InfoView.frame=InfoFrame;
    }];
    infoValue= InfoFrame.size.height;
    CheckINFo=NO;
    if (checkVisible == YES)
    {
        DirectionResultView.hidden=NO;
        CGRect newBottomFrame = DirectionResultView.frame;
        if (bottomValue == newBottomFrame.size.height)
        {
            bottomValue =newBottomFrame.size.height+2;
        }
        else
        {
            bottomValue =0;
            newBottomFrame.origin.y=toolBar.frame.origin.y-DirectionResultView.frame.size.height-2;
        }
        newBottomFrame.origin.y -= bottomValue;
        [UIView animateWithDuration:0.5f animations:^{
            DirectionResultView.frame =newBottomFrame;
        }];
        checkVisible=NO;
    }
    }
}

- (IBAction)ActionOFIdea:(id)sender
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Directions" message:@"If you want to see this location in default map , click 'Show' button." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Show", nil];
    [alert show];
    alert.tag=10;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10)
    {
        if (buttonIndex == 1)
        {
            NSMutableDictionary * dictM = [NSMutableDictionary dictionary];
            if ([getOverlineColor isEqualToString:@"drive"])
            {
                dictM[MKLaunchOptionsDirectionsModeKey] = MKLaunchOptionsDirectionsModeDriving;
            }
            else if ([getOverlineColor isEqualToString:@"walking"])
            {
                dictM[MKLaunchOptionsDirectionsModeKey] = MKLaunchOptionsDirectionsModeWalking;
            }
            else if ([getOverlineColor isEqualToString:@"transit"])
            {
                dictM[MKLaunchOptionsDirectionsModeKey] = MKLaunchOptionsDirectionsModeTransit;
            }
            dictM[MKLaunchOptionsMapTypeKey] = MKMapTypeStandard;
            NSArray * items = @[SourceItem ,DestinationItem];
            [MKMapItem openMapsWithItems:items launchOptions:dictM];
        }
    }
}

@end

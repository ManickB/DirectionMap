//
//  FlyOverView.m
//  MapTutorial
//
//  Created by ViVID on 10/5/16.
//  Copyright © 2016 ViVID. All rights reserved.
//

#import "FlyOverView.h"
@import MapKit;

@interface FlyOverView ()

@end

@implementation FlyOverView
@synthesize mapview,Flylat,Flylong,AddressName;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.title=[NSString stringWithFormat:@"%@",AddressName];
     UIButton *BAckButt = [UIButton buttonWithType:UIButtonTypeCustom];
    [BAckButt setTitle:@"Done" forState:UIControlStateNormal];
    [BAckButt setTitleColor:[UIColor colorWithRed:(0/255.0f) green:(122/255.0f) blue:(255/255.0f) alpha:100] forState:UIControlStateNormal];
    [BAckButt.layer setMasksToBounds:YES];
    BAckButt.frame=CGRectMake(8, 22, 50, 50);
    [BAckButt addTarget:self action:@selector(DismissAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* BackBarButtItem = [[UIBarButtonItem alloc] initWithCustomView:BAckButt];
    [self.navigationItem setLeftBarButtonItem:BackBarButtItem];
     UIButton * RightButt = [UIButton buttonWithType:UIButtonTypeCustom];
    [RightButt setTitle:@"MapType" forState:UIControlStateNormal];
    [RightButt setTitleColor:[UIColor colorWithRed:(0/255.0f) green:(122/255.0f) blue:(255/255.0f) alpha:100] forState:UIControlStateNormal];
    [RightButt.layer setMasksToBounds:YES];
    RightButt.frame=CGRectMake(240, 22, 90, 90);
    [RightButt addTarget:self action:@selector(ActionOfRightButt:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* RightBarButtItem = [[UIBarButtonItem alloc] initWithCustomView:RightButt];
    [self.navigationItem setRightBarButtonItem:RightBarButtItem];
    CLLocationDistance distance=100;
    CGFloat pitch = 30;
    CLLocationDirection heading=90.0;
    mapview.mapType=MKMapTypeHybridFlyover;
    CLLocationCoordinate2D coordinate=CLLocationCoordinate2DMake([Flylat floatValue],[Flylong floatValue]);
    
    MKMapCamera *camera = [MKMapCamera cameraLookingAtCenterCoordinate:coordinate fromDistance:distance pitch:pitch heading:heading];
    
    mapview.camera=camera;
    mapview.delegate=self;
}
-(void)ActionOfRightButt:(UIButton *)sender
{
    UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:@"MapType" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"SatelliteFlyover",@"HybridFlyover",nil];
    [action showInView:self.view];
    action.tag=10;
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 10)
    {
        if (buttonIndex == 0)
        {
            mapview.mapType=MKMapTypeSatelliteFlyover;
        }
       else if (buttonIndex == 1)
        {
            mapview.mapType=MKMapTypeHybridFlyover;
        }
    }
}
-(void)DismissAction:(UIButton *)sender
{
    SharedAppdelegate.FromDirection=@"";
    SharedAppdelegate.ToDirection=@"";
    SharedAppdelegate.CheckStreetDirection=[NSString stringWithFormat:@"%@",AddressName];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

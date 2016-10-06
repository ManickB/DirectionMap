//
//  StreetView.m
//  MapTutorial
//
//  Created by ViVID on 9/14/16.
//  Copyright © 2016 ViVID. All rights reserved.
//

#import "StreetView.h"
@import GoogleMaps;
@interface StreetView ()

@end

@implementation StreetView
@synthesize LatValue,LongValue,CountryName;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=[NSString stringWithFormat:@"%@",CountryName];
    [self.navigationController setNavigationBarHidden:NO];
   
    UIButton *BAckButt = [UIButton buttonWithType:UIButtonTypeCustom];
    [BAckButt setTitle:@"Done" forState:UIControlStateNormal];
    [BAckButt setTitleColor:[UIColor colorWithRed:(0/255.0f) green:(122/255.0f) blue:(255/255.0f) alpha:100] forState:UIControlStateNormal];
    [BAckButt.layer setMasksToBounds:YES];
    BAckButt.frame=CGRectMake(8, 22, 50, 50);
    [BAckButt addTarget:self action:@selector(DismissAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* BackBarButtItem = [[UIBarButtonItem alloc] initWithCustomView:BAckButt];
    [self.navigationItem setLeftBarButtonItem:BackBarButtItem];

    NSLog(@"Lat:%@,Long:%@",LatValue,LongValue);
    CLLocationCoordinate2D panoramaNears = {[LatValue floatValue],[LongValue floatValue]};
    
    
     GMSPanoramaView *panoView =[GMSPanoramaView panoramaWithFrame:CGRectZero
                        nearCoordinate:panoramaNears];
    panoView.delegate=self;
    self.view=panoView;
    // Do any additional setup after loading the view.
}
-(void)panoramaViewDidStartRendering:(GMSPanoramaView *)panoramaView
{
  NSLog(@"start");
}
-(void)panoramaViewDidFinishRendering:(GMSPanoramaView *)panoramaView
{
    NSLog(@"finish");
}
- (void) panoramaView:      (GMSPanoramaView *)     view
    didMoveToPanorama:      (GMSPanorama *_Nullable)    panorama
{
    //If the panorama.panoramaID NSString is null, then the panorama could not be loaded.
    NSLog(@"%@",panorama.panoramaID);
    
}
- (void) panoramaView:      (GMSPanoramaView *)     view
                error:      (NSError *)     error
 onMoveNearCoordinate:       (CLLocationCoordinate2D)    coordinate
{
    NSLog(@"%@",error);
    NSLog(@"%f",coordinate.latitude);
    NSLog(@"%f",coordinate.longitude);
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Sorry, your location is not get a PanromaView" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    alert.tag=10;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex

{
    SharedAppDelegate.CheckStreetDirection=[NSString stringWithFormat:@"%@",CountryName];
    [self dismissViewControllerAnimated:YES completion:nil];

}

-(void)DismissAction:(UIButton *)sender
{
    SharedAppDelegate.CheckStreetDirection=[NSString stringWithFormat:@"%@",CountryName];
    [self dismissViewControllerAnimated:YES completion:nil];
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

@end

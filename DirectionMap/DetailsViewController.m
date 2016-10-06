//
//  DetailsViewController.m
//  MapTutorial
//
//  Created by ViVID on 9/30/16.
//  Copyright © 2016 ViVID. All rights reserved.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController
@synthesize routesDetails,DetailsTable,getRouteINfo,DirectionIndicateImg;

- (void)viewDidLoad {
    [super viewDidLoad];
    [DetailsTable registerNib:[UINib nibWithNibName:@"DetailViewCell" bundle:nil] forCellReuseIdentifier:@"DetailViewCell"];
}
-(void)viewWillAppear:(BOOL)animated
{
    if ([getRouteINfo isEqualToString:@"drive"])
    {
        [DirectionIndicateImg setImage:[UIImage imageNamed:@"Car(G).png"]];
    }
    else if ([getRouteINfo isEqualToString:@"walking"])
    {
        [DirectionIndicateImg setImage:[UIImage imageNamed:@"walk(G).png"]];
    }
    else if ([getRouteINfo isEqualToString:@"transit"])
    {
         [DirectionIndicateImg setImage:[UIImage imageNamed:@"Train(G).png"]];
    }
    getDistanceArr=[[NSMutableArray alloc]init];
    getInstructionArr=[[NSMutableArray alloc]init];
    for(MKRouteStep *step in routesDetails.steps)
    {
        NSString *Mile=[NSString stringWithFormat:@"%f",step.distance/1609.344];
        [getDistanceArr addObject:[NSString stringWithFormat:@"%0.1f",[Mile floatValue]/0.62137]];
        [getInstructionArr addObject:step.instructions];
        NSLog(@"%@",step.polyline);
    }
    DetailsTable.delegate=self;
    DetailsTable.dataSource=self;
    [DetailsTable reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return getInstructionArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailViewCell" forIndexPath:indexPath];
    cell.InstructionLab.text=[getInstructionArr objectAtIndex:indexPath.row];
    cell.DistanceLab.text=[getDistanceArr objectAtIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MapKitView *view=[story instantiateViewControllerWithIdentifier:@"MapKitView"];
    view.mapRectVAlue=indexPath.row;
    view.CheckZoom=@"Ok";
    view.DistanceStep=[getDistanceArr objectAtIndex:indexPath.row];
    view.AddressStep=[getInstructionArr objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:view animated:YES];
}
- (IBAction)backButt:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
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

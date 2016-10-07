//
//  AppDelegate.h
//  DirectionMap
//
//  Created by ViVID on 10/5/16.
//  Copyright © 2016 ViVID. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    //Address
    NSString * FromDirection;
    NSString * ToDirection;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString * FromDirection;
@property (strong, nonatomic) NSString * ToDirection;
@property (strong, nonatomic) NSString * CheckStreetDirection;
@end


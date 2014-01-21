//
//  ViewController.m
//  FacebookList
//
//  Created by 주리 on 2014. 1. 21..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "ViewController.h"
#import <FacebookSDK/FacebookSDK.h>


@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic)ACAccount *facebookAccount;
@property (strong, nonatomic)NSArray *data;

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end

@implementation ViewController
{
    NSArray *friends;
}


-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    FBRequest* friendsRequest = [FBRequest requestForMyFriends];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error) {
        friends = [result objectForKey:@"name"];
        [self.table reloadData];
    }];
}

-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    friends = nil;
    [self.table reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [friends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LIST_CELL" forIndexPath:indexPath];
    
    NSDictionary<FBGraphUser> *friendList;
    friendList = friends[indexPath.row];
    
    
    cell.textLabel.text = friendList.name;
    
    return cell;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    friends = [[NSArray alloc]init];
    
    
    FBLoginView *loginView = [[FBLoginView alloc] init];
    // Align the button in the center horizontally
    loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width / 2)), 50);
    loginView.delegate = self;
    [self.view addSubview:loginView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  ViewController.m
//  FacebookList
//
//  Created by 주리 on 2014. 1. 21..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "ViewController.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <FacebookSDK/FacebookSDK.h>

#define FACEBOOK_APPID @"1405220066393435"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic)ACAccount *facebookAccount;
@property (strong, nonatomic)NSArray *data;

@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation ViewController

- (void)showFriendsList
{
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    ACAccountStore *store = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    NSDictionary *options = @{ACFacebookAppIdKey:FACEBOOK_APPID,
                              ACFacebookPermissionsKey:@[@"read_friendlists"],
                              ACFacebookAudienceKey:ACFacebookAudienceEveryone};
    [store requestAccessToAccountsWithType:accountType options:options completion:^(BOOL granted, NSError *error) {
        if (error) {
            NSLog(@"Error:%@", error);
        }
        if (granted) {
            NSLog(@"권한 승인 성공");
            NSArray *accountList = [store accountsWithAccountType:accountType];
            self.facebookAccount = [accountList lastObject];
            
            [self requestFriendsList];
        }
        else
        {
            NSLog(@"권한 승인 실패");
        }
    }];
}

- (void)requestFriendsList
{
    NSString *urlStr = @"https://graph.facebook.com/me/friends";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSDictionary *params = nil;
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodGET URL:url parameters:params];
    request.account = self.facebookAccount;
    
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (error != nil) {
            NSLog(@"Error : %@", error);
            return;
        }
        
        __autoreleasing NSError *parseError;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&parseError];
        
        self.data = result[@"data"];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.table reloadData];
        }];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LIST_CELL"];
    NSDictionary *one = self.data[indexPath.row];
    
    NSString *contents;
    if (one[@"name"]) {
        contents = [NSString stringWithFormat:@"%@", one[@"name"]];
    }
    else
    {
        contents = one[@"story"];
        cell.indentationLevel = 2;
    }
    
    cell.self.textLabel.text = contents;
    return cell;

}

- (void)viewWillAppear:(BOOL)animated
{
    [self showFriendsList];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

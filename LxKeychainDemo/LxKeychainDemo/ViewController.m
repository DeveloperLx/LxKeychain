//
//  ViewController.m
//  LxKeychainDemo
//

#import "ViewController.h"
#import "LxKeychain.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"SandBox = %@", NSHomeDirectory());  //
    
    NSLog(@"savedUsernameArray = %@", [LxKeychain savedUsernameArray]); //
    
    [LxKeychain insertOrUpdatePairsOfUsername:@"username1" password:@"password1"];
    [LxKeychain insertOrUpdatePairsOfUsername:@"username2" password:@"password2"];
    [LxKeychain insertOrUpdatePairsOfUsername:@"username3" password:@"password3"];
    [LxKeychain insertOrUpdatePairsOfUsername:@"username1" password:@"password4"];
    [LxKeychain cleanPasswordForUsername:@"username2"];
    [LxKeychain deletePairsByUsername:@"username3"];
    NSLog(@"savedUsernameArray = %@", [LxKeychain savedUsernameArray]); //
    NSLog(@"username1 password: %@", [LxKeychain passwordForUsername:@"username1"]); //
    NSLog(@"username1's password %@ password1", [LxKeychain password:@"password1" isCorrectToUsername:@"username1"]?@"is":@"is not"); //
    NSLog(@"username1's password %@ password4", [LxKeychain password:@"password4" isCorrectToUsername:@"username1"]?@"is":@"is not"); //
    NSLog(@"lastestUpdatedUsername = %@", [LxKeychain lastestUpdatedUsername]);    //
}

@end

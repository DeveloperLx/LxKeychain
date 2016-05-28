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
    
    static NSString * const YourSaveKey = @"Your save key!";
    NSLog(@"Your saved string: %@", [LxKeychain fetchDataOfService:YourSaveKey]);  //
    [LxKeychain saveData:@"Here is What you want to save forever!" forService:YourSaveKey];
    
    NSLog(@"Your LxKeychain device unique identifer is %@", [LxKeychain deviceUniqueIdentifer]);   //
    NSLog(@"Your keychain access group is %@", [LxKeychain accessGroupName]);   //
}

@end

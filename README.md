# LxKeychain
Manage your username and password for iOS and OS X platform. Highly encryption and won't be lose even you uninstall your app.
Installation
------------
  You only need drag LxKeychain.h and LxKeychain.m to your project.
Podfile
------------
    pod 'LxKeychain', '~> 1.0.0'
Support
------------
  Minimum support iOS version: iOS 6.0
Usage
--------------

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

    // You can try to run once, then uninstall your app, then build and run it again. You will see shocking phenomena！
License
-----------
LxKeychain is available under the Apache License 2.0. See the LICENSE file for more info.

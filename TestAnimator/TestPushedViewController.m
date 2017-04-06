//
//  TestPushedViewController.m
//  TestAnimator
//
//  Created by tomfriwel on 06/04/2017.
//  Copyright © 2017 tomfriwel. All rights reserved.
//

#import "TestPushedViewController.h"

@interface TestPushedViewController ()

@end

@implementation TestPushedViewController

-(instancetype)init {
    self = [super init];
    
    UITextField *text = [[UITextField alloc] init];
    [self.view addSubview:text];
    [text becomeFirstResponder];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

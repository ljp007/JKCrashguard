//
//  ViewController.m
//  JKCushionCrash
//
//  Created by 林 on 2022/12/12.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray * list = [NSArray array];
    [list objectAtIndex:1];
    
    NSArray * list0 = @[@(1),@(5)];
    [list0 objectAtIndex:3];
    [list0 objectAtIndexedSubscript:0];
    
    NSArray * list1 = [NSArray arrayWithObject:@(0)];
    [list1 objectAtIndex:0];
    
    NSArray * list2 = [NSArray arrayWithObjects:@(0),@(1), nil];
    
    NSMutableArray * list3 = [NSMutableArray array];
    [list3 objectAtIndex:1];
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:@(1) forKey:nil];
    
    NSMutableSet * set = [NSMutableSet set];
    [set addObject:nil];
    [set removeObject:nil];
    
    NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc] initWithString:nil];
    [attributeString insertAttributedString:nil atIndex:0];
    
    NSMutableString * mulString = [NSMutableString stringWithString:@"123"];
    [mulString substringToIndex:6];
    NSLog(@"%@",mulString);
    
    UIView * targetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, -1, 80)];
    [targetView setFrame:CGRectMake(0, 10, -5, -6)];
    [targetView setNeedsDisplay];
    
    [self.view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
    [self.view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
    
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if([keyPath isEqualToString:@"frame"]){
        
    }
}

@end

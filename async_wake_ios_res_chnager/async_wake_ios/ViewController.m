#import "ViewController.h"
#import "sys/utsname.h"
#include <stdio.h>
#include "async_wake.h"


@interface ViewController ()
{
    NSArray *_pickerData;
}
@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
    [self addGradient];  // Do any additional setup after loading the view, typically from a nib.
    self.tfp.text = [NSString stringWithFormat:@"tfp: %x"];
    self.resLabel.text = [NSString stringWithFormat:@"Select Res and Press Go.\n"];
    [self.goButton setTitle:@"    Go    " forState:UIControlStateNormal];
    // Initialize Data
    _pickerData = @[@"1334x750", @"1920x1080", @"1511x751", @"1156x640", @"1334x640", @"2436x1150"];
    // Connect data
    self.picker.dataSource = self;
    self.picker.delegate = self;
    
    
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *device = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSString *vers = [[UIDevice currentDevice]systemVersion];
    
    NSString *full = [NSString stringWithFormat:@"%@%@%@%@",@"This device is: ",device,@" ",vers];
    _deviceInfoLabel.text = full;
    
    
}



- (void)didReceiveMemoryWarning {
    printf("******* received memory warning! ***********\n");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}

- (void)addGradient {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    gradient.frame = view.bounds;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH"];
    
    if([[formatter stringFromDate:[NSDate date]] intValue] >= 18) {
        gradient.colors = @[(id)[UIColor colorWithRed:0.0941 green:0.5882 blue:0.7765 alpha:1.0].CGColor, (id)[UIColor colorWithRed:0.1686 green:0.1255 blue:0.3216 alpha:1.0].CGColor];

        
    } else {
        gradient.colors = @[(id)[UIColor colorWithRed:0.77 green:0.00 blue:0.34 alpha:1.0].CGColor, (id)[UIColor colorWithRed:0.24 green:0.04 blue:0.29 alpha:1.0].CGColor];
    }
    
    [view.layer insertSublayer:gradient atIndex:0];
    [self.view insertSubview:view atIndex:0];
    
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerData[row];
}


- (IBAction)handleGoClick:(id)sender {
    go();
    
    NSString *title = @"Resolution Changed";
    NSString *message = @"Please reboot device";
    NSString *okText = @"Ok";
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:okText style:UIAlertActionStyleCancel handler:nil];
    [self presentViewController:alert animated:YES completion:nil];
}

@end

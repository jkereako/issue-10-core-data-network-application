//
// Created by chris on 03.03.14.
//

#import "PodDetailViewController.h"
#import "Pod.h"

@interface PodDetailViewController ()

@property (nonatomic, weak) IBOutlet UILabel *version;
@property (nonatomic, weak) IBOutlet UILabel *authors;
@property (nonatomic, weak) IBOutlet UILabel *link;
@property (nonatomic, weak) IBOutlet UILabel *source;

@end

@implementation PodDetailViewController

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wreceiver-is-weak"
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.pod.name;
    self.version.text = self.pod.version;
    self.authors.text = [[self.pod.authors allKeys] componentsJoinedByString:@", "];
    self.link.text = self.pod.link;
    self.source.text = self.pod.source;
}
#pragma clang diagnostic pop

@end

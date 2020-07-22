//
//  LocationSearchTable.m
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 20/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import "LocationSearchTableViewController.h"

@interface LocationSearchTableViewController ()

@property (strong, nonatomic) NSArray<MKMapItem *> *matchingItems;

@end

@implementation LocationSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

# pragma mark - Update Search Results

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchText = searchController.searchBar.text;
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = searchText;
    request.region = self.mapView.region;
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
        if(error) {
            NSLog(@"Error loading search items: %@", error.localizedDescription);
        } else {
            self.matchingItems = response.mapItems;
            [self.tableView reloadData];
        }
    }];
}

# pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.matchingItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"locationSearchCell"];
    MKPlacemark *selectedItem = self.matchingItems[indexPath.row].placemark;
    cell.textLabel.text = selectedItem.name;
    cell.detailTextLabel.text = [self parseAddress:selectedItem];
    return cell;
}

# pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MKPlacemark *selectedItem = self.matchingItems[indexPath.row].placemark;
    [self.delegate dropPinZoomIn:selectedItem];
    [self dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark - Parse Address

- (NSString *)parseAddress:(MKPlacemark *)selectedItem {
    //checks for the first space between subthroughtfare and trhoughtfare, if they are both null then a space is not needed
    NSString *firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? @" ": @"";
    //checks if a coma is needed, if one of them is missing then a comma would not be needed ", nuevo leon" wouldn't work
    NSString *firstComma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? @", " : @"";
    //its a comma between the state and its administrative area.
    NSString *secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? @" " : @"";
    NSString *address = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",
                             (selectedItem.subThoroughfare == nil ? @"" : selectedItem.subThoroughfare),
                             firstSpace,
                             (selectedItem.thoroughfare == nil ? @"" : selectedItem.thoroughfare),
                             firstComma,
                             (selectedItem.locality == nil ? @"" : selectedItem.locality),
                             secondSpace,
                             (selectedItem.administrativeArea == nil ? @"" : selectedItem.administrativeArea)
                             ];
    return address;
}

@end

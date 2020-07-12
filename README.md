# Stuff-Trading-App

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview 
### Description
It's an app where people can put up what items they would like to trade or give away, giving the option for other people to trade for things they want.

### App Evaluation
- **Category:** E-Commerce, Marketplace, Social Networking
- **Mobile:** It can use your location, the camera and will have profiles to sign-in.
- **Story:** Helps people trade stuff they don't use anymore for free or for something they want.
- **Market:** Anyone.
- **Habit:** Will let people stop wasting items that they are not using anymore and let those items be re-used.
- **Scope:** It would start with messages, feed, sign-in, location and would be available for anyone, primarly focused on young adults.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* Your app interacts with Parse.
* You can log in/log out of your app as a user.
* You can sign up with a new user profile.
* The user can see his own profile.
* The user can see other users profiles.
* The user go to other user profile by clicking the profile pic in a post.
* The user can set his profile picture.
* The app implements map location.
* The posts load in with animation.
* The user can upload a post of something that they want to trade to the feed.
* The user can see the feed of trading.
* The feed should have infinite scrolling.
* The user can refresh the feed.
* The users can message each other.
* User can change his name.
* User can change his password.
* User can see the chats and messages.
* The user can post an image.
* The user can add map location to the post.
* User should display the relative timestamp for each message "8m", "7h"
* User should display the relative timestamp for each post "8m", "7h"
* Your app incorporates an external library to add visual polish.
* Your app contains at least one more complex algorithm (talk with your manager).


**Optional Nice-to-have Stories**

* The feed is divided in Books/Movies/Manga/etc.
* The feed in a collection view.
* Map view where it shows the trade posts close to you.
* User can message images.


### 2. Screen Archetypes

* Log-in
  * Your app interacts with Parse.
  * You can log in/log out of your app as a user
  * You can sign up with a new user profile 
* Profile (our profile)
    * The user can see his own profile.
* Feed
    * The user can upload a post of something that they want to trade to the feed.
    * The posts load in with animation.
    * The user can see the feed of trading options.
    * The feed should have infinite scrolling.
    * The user can refresh the feed.
    * You can log in/log out of your app as a user
    * The user go to other user profile by clicking the profile pic in a post.
* User (other user profile)
    * The user can see other users profiles.
* ComposePost
    * The user can upload a post of something that they want to trade to the feed.
    * The user can post an image.
    * The user can add map location to the post.
* PostDetails
    * User should display the relative timestamp for each post "8m", "7h"
* DirectMessage
    * User should display the relative timestamp for each message "8m", "7h"
    * The users can message each other.
* Messages
    * User can see the chats and messages.
* UserSettings
    * User can change his name
    * User can change his password
    * The user can set his profile picture.
* MapView
    * The app implements map location.

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Profile
* Feed
* Messages
* Optional: close trades map

**Flow Navigation** (Screen to Screen)

* Login
   * Profile
   
* Profile
   * UserSettings
   
* Messages
    * DirectMessage

* Feed
   * User
   * PostDetails
   * ComposePost
   
* ComposePost
    * MapView
   
* User
   * DirectMessage

## Digital Wireframes

<img src="https://github.com/IanAragonSaenz/Stuff-Trading-App/blob/master/WireframePic.png" width=600>

### [BONUS] Interactive Prototype

## Schema 
### Models
#### Post
| Property      | Type     | Description |
| ------------- | -------- | ------------|
| objectId      | String   | unique id for the post (default field) |
| author        | Pointer to User| image author |
| image         | File     | image that user posts |
| title       | String   | image caption by author |
| description | Number   | number of comments that has been posted to an image |
| likesCount    | Number   | number of likes for the post |
| location    | String   | location for the trade |
| createdAt     | DateTime | date when post is created (default field) |
| updatedAt     | DateTime | date when post is last updated (default field) |

#### User
| Property      | Type     | Description |
| ------------- | -------- | ------------|
| objectId      | String   | unique id for the user (default field) |
| image         | File       | image of user |
| username   | String   | user's name |
| password   | String   | user's password |
| email | String   | user's email |
| emailVerified    | Bool   | if user has verified his email |
| authData    | Object   | user data |
| createdAt     | DateTime | date when post is created (default field) |
| updatedAt     | DateTime | date when post is last updated (default field) |

### Chat
| Property      | Type     | Description |
| ------------- | -------- | ------------|
| objectId      | String   | unique id for the message (default field) |
| userA         | Pointer to User       | user from chat |
| userB   | Pointer to User   | user from chat |
| createdAt     | DateTime | date when post is created (default field) |
| updatedAt     | DateTime | date when post is last updated (default field) |

#### Message
| Property      | Type     | Description |
| ------------- | -------- | ------------|
| objectId      | String   | unique id for the message (default field) |
| message         | String       | user's message |
| author   | Pointer to User   | user's name |
| author   | Pointer to Chat   | chat's objectid |
| createdAt     | DateTime | date when post is created (default field) |
| updatedAt     | DateTime | date when post is last updated (default field) |

### Networking
#### Login
| CRUD   | HTTP Verb | Example                              |
|--------|-----------|--------------------------------------|
| Create | POST      | Creating a new user                  |
| Create | POST      | Create a post                        |
| Create | POST      | Create a direct messsage             |
| Create | POST      | Logout from current session     |
| Create | POST      | Send message to another user     |
| Read   | GET       | Login the user                 |
| Read   | GET       | Get an existing user                 |
| Read   | GET       | Fetching posts for user's feed       |
| Read  | GET       | Fetch the user's chats   |
| Read   | GET       | Get messages from a chat             |
| Update | PUT       | Update existing user profile picture |
| Update | PUT       | Change user's name                   |
| Update | PUT       | Change user's password               |
| Delete | Delete    | Delete an existing user              |

    - Login Screen
        - (Create/POST) Creating a new user
           ```Objective-C
           if([self usernameEmpty:self.usernameText.text password:self.passwordText.text])
               return;

           PFUser *newUser = [PFUser user];
           newUser.username = self.usernameText.text;
           newUser.password = self.passwordText.text;

           [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
               if(succeeded){
                   //let user in
               }else{
                   //alert user of error
               }
           }];
           ```
        - (Read/GET) Login the user
            ```Objective-C
            if([self usernameEmpty:self.usernameText.text password:self.passwordText.text])
                return;
            
            NSString *username = self.usernameText.text;
            NSString *password = self.passwordText.text;

            [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * _Nullable user, NSError * _Nullable error) {
                if(error){
                    //alert user of error
                }else{
                    //let user in
                }
            }];
            ```
    - Home Feed Screen
        - (Read/GET) Fetching posts for user's feed 
            ```Objective-C
            PFQuery *query = [PFQuery queryWithClassName:@"Post"];
            query.limit = 20;
            [query orderByDescending:@"createdAt"];
            [query includeKey:@"author"];
            
            [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable posts, NSError * _Nullable error) {
                if(!error){
                    //do something with posts
                }else{
                    //error
                }
            }];
            ```
        - (Create/POST) Logout from current session
            ```Objective-C
            //change scenes
            [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
                //do something
            }];
            ```
    - Messages Screen
        - (Read/GET) Fetch the user's chats
        
    - Profile Screen
        - (Read/GET) Get an existing user 
    
    - Compose Post Screen
        - (Create/POST) Create a post   
            ```Objective-C
            Post *newPost = [Post new];
            newPost.image = [self getPFFileFromImage:image];
            newPost.author = [PFUser currentUser];
            newPost.caption = caption;
            newPost.likeCount = @(0);
            newPost.commentCount = @(0);
            
            [newPost saveInBackgroundWithBlock:];
            ```
            
    - User Settings Screen
        - (Update/PUT) Update existing user profile picture   
            ```Objective-C
            ```
        - (Update/PUT) Change user's name 
        - (Update/PUT) Change user's password 
        - (Delete) Delete an existing user
        
    - Compose Post Screen
        - (Create/POST) Create a post   
            ```Objective-C
            ```
    - Direct Messages Screen
        - (Read/GET) Get messages from a chat  
        - (Read/GET) Send message to another user
        
- [OPTIONAL: List endpoints if using existing API such as Yelp]

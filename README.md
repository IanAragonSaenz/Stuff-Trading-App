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

* Your app has multiple views
* Your app interacts with a database (e.g. Parse) 
* You can log in/log out of your app as a user
* You can sign up with a new user profile 
* Somewhere in your app you can use the camera to take a picture and do something with the picture (e.g. take a photo and share it to a feed, or take a photo and set a user’s profile picture)
* Your app integrates with a SDK (e.g. Google Maps SDK, Facebook SDK)
* Your app contains at least one more complex algorithm (talk with your manager) 
* Your app uses gesture recognizers (e.g. double tap to like, e.g. pinch to scale) 
* Your app use an animation (doesn’t have to be fancy) (e.g. fade in/out, e.g. animating a view growing and shrinking)
* Your app incorporates an external library to add visual polish
* The user can upload a post of something that they want to trade to the feed.
* The user can see the feed of trading options.
* The feed should have infinite scrolling.
* The users can message each other.
* User can change his name
* User can change his password
* User can change his profile picture.
* User can see the chats and messages he has

**Optional Nice-to-have Stories**

* The feed is divided in Books/Movies/Manga/etc.
* The feed in a collection view.
* Map view where it shows the trade posts close to you.
* User should display the relative timestamp for each post "8m", "7h"
* User can message images


### 2. Screen Archetypes

* Log-in
  * Your app interacts with a database (e.g. Parse) 
  * You can log in/log out of your app as a user
  * You can sign up with a new user profile 
* Profile (our profile)
   * Somewhere in your app you can use the camera to take a picture and do something with the picture (e.g. take a photo and share it to a feed, or take a photo and set a user’s profile picture)
   * Your app use an animation (doesn’t have to be fancy) (e.g. fade in/out, e.g. animating a view growing and shrinking)
* Feed
    * The user can upload a post of something that they want to trade to the feed.
    * The user can see the feed of trading options.
    * The feed should have infinite scrolling.
    * Your app uses gesture recognizers (e.g. double tap to like, e.g. pinch to scale) 
* User (other user profile)
    * Your app use an animation (doesn’t have to be fancy) (e.g. fade in/out, e.g. animating a view growing and shrinking)
* ComposePost
    * Somewhere in your app you can use the camera to take a picture and do something with the picture.
    * Your app use an animation (doesn’t have to be fancy) (e.g. fade in/out, e.g. animating a view growing and shrinking)
* PostDetails
    * User should display the relative timestamp for each post "8m", "7h"
* DirectMessage
    * User should display the relative timestamp for each message "8m", "7h"
    * The users can message each other.
* Messages
    * User can see the chats and messages he has
* UserSettings
    * User can change his name
    * User can change his password
    * User can change his profile picture.

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
   
* PostDetails
   * ComposePost
   
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
| chat   | Pointer to Chat   | chat where message is supposed to go |
| author   | Pointer to User   | user's name |
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
| Read   | GET       | Get an existing user                 |
| Read   | GET       | Fetching posts for user's feed       |
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
        - (Read/GET) Get an exisiting user
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
        - (Create/POST) Create a post   
            ```Objective-C
            
            ```
    - Compose Post Screen
        - (Create/POST) Create a post   
            ```Objective-C
            
            ```
- [OPTIONAL: List endpoints if using existing API such as Yelp]

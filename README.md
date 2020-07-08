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
* Messages
    * User should display the relative timestamp for each message "8m", "7h"
### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Profile
* Feed
* Optional: close trades map

**Flow Navigation** (Screen to Screen)

* Login
   * Profile

* Feed
   * User
        * Messages
   * PostDetails
   * ComposePost

## Digital Wireframes

<img src="https://github.com/IanAragonSaenz/Stuff-Trading-App/blob/master/WireframePic.png" width=600>

### [BONUS] Interactive Prototype

## Schema 
[This section will be completed in Unit 9]
### Models
[Add table of models]
### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]

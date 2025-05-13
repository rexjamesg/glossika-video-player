//
//  VideoSource.swift
//  GlossikaVideoPlayer
//
//  Created by Yu Li Lin on 2025/5/13.
//

import Foundation

// MARK: - VideoDetail

protocol VideoDetail {
    var description: String { get }
    var url: URL? { get }
    var subtitle: String { get }
    var title: String { get }
    var fullImageURL: URL? { get }
}

// MARK: - VideoSource

enum VideoSource: Int, CaseIterable {
    case bigBuckBunny
    case forBiggerBlazes
    case forBiggerEscape
    case forBiggerMeltdowns
    case subaruOutbackOnStreetAndDirt
    case tearsOfSteel
    case volkswagenGTIReview
    case weAreGoingOnBullrun
    case whatCareCanYouGetForAGrand
    case testError
}

// MARK: VideoDetail

extension VideoSource: VideoDetail {
    var description: String {
        switch self {
        case .bigBuckBunny:
            return "Big Buck Bunny tells the story of a giant rabbit with a heart bigger than himself. When one sunny day three rodents rudely harass him, something snaps... and the rabbit ain't no bunny anymore! In the typical cartoon tradition he prepares the nasty rodents a comical revenge.\n\nLicensed under the Creative Commons Attribution license\nhttp://www.bigbuckbunny.org"

        case .forBiggerBlazes:
            return "HBO GO now works with Chromecast -- the easiest way to enjoy online video on your TV. For when you want to settle into your Iron Throne to watch the latest episodes. For $35.\nLearn how to use Chromecast with HBO GO and more at google.com/chromecast."

        case .forBiggerEscape:
            return "Introducing Chromecast. The easiest way to enjoy online video and music on your TV—for when Batman's escapes aren't quite big enough. For $35. Learn how to use Chromecast with Google Play Movies and more at google.com/chromecast."

        case .forBiggerMeltdowns:
            return "Introducing Chromecast. The easiest way to enjoy online video and music on your TV—for when you want to make Buster's big meltdowns even bigger. For $35. Learn how to use Chromecast with Netflix and more at google.com/chromecast."

        case .subaruOutbackOnStreetAndDirt:
            return "Smoking Tire takes the all-new Subaru Outback to the highest point we can find in hopes our customer-appreciation Balloon Launch will get some free T-shirts into the hands of our viewers."

        case .tearsOfSteel:
            return "Tears of Steel was realized with crowd-funding by users of the open source 3D creation tool Blender. Target was to improve and test a complete open and free pipeline for visual effects in film - and to make a compelling sci-fi film in Amsterdam, the Netherlands. The film itself, and all raw material used for making it, have been released under the Creatieve Commons 3.0 Attribution license. Visit the tearsofsteel.org website to find out more about this, or to purchase the 4-DVD box with a lot of extras. (CC) Blender Foundation - http://www.tearsofsteel.org"

        case .volkswagenGTIReview:
            return "The Smoking Tire heads out to Adams Motorsports Park in Riverside, CA to test the most requested car of 2010, the Volkswagen GTI. Will it beat the Mazdaspeed3's standard-setting lap time? Watch and see..."

        case .weAreGoingOnBullrun:
            return "The Smoking Tire is going on the 2010 Bullrun Live Rally in a 2011 Shelby GT500, and posting a video from the road every single day! The only place to watch them is by subscribing to The Smoking Tire or watching at BlackMagicShine.com"

        case .whatCareCanYouGetForAGrand:
            return "The Smoking Tire meets up with Chris and Jorge from CarsForAGrand.com to see just how far $1,000 can go when looking for a car.The Smoking Tire meets up with Chris and Jorge from CarsForAGrand.com to see just how far $1,000 can go when looking for a car."
        case .testError:
            return "TestError Description"
        }
    }

    var url: URL? {
        switch self {
        case .bigBuckBunny:
            return URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")

        case .forBiggerBlazes:
            return URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4")

        case .forBiggerEscape:
            return URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4")

        case .forBiggerMeltdowns:
            return URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4")

        case .subaruOutbackOnStreetAndDirt:
            return URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4")

        case .tearsOfSteel:
            return URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4")

        case .volkswagenGTIReview:
            return URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/VolkswagenGTIReview.mp4")

        case .weAreGoingOnBullrun:
            return URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4")

        case .whatCareCanYouGetForAGrand:
            return URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WhatCarCanYouGetForAGrand.mp4")
        case .testError:
            return URL(string: "")
        }
    }

    var subtitle: String {
        switch self {
        case .bigBuckBunny:
            return "By Blender Foundation"

        case .forBiggerBlazes:
            return "By Google"

        case .forBiggerEscape:
            return "By Google"

        case .forBiggerMeltdowns:
            return "By Google"

        case .subaruOutbackOnStreetAndDirt:
            return "By Garage419"

        case .tearsOfSteel:
            return "By Blender Foundation"

        case .volkswagenGTIReview:
            return "By Garage419"

        case .weAreGoingOnBullrun:
            return "By Garage419"

        case .whatCareCanYouGetForAGrand:
            return "By Garage419"
            
        case .testError:
            return "By testError"
        }
    }

    var thumb: String {
        switch self {
        case .bigBuckBunny:
            return "images/BigBuckBunny.jpg"

        case .forBiggerBlazes:
            return "images/ForBiggerBlazes.jpg"

        case .forBiggerEscape:
            return "images/ForBiggerEscapes.jpg"

        case .forBiggerMeltdowns:
            return "images/ForBiggerMeltdowns.jpg"

        case .subaruOutbackOnStreetAndDirt:
            return "images/SubaruOutbackOnStreetAndDirt.jpg"

        case .tearsOfSteel:
            return "images/TearsOfSteel.jpg"

        case .volkswagenGTIReview:
            return "images/SubaruOutbackOnStreetAndDirt.jpg"

        case .weAreGoingOnBullrun:
            return "images/WeAreGoingOnBullrun.jpg"

        case .whatCareCanYouGetForAGrand:
            return "images/WhatCarCanYouGetForAGrand.jpg"
            
        case .testError:
            return "testErrorThumb.jpg"
        }
    }

    var title: String {
        switch self {
        case .bigBuckBunny:
            return "Big Buck Bunny"

        case .forBiggerBlazes:
            return "For Bigger Blazes"

        case .forBiggerEscape:
            return "For Bigger Escape"

        case .forBiggerMeltdowns:
            return "For Bigger Meltdowns"

        case .subaruOutbackOnStreetAndDirt:
            return "Subaru Outback On Street And Dirt"

        case .tearsOfSteel:
            return "Tears of Steel"

        case .volkswagenGTIReview:
            return "Volkswagen GTI Review"

        case .weAreGoingOnBullrun:
            return "We Are Going On Bullrun"

        case .whatCareCanYouGetForAGrand:
            return "What care can you get for a grand?"
            
        case .testError:
            return "TestError Title"
        }
    }

    var fullImageURL: URL? {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "commondatastorage.googleapis.com"
        components.path = "/gtv-videos-bucket/sample/" + thumb
        return components.url
    }
}

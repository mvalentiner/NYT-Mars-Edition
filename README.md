#  NYT Mars Edition

### Solution

My solution consists of the minimum required two screens implemented by `ArticleListViewController` (UIKit) and `ArticleScreen`. (SwiftUI).

The main architectual components are:

* `ServiceRegistry` and `SOAService` pattern I've developed. `ServiceRegistry` implements the Service Locator pattern and `SOAServices` are used to 
factor buisness logic out of `UIViewControllers`.

* `AppNavigationCoordinator` uses the Coordinator pattern. I use it to factor navigation concerns out of `UIViewControllers` and SwiftUI `Views`.

In addition, it is used to construct `UIViewControllers` and SwiftUI `Views` and configure them by injecting the services they use. Dependency management
is encapsulated in `AppNavigationCoordinator`.

There are three `SOAServices` I developed for the app:

* `AppProperties` implements the persistent `isTranslateOn` property .

* `NYTService`  fetchs articles from the server and caches NYTArticles. It utilizes `UnauthenticatedDecodableXMLRequest` and
`UnauthenticatedDataRequest`, which I describe below.

* `TranslationService` implements the rules for translating English to Martian.

There are a number of utility classes that `NYTService` uses to make network requests to fetch data:

* `UnauthenticatedDataRequest` is a protocol and protocol extension used to fecth data across the network. It simply requires an endpoint and
invocation of the `load()` function to get data returned as Data.

* `UnauthenticatedDecodableRequest` is a protocol and protocol extension used to fecth decodable  across the network. It simply requires
an endpoint and the `Decoadeable` type of the data (as an associatedtype) to be returned. Two additional protocols built on `UnauthenticatedDecodableRequest` are:

** `UnauthenticatedDecodableJSONRequest` and

** `UnauthenticatedDecodableXMLRequest`, which is used in this app.

Two concrete class built on these protocols are:

** `NYTArticlesRequest`, built on `UnauthenticatedDecodableRequest` and 

** `ImageRequest`, built on `UnauthenticatedDataRequest`. 

An additional utility type that I use is `Bindable`.  This is my own light weight version of an RxSwift-like or ReactiveSwift-like type for binding to a property
and reacting to it when it changes. By using my own implementation, I don't need to import a third-party framework and deal with the headaches
of managing the dependency. I use `Bindable` in 

** `NYTService` to notify observers when new data arrives and in

** `ArticleListViewController` to update it's `NYTArticleSummaryViewModel` and to update the UI.

I used UIKit to implement  `ArticleListViewController` to show I know UIKit.

I used SwiftUI to implement `ArticleScreen` to show I'm learning SwiftUI.

The NYT Mars EditionTests are a by product of the development work.

# Michael Valentiner, Heliotropix, LLC
## michael.valentiner@heliotropix.com

### Assignment

You've been assigned the task of creating a translation of the New York Times news reader application for the latest emerging market -- Mars!

The requirements for the application are the following:

* It has to be a native application and no webviews should be used.

* Articles should be dynamically fetched from  http://mobile.public.ec2.nytimes.com.s3-website-us-east-1.amazonaws.com/candidates/content/v1/articles.plist.

* At least 2 screens should be implemented: a list of articles and an article view. 

* One image per article (its "top image") should be displayed on both the list screen and the article screen. All other images may be discarded.

* The user should be able to dynamically toggle the language preference from English to Martian.

* Language selection should be persisted across runs.

* The following translation rules apply for translating English to Martian:

** All words greater than 3 characters should be translated to the word "boinga"

** Numbers should not be translated unless embedded within a word. (ex. “20,000 Leagues Under the Sea” should translate to “20,000 Boinga Boinga the Sea”, whereas “fri3nd” should translate to just “boinga”.

** Capitalization must be maintained

** Punctuation within words (e.g. we'll) can be discarded, all other punctuation (including paragraph spacing) must be maintained.

** The application needs test cases verifying Martian translation. Additional Test cases should be implemented as needed.

** For example, “Is there life on Mars?” should be translated to “Is boinga boinga on Boinga?”


Consider this application a showcase of your engineering prowess. You are free to use any architecture and patterns that you prefer. Third party libraries are allowed in all contexts except networking and image handling. System libraries are fine to use everywhere.


The length of time spent to complete this exercise will not affect our evaluation. We understand that you are likely to have many things, both personally and professionally, that may slow you down. Your code will, however, be evaluated for architecture, style, clarity, and approach.


Once everything is complete, please zip up and return the project via email in your own time. 


Thank you and good luck! Please let me know if you have any questions!

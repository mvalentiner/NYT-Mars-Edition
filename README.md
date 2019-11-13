#  NYT Mars Edition

## TODO
* ArticleListView UI
** implement as UITableView to demonstrate I can implement UITableView
** langauge switch at top
*** toggling switch reloads table animated with translated articles
** UITableView below
** bind to articles array
** on viewWillLoad make call to fetch articles
optional wants:
** swipe down to refresh

* ArticleView
** implement in SwiftUI
optional want:
** scrollable list of images

* fetch articles
** convert from XML to JSON
** decode from JSON

* implement translationService

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

### Solution


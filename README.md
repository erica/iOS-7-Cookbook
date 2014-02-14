<h3>iOS Developer's Cookbook</h3>
Welcome to the source code repository for the iOS 7 edition of the iOS Developer's Cookbook. 

LOOKING FOR THE ADVANCED COOKBOOK REPOSITORY? It's <a href="https://github.com/erica/iOS-6-Advanced-Cookbook">here</a>!

Sample code is never a fixed target. It continues to evolve as Apple updates its SDK and the CocoaTouch libraries. 

Get involved. You can pitch in by suggesting bug fixes and corrections as well as by expanding the code that's on offer. 

Github allows you to fork repositories and grow them with your own tweaks and features, and share those back to the main repository. If you come up with a new idea or approach, let us know. We'd be happy to include great suggestions both at the repository and in the next edition of this cookbook.

<h3>About the Cookbook</h3>
The iOS Developer's Cookbook is written for experienced developers who want to build apps for the iPhone, iPad, and iPod touch. It helps to already be familiar with Objective-C, the Cocoa frameworks, and the Xcode tools. 

That said, if you're new to the platform, this edition of The iOS Developer's Cookbook includes a quick-and-dirty introduction to Objective-C along with an intro to the Xcode Tools to help you quickly get up to speed.

Although each programmer brings different goals and experiences to the table, most iOS developers end up solving similar tasks in their development work:


* "How do I build a table?"
* "How do I create a secure Keychain entry?"
* "How do I search the Address Book?"
* "How do I move between views?"
* "How do I use Core Location, the gyro, and the magnetometer?"
* "How do I draw text around shapes?"
* "How do I use a Page View controller?"

And so on. If you've asked yourself these questions, then this book is for you. The iOS Developer's Cookbook will get you up to speed and working with the iOS SDK, offering you ready-to-use solutions for the apps you're building today.

<h3>What's the deal with main.m?</h3>
For the sake of pedagogy, this book's sample code usually presents itself in a single main.m file. This is not how people normally develop iOS or Cocoa applications, or *should* be developing them, but it provides a great way of presenting a single big idea. 

It's hard to tell a story when readers must look through 5 or 7 or 9 individual files at once. Offering a single file concentrates that story, allowing access to that idea in a single chunk.
These samples are not intended as stand-alone applications. They are there to demonstrate a single recipe and a single idea. A main.m file with a central presentation reveals the implementation story in one place. 

Readers can study these concentrated ideas and transfer them into normal application structures, using the standard file structure and layout. The presentation in this book does not produce code in a day-to-day best practices approach. Instead, it offers concise solutions that you can incorporate back into your work as needed.

Contrast that to Apple's sample code, where you must comb through many files in order to build up a mental model of the concepts that are on-offer. Those samples are built as full applications, often doing tasks that are related to but not essential to what you need to solve, with many distracting flourishes. Finding relevant portions is a *lot* of work. The effort may outweigh any gains. 

There are two exceptions to this one-file rule. First, application-creation walkthroughs use the full file structure created by Xcode to mirror the reality of what you'd expect to build on your own. The walk through folders may therefore contain a dozen or more files at once. 

Second, standard implementation and header files are provided when the class itself is the recipe. Instead of highlighting a technique, some recipes offer pre-cooked class implementations and categories (that is, extensions to a pre-existing class, rather than a child class). For those recipes, look for separate .m and .h files in addition to the skeletal main.m that encapsulates the rest of the story.

<h3>How to build these projects</h3>
You should be able to build these projects for the simulator or use your team provision to build and deploy to devices. Before compiling, make sure you select a deployment target using the pop-up menu at the top-left of the Xcode window. 

For the most part, the samples for this book use a single application identifier, com.sadun.helloworld. This book uses one identifier to avoid clogging up your iOS device with dozens of samples at once. Each sample replaces the previous one, ensuring that SpringBoard remains relatively uncluttered. If you want to install several samples at once, simply edit the identifier, adding a unique suffix, such as com.sadun.helloworld.table-edits. You'll want to edit the display name so you can tell instantly which project is which. Samples use the same icons and launch images as well.

/*:
 # Table Of Context
 ## Phase 1: General Apple System Knowledge
 This section provides an overview of the iOS programming ecosystem using Swift and provides a basic understanding of the fundamental concepts applied throughout the book. This section is a high-level overview based on computer science concepts as opposed to API specifics that frequently change. The goal is for to become familiar with the core concepts that underly the more complex decisions you will make as a mobile engineer. For example, without understanding Swifts memory management it will be very difficult to optimize a large scale app or improve in other performance and reliability metrices.
 
 *  [Introduction](Introduction)
 *  [1. Structures And Classes](StructuresAndClasses)
      * Initializing
      * Instance Variables
      * Properties
      * Methods
      * Protocols
      * Conclusion
 *  [2. Memory Management]()
      * App Memory Usage
      * Swift Memory Model
      * Automatic Reference Counting (ARC) Overview
      * ARC Object Ownership
      * Heap Objects
      * Stack Objects
      * Method Dispatch
      * Conclusion
 *  [3. Persistence]()
      * Persistance options on iOS (NSUserDefaults, flat file, plist, DB)
      * NSUser Defaults
      * Plist/flat file
      * Core Data
      * Deep Dive SQLite
      * Conclusion - choosing right option and ensuring data is properly persisted
 ## Phase 2: Concurrency and Parallelism
 Concurrent programming is an important part of app development (providing the user a performant experience) and presents some of the most challenging aspects of app development.
 * [Concurrency, Parallelism, and Async Programming]()
    * Multithreading
    * Parallelism
    * Asynchronous Programming
 * [Benefits Concurrent Programming]()
 * [Threads and Locks]()
    * Implementing threads and locks
    * Deadlocks
    * Race conditions
 * [Using GCD For Concurrency]()
 https://developer.apple.com/library/archive/documentation/General/Conceptual/ConcurrencyProgrammingGuide/Introduction/Introduction.html
 Some posts on new Swift Concurrency: https://www.donnywals.com/the-blog/
 * [Using NSOperationQueues]()
 https://nshipster.com/nsoperation/
 https://www.raywenderlich.com/5293-operation-and-operationqueue-tutorial-in-swift#toc-anchor-004
 https://medium.com/shakuro/nsoperation-and-nsoperationqueue-to-improve-concurrency-in-ios-e31ee79c98ef
 * [Conclusion: Choosing The Right Abstraction]()
 https://cocoacasts.com/choosing-between-nsoperation-and-grand-central-dispatch/
 
 ## Phase 4: Common App Architecture and Design Patterns
 chapters:
 1. Common Application architecture
 2. Common design patters
 We start with system design patterns and then explain how this just scratches the surface of delivering a valuable application to users (the end goal)
 * [Modularity]()
 https://stackoverflow.com/questions/22108290/modularize-a-big-ios-app-using-cocoapods
 * [API Engineering]() sync protocols and mobile considerations --> how will the data look? User vs specific item level concerns. Ensurign the backend specs match what the frontend requires. As mobile engineers you will have the best understanding of what data is requied and in what states e.i. notifications, app background, sync protocols for data. This is a great way to increase your impact across multiple teams and also unsure the product is built seemlessly with users in mind. 
 * [MVC]()
 These are some common problems experienced in MVC apps:
 Massive View Controllers
 View Controllers may modify data, manage I/O, fetch from APIs, contain the source of truth for model objects, or otherwise exceed their purpose: managing views and UI events.
 Tricky Bugs from Shared Data
 Who is modifying this data and when? Without a careful design, the answer could be almost anyone, at almost any time, with unknown, cascading side effects.
 Hard to Test Code with Too Much Responsibility
 Seams which delineate and isolate behavior are murky or missing when the single responsibility principle is flouted.

 https://www.w2ssolutions.com/blog/mvc-vs-mvvm-vs-mvp-vs-viper/
 https://medium.com/developermind/blurring-the-lines-between-mvvm-and-viper-dcb3dc9815ac
 * [Reactive Programming]()
 * [VIPER]()
 * [MVVM]()
 https://www.codementor.io/@nishadhshrestha/mvvm-in-swift-4-using-delegates-ikdflt1cb
 * [Coordinators]()
 * [Delegate Pattern]()
 * [Repository (Facade) Pattern]()
 https://www.userdesk.io/blog/repository-pattern-using-core-data-and-swift/
 https://blog.devgenius.io/data-repository-layer-in-ios-mvvm-562541b46f91
 * [Dependency Injection]()
 * [Advanced State Management - deep links and notifications]()
 This section builds on all previous parts of this book and outlines how to approach architecting a large-scale client solution. Including; what questions to ask when approaching a new project, potential system design patterns for implementing your feature. Phase 6 of this book utilizes these patterns
 So far we've discussed the basic building blocks for iOS applicaitons, by now you should be able to architect an application from scratch, think about the engineering tradeoffs for different portions and how to evaluate your decisions. HOwever, this is only part of the challenge when dealing with a large scale application adn mature user base. With a small applciaton you will mostly be building 0-1 features, probably with a small team. Sharing context is easy, testing new features may be much less important as complex texting infrastructure may yet to exist and your user base may be too small to draw meaningful conclusions. Performance tuning such as otpimiztn start times may be a non-existant concern as you look for hypergrowth in western markets. This all changes once your applicaiton reaches a certain size. It will be difficult to reach consensus decisions across 100's of engineers all making app changes. Testing and releasing without breaking things becomes critical as does measuring the impact of changes expecially in regards to other's changes. Lastly as the hypgrowth phase dies out capitalizing on new markets and preventing churn will have elavated cocnerns meanign performance tuning for low end devices will start o make sense. The remaining chapters will cover concerns aroudn working at a large team as well as case studies from large companies with potential solutions to many common problems you can leverage for yourself.
 
 ## Phase 5: Apps At Scale
 
 More than just learning how to architect the system this sections practical examples will walk through how to apply these principles to working in and understanding a large existing application.
 
 * [Approaching Systems Design At Scale]()
 1. Understanding the goal - business requirements, MVP feature set, technical feasibility, timeline, key sucess metrics (eng and business). Remember goals are SMART. For a business the most important aspects are long-term revenue and growth potential when architecting software for a business it is important to keep this in mind. While clean code, good engineering desing are important the timing and ability to deliver user value is ultimately the most important drivign factor. This means all decisions most in some way drive towards team defined metric based goals and provide visible impact. Now there is some wiggle room here and all companies operate differently, however, it is a general best practice to back decisions in data and to use that to measure progress against your goals. This also hleps to drive broader team alignment and avoid the situation where the wrong software is developed. This also helps to reign in potentially complex engineering designs with little tangible benefit. 
 2. Create engineering document - embrace and clarify the ambiguity, think about experimentation, cross team dependencies (privacy, legal, design, infra - or product teams), key stakeholders, timeline given the available resources, monitoring/alerting, clarify complexities with stakeholders - for mobile this is a lot of complex state cases and entry points.
 3. Working Cross Functionally To Gain Alignment: making sure other engineering teams understand your changes i.e. works with custom infra or infra change supports product goals.
 4. Live agile values not the process - also in terms of code design flexibility to re-do things and scale quickly with changing goals and teams (just a reality  of high turnover industry)
 5. Deliver value
 https://themobileinterview.com/cracking-the-mobile-system-design-interview/
 
 This section focuses on best practices for maintaining a large-scale mobile application. The previous section discussed how to architect and build an application (or feature) and this section strives to answer the question, how do I maintain and improve the application?
  * [Testability]()
     * Unit testing
     * E2E testing
     * Leveraging QA
 https://www.globalapptesting.com/blog/mobile-app-testing-at-scale
  * [Enforcing Modularity]()
 https://developers.soundcloud.com/blog/leveraging-frameworks-to-speed-up-our-development-on-ios-part-1
 Controlling the level of isolation between teams and components is critical in large scale apps with hundreds of engineers making simultaneous changes
     * Using dependency management system
     * Splitting to improve build time
     * Shared libraries
     * High engineering turnover leads to little project context and great need to separate things into chunks that can be moved, re-written or modified without breaking a larger portion of the project. Not only do engineering orgs need to be built to be modular and flexible to change, but also ddoes the code. By keeping this strucrture in midn it will be easier to onboard new engineers and keep makign progress even with high turnover and or team growth.
  * [Build/Release Pipeline]()
     * Automated tests
     * Automated code quality
     * Automated releases
     * Bulding a release cycle - managing the process, handling changes, and bugs
     * Project timing for releases mobile is special
 
  * [Performance]()
     * Establishing performance goals example of goals plan for ORG - how to ensure PRE is taken seriously
     * App size
     * Adding logging
     * Making it part of the experimentation process
 https://www.kodeco.com/2752-25-ios-app-performance-tips-tricks
 https://developer.apple.com/documentation/xcode/diagnosing-performance-issues-early?language=_2
  * [Localization]()
     * Understanding the market
     * Getting content specialists involved
     * Automating the tedius parts
     * Supporting RTL mode
     * Supporting all languages - Tamil (tall characters) Russian (long strings)
  * [Accessibility]()
     * Importance of inclusivity: https://link.springer.com/book/10.1007/978-1-4842-5814-9
  * [Experimentation]()
     * Understanding the value of A/B Testing
     * Understanding what metrics are important team and app wide
     * Network effects
     * Designing and using a holdout
     * Considering performance
     * Designing an experiment and evaluating the results
  * [Analytics, Monitoring, and Alerting]()
  * [Mobile On-Call]()
  * [Compliance, Privacy, and Security]()
      * Third party libraries
      * ePD/GDPR regulations
      * decrypting binary
      * Objectionable content and ML models
  * [Forced Upgrading]()
  * [Cross Platform Verses Native Development]()
     * RN avoid mobile release cycle
     * RN small team iterate quickly
     * RN less ability take advantage of new features and high performance
     * RN app dependent
     * Shared core libraries in C
  * [Working WIth A Large Team]()
     * Understanding engineer architypes and roles
 leadership isn't about being someone saying you are in charge and it isn't about making all the architecture and software decisions in a vacum it is about guiding the team in the right direction and leveraging everyones strengths to achieve the teams goal. A lot of times I see engineers and new team leaders get stuck thinking that as the TL they need to define the software architecture and all the requirements themselves there way and just tell others what to do. That might work on small projects with a small team of junior engineers. Even then this command and control model is not a good way to develop those junior engineers into future TLs. Being a TL is so much more it is about leveraging engineers strengths, helping to develop more junior engineers through giving them more and more autonomy and managing all aspects of the sotware product, not just the architecture design. At a small scale working on a feature sure the expectation is to architect it, but at a larger scale say working with an ML team and server infrastructure to better serve personalized results the TL is not an expert on ML, scaling ML systems, and the mobile work to deliver the end user experience. They must rely on others to help architect their components and then mesh them together into a coherent system the TL in this case also can't review diffs for everyone you must be comfortable delegating these responsibilties and trusting others. Not without guardrails though you need to ask questions, follow up, set goals, and generally keep everyone on track. This is the essence of leadership to do all of these you also need the technical chops to ensure the architecture itself is valid and nothing critical but often overlooked like logging is missed.
     * TL Large team - Delegate
     * TL large team - Uplevel others
         * Diff reviews - not just syntax buck architecture and best practice suggestions. For example, say your company has a custom library that sits on top of NSUserDefaults and is scoped by user and you see a new hire using nsuserdefaults. YOu can not only point them to the new library but ask them about the persistance they are trying to have and ensure they understand the intricacies. More broadly you can help enforce design patterns and architecture principles (potentially suggesting a bitset).
 * Being the leader - needing the coding and architecture skills so that ohters want your project feedback and input.
     * Communication - verbal and written
     * Scaling oneself
  * [Large Scale Data Migrations]()
 * https://www.objc.io/issues/4-core-data/importing-large-data-sets-into-core-data/
 https://www.youtube.com/watch?v=KhZcSRXJHFs&t=190s
 
 ## Phase 6 Bringing everything together
 
 In this section we will walk through three examples that tie together the principles in the book. The examples build on each other starting with a simple architecture problem and working up to a "day in the life" of a senior engineer where people skills and product knowledge  play a factor.
 * [Practical Examples](PracticalExamples)
    * Example 1 - Building A Photo Viewing App
        Implementing a photo or story stream flow, very similar to snapchat, tiktok and instagram reels. This will narrowly focus on app architecture and identifying tradeoffs.
    * Example 2 - Migrating A Messaging App
       Implementing a large scale migration and fundemental paradigm shift in messaging (going to encrypted messaging and unifying the underlying infrastructure)
    * Example 3 - Improving A Legacy Airplane App
       This is the real world example, while the other two are more contrived scenarios this is a look into what it looks like to be a senior engineer
 */

//: [Next](@next)


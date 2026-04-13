//: [Previous](@previous)
/*:
 # Practical Example 1 - Designing A Photo Viewing Feature In A Larger App
 in this example you controlled much more, set metrics for feature, developed architecutre and interfaced with xFN and senior tech lead
 # Practical Example 2 - Designing A Messaging App
 in this example you are the senior tech lead, you delegated large features similar to example on to other engineers and orchestrated the overall desing principles, abstract components, and set goals that other teams will flesh out and create frameworks to measure.
 # Practical Example 3 - Having Impact In An Application At Scale
 this combines 1 and 2 into a more realistic picture, after all it isn't everyday you re-design a major application.
 ## What To Expect
 
 This example details a realistic look at being a senior engineer at a large company. While the previous ones focused more specifically on applying architectural principles and problem solving skills this examples closely mirrors the actual roles and responsibilites of a senior engineer.
 
 ## Setting The Scene
 
 Meet Jim, Jim is a developer LongLines Airline an airline known for their tech prowess and extremely long lines. Jim has worked at LongLines for 4 years now and understands the app and product well. Recently he helped lead the push to migrate the app to Swift and with the project going smoothly (over 50% migrated) he got promoted to staff software engineer.
 
 Jim primarily focuses on the product layer of the application spending his time implementing new features. However, with the new role he is responsible for understanding areas of impact he can have across multiple teams at an app wide level and is also responsible for championing these ideas for the company (pushing them from concept to reality). Jim's a bit nervous about the increased responsibility in his new role and has scheduled a meeting with his teams data-scientist and good friend Kim to talk about some potential areas for improving the app.
  
 ## Entering Jim's meeting...
 
 *In the meeting Kim begins*  "One area I've been looking into is the bookings flow, we don't seem to have good visibility into what is going on with users in the flow. Especially with next years launch of the new airplane I'm a bit concerned, while looking through the flow yesterday I noticed a steep drop off in our customers completion rate for our newest seat upgrade configeration".
 
 "That's really interesting" Jim replied "that was just a server side change and so should the new configeration for next years launch. I will have to look into this more before we start roadmapping next week. Thanks again for the context".
 
 Back at his desk Jim starts to dig into the code after much muttering and setting of breakpoints he turns to Alex (one of the senior engineers on his team): "this is crazy, it seems we haven't touched the bookings flow in years but it is hardcoded for only a subset seating arrangements and pricing. Here check this out," Jim says as he sends Alex a code pointer via slack. "Oh wow" Alex replies as he clicks thorugh the code, "yeah this will never work for the new plane launch next year. I can't believe no ones seen this. Alex nods, "oh you mean the one where they are cramming four seats into a row and taking away what is left of the leg room? What was it? The SkyLark2000 model?"
 
 "Yeah that one" Jim concludes. As Alex goes back to his work Jim continues scrolling through code "oh wow this payments gateway has no monitoring, and we should really switch to the unified UI components" he mutters under his breath as he schedules a meeting with the payments team tech lead Sarah and a follow up with Kim.
 
 The next day in his meeting with Kim Jim explains, "You were right Kim, it looks like we are dropping bookings for newer airline configurations, I talked to Sarah on the payments team she said that they don't have visibility into this either because it is only effecting a subset of plane configurations, but booking success rate is high on their list of important metrics so I think we definitely found something here."
 
 "That's awesome" Kim replies, "also company wide mobile app bookings account for 70% of all flights booked so I think there is a need for this." Armed with this knowledge Jim ponders his next steps.
 
 **Pause To Evaluate Jim**
 In all, Jim has identified quite a few things:
 1. An issue potentially affecting topline revenue especially with the new plane launch approaching.
 2. Problems with the current alerting/monitoring system.
 3. The root cause of the issue is the unscalable legacy code, note how Jim doesn't suggest hardcoding he new configeration.
 4. In all, this problem affects multiple teams and to solve it in a scalable way will require mutliple teams input.
 
 Back at the office Jim continues working on his plan. He theorizes his team can handle the necessary code changes to the bookings flow and interface with the payments team, however, he notes a gap in the general logging and monitoring. If his team and the payments team had better monitoring in place they could have detected this bug sooner. For Jim this is highly ambiguious as he isn't familair with the apps current logging/monitoring setup or the payments API. He also identifies that the current booking flow is legacy Objective-C and won't scale to accomadate the new airplane configuration LongLines is launching next year. Jim realizes that he will also need design input to make sure that the new airline configeration looks and functions well especially with an upgrade to the new company wide UI system. Lastly, Jim realizes that Kim could've had better insight into this if they had more clear stepwise logging and better drop off reasons reported.
 
 "Ping!" Jim's calendar alert rings out through his airpods, "shoot time for the roadmapping meeting" Jim thinks to himself as he hustles to the meeting room. "Hey Jim thanks for joining us, any big ideas to kick us off" his manager says as Jim strolls in 2 minutes late. "Actually yes" Jim replies "I think we have a pretty big issue here, initially we thought we could support the new SkyLark2000 with a simple configeration change on the server, but it is more involved than that it looks like we will need to refactor the entire flow. Because mobile bookings account for 70% of all bookings I think this should be a top priority."
 
 "That sounds like a lot, do you think we'll be able to get this done in time for the launch next year?" Jims boss replies.
 
 "Yeah I think the flow will only take at most 3 months for the team. We will need support from the payments team and logging team so I'll have to follow up with a more detailed breakdown ideally we can make sure to dynamically support all plane configerations".
 
 "Yeah the potential effect on topeline metrics makes this a high priority item for sure. I can help make sure get proper alignment on this". His manager concludes. Jim leaves the meeting feeling good about the traction he's gained so far.
 
 >  One thing Jim did really well here is he took ownership of an issue and saw it as an opportunity to improve the code for the future and prevent this class of issue from happening again. He could have scoped this as a bug fix, but he saw the opportunity and business importance of improving this flow for the future.
 
 **Lets take another quick pause and assess what Jim has done.**
 1. Identified a potential gap by leveraging his industry knowledge and teammates
 2. Reached out to appropriate points of contact to see if others can benefit from this work and how it maps to their goals. Examples here are the payments team and the data science team.
 3. Started to think about the larger scale engineering components and identify areas of ambiguity that could greatly change the scope of the project. Examples include the payments team and using the new UI system.
 
 **What are some things Jim knew from his experience that got him to this point?**
 1. Knowledge of the codebase and ongoing refactors
 2. Knowledge of the teams and companies topline goals.
 
 **Before continuing what do you think Jim should do next?**
 
 At this point, Jim knows he needs to start working on the scoping documetn with engineering estimates and an architecture diagram. "Hey Alex, for planning the SkylarkLaunch bookings flow I need you to work with Sarah on the payments team. "We have to make sure that we can integrate with them in a way that supports error callbacks and retry mechanics for the flow. We are missing that now. Also make sure we have some sense of their timeline and support, or if they already support this and we just aren't using it. What is your current workload? Ideally we could have this done for the next bi-weekly planning meeting."
 
 "I'm just finishing up some integration testing, I can definitely get this done by then." Alex said.
 
 "Awesome thanks Alex," Jim said as he walked away to meet Stephanie on the the logging team to hash out the details around stepwise logging in the flow.
 
 >Jim's hit on a key leadership tenant here. He's delegated some work to Alex. In doing so he provided a clear goal and end state as well as timeline allowing him an easy path for follow up and Alex a clear prioritization structure.
 
 Fast forward a week. Jim has been hard at work with the product manager and designer to clarify the correct behavior for all airplanes and discusses different configeration changes that could occur including edge cases in coming into and out of the flow via deep links.
 He has also met with Stephanie (from the logging team) to learn more about the framework to hopefully allow them to gain better insights at a screen by screen level.
 
 Armed with this knowledge Jim starts to outline what the first version of his feature will include.
 He wants to stick with the MVVM architecture pattern since it is already used app wide and switching this would mean a lot of inconsistencies. Within the flow he's decided to use a coordinator to control the overall flow. Jim will, as per company policy place, his new code in a separate plugin and hide it behind a feature flag prior to launch. Jim has also decided on a plan to deal with the legacy code, he will wrap his new Swift feature in a shim layer so that it can seemlessly fit with the surounding code.
 
 Below is a snippet of Jim's architecture diagram:
 
 What are some other things Jim needs to account for?
 1. Continue to work with the logging and metrics team who will be amending their logging framework to include the new metrics.
 2. Also talk to Kim about writing new backend pipelines to feed into the experimentation framework.
 3. Follow up with Alex to ensure his work on the payments client API will seemlessly integrate with the rest of the team.
 4. Document his plan for A/B testing the new verses old flow. This is important for him to ensure his changes work especially before removing the legacy code.
 5. Document his alerting/monitoring plan as well as key metrics he will monitor as part of the experiment launch.
 
 Armed with this knowledge Jim uses his companies internal communication tools to put out his value proposition and architecture document for others to review and even books a slot at the upcoming architecture review to go over his plan with other senior engineers at the compay.
 
 During the architecture review it was brought up that adding an offline mode to allow users to jump into bookings where connectivity was lost would be valuable. Jim commented that due to timeline and absence of an existing offline mode he will discuss with the PM and recomends adding it to version 2. While meeting with the PM Jim also discusses how the engineering changes to the flow will allow more seemless upsells for tickets and he thinks after the succesfull refactor they can begin scoping some of this work to further drive revenue.
 
 Jim now goes back to his team from discussion with Alex payments work will take 2 months on their end. Logging luckily, already supports what they want. and using he existing design components Jim's team can build a design approved solution easily. He has the team start of the coordinator flow and experiment setup and shim layer even though the payments team dependency isn't resolved yet.
 
 ## Retrospective and Takeaways
 
 In all Jim did an excellent job owning a problem space and driving a resolution. He outlined a clear business case (mobile bookings are important to the company), took a metrics driven appraoch (a/b test), utilized his senior engineers well, and resolved ambiguity with other teams all while keeping his manager and product manager looped into what he was doing.
 Identify timeline start without full scope and some thing blocked.  In all what are some key behavioral traits that Jim exhibited?
 1. Techincal excellence
 2. Embraces ambiguity
 3. Communication
 
 ## Things we didn't talk about
 
 Due to the nature of the example there are a few thing we didn't talk about, but are still important
 1.Cross platform on Android. Most teams are a mix of iOS and Android so for project planning it is often necessary to include the Android engineering estimates and approaches as well. This could also include a framework for cross platform development such as react native.
 2. Compliance/privacy concerns. It is always worth ensuring that your feature meets regulator and privacy regulations especially as companies scale they come under increasing regulatory scrutiny. It is important to follow proper procedure and as an engineer leader understand the effects that your feature will have on user privacy. This could include how data is stored, how users interact with your feature, what data you log, and many other factors unique to the product.
 3. In this example we assumed some magical server side team making all of the optimal changes for the client. However, this may not be the case, it is often necessary to discuss in detail what data is required, what format it should take, and even what framework or tooling is necessary for communication with the client (Websockets, GraphQL, Rest).
 4. Throughout this process we did not discuss anything related to accessibility, however, in practice this may be quite important to your app and ensuring your product meets these guidelines is important.
 5. Along the same lines as accessibility we did not discuss localization in this example. Given that most airlines are international there is a good chance that supporting multiple languages and multiple regulatory environments important to your application.
 6. Discussing tradeoffs. Jim did this a little when he moved the offline mode to verson 2 due to time constraints and that it didn't exist already. However, a lot of the bigger decisions were made for him such as using the existing architecture patterns and APIs. If he was building this for the first time Jim would need to carefully consider different approaches and pick the best one based on his analysis of the different courses of action.
 
 ## Brief aside on offline mode
 
 Building a proper offine mode is a challenging part of mobile developement that can involve a lot of state management and tradeoffs around user experience. To start one must:
 1. Correclty detect when a user is offline
 2. Correctly persist user state locally and sycnronish it when connectivity is restored
 3. For certain applications detecting low bandwidth is critical as well - such as streaming apps that require video buffering
 4. Understanding what is applicable for offline mode.
 5. How to handle network retry strategies?
 
 First think about how you would address the above points for Jim's project. Once you've considred the tradeoffs lets go over these point by point:
 Some tricking parts to expand on:
 1. Booking seats and other upgrades are time dependent can this actually be offline?
 2. storing plane configeration and image data offline for caching and whatnot
 3. How to restore and sync state say user is booking flight and goes through tunnel how to determine seat availability and booking completion.
 
 ## Questions for the reader
 
 1. The app and flow already exist so Jim already has an idea of the UI flow, logging/metrics, and client/server interaction. If you were looking at building this from scratch what else would you consider? What questions would you ask?
 2. Jim also got lucky in that all teams worked well together, what could he have done if the payments team refused to prioritize his work?
 3.  After succesfull launch what are some next steps?
 
 */

//: [Next](@next)

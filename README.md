NCSU CSC 517 (OO Design and Development)
========================================
Program 2: Ruby on Rails
------------------------

Tour Management System: an application for Agents and Tour Guides

Getting Started
====
Program URL - http://ec2-54-191-251-98.us-west-2.compute.amazonaws.com/

**You can login as an existing user. You do not need to create a User to login.** There are 3 prefilled Users to try out
- Admin - email: admin@csc517.org, password: admin
- Agent - email: agent1@test.org, password: agent1
- Customer - email: customer1@test.org, password: customer1

You may also create new accounts as an agent or a customer. Agents can create new tours
while customers can book, bookmark, or create a review for a tour.

Features to Test
====

User
----

1. Create/Login/Logout User
2. Edit Profile - Once you login, you can change your profile.
3. View all Users - Only if you are logged in as an admin.

Tour
----
1. You can create a Tour
2. You can book a Tour by number of seats
3. Enroll in a waitlist
4. Cancel a Tour entirely
5. Cancel seats on a Tour
6. Create a Review for a Completed Tour

Features Missing
====
The following features have NOT been implemented, so please keep this in mind while testing:

- Uploading or deleting photos of a tour
- Listing all customers who have booked or bookmarked a tour
- Allowing an agent to cancel a tour
- Searching tours using filters
- Removing a customer's booked seats upon deletion of their account

Authors:
====
- Ginger Balmat
- Bill Mwaniki

NCSU CSC 517 (OO Design and Development)
========================================
## Program 2: Ruby on Rails


Tour Management System: an application for Agents and Tour Guides

Getting Started
---
Program URL - http://ec2-54-191-251-98.us-west-2.compute.amazonaws.com/

**You can login as an existing user. You do not need to create a User to login.** There are 3 prefilled Users to try out
- Admin - email: admin@csc517.org, password: admin
- Agent - email: agent1@test.org, password: agent1
- Customer - email: customer1@test.org, password: customer1

You may also create new accounts as an agent or a customer. A user can be either a customer OR an agent.  
To test both types of users, please use 2 different accounts.

Features to Test
---

### User
1. Create/Login/Logout User
2. Edit Profile - Once you login, you can change your profile.
3. View all Users - Only if you are logged in as an admin.

### As an Agent
1. You can create a Tour  
2. You can cancel a Tour that you created  
    - Set the Tour's status to 'Canceled' to cancel the Tour  
    - This will automatically remove all bookmarked, booked, and waitlisted records for that Tour  
3. You can edit or delete a Tour that you have created  
    - Edit and Destroy links for each Tour can be found on the Tours List pages  
    - These links will be hidden for Tours not created by you
4. You can upload photos for a Tour that you created    
5. You can view a list of customers who have bookmarked or booked a tour created by you  
    - This list can be found on the Tour's page  
    - It will be hidden for Tours not created by you  
6. You can view a list of all Tours  
7. You can view customer reviews for all Tours  
### As a Customer
1. You can bookmark a Tour from the Tour's page  
2. You can book a Tour by number of seats from the Tour's page    
    - The 'Book Tour' button will be disabled if any of the following are true:  
      - the Tour's start date has already passed  
      - the booking deadline has already passed  
      - the Tour's status is set to 'Completed'  
      - the Tour's status is set to 'Cancelled'  
3. You can enroll in a waitlist  
    - Customers will be automatically waitlisted if they book more seats than are available
4. You can cancel all or some seats on a Tour  
    - The 'Cancel Seats' button will be disabled if any of the following are true:  
      - the Tour's start date has already passed
      - the booking deadline has already passed  
      - the Tour's status is set to 'Completed'  
      - the Tour's status is set to 'Cancelled'
5. You can create a Review for a Completed Tour  
    - The Tour's status must be set to 'Completed'   
    - When testing, please manually set the Tour's status to 'Completed'; the status  
      will not automatically update  
    - The 'Add Review' link will be disabled if you have not booked the Tour AND the Tour's  
      status is not set to 'Completed'   
6. You can edit or delete a Review that you created  
    - Edit and Destroy links for each Review can be found on the Reviews List pages
    - These links will be disabled for Reviews not created by you
7. You can search Tours  
    - The following fields can be searched and will be AND'd when applied together:  
      - Status  
      - Name  
      - Price  
      - From Date  
      - To Date  
      - State/Province  
      - Country
### As an Admin
1. You can perform all previously listed actions for Agents and Customers  
2. You can also view a list of all users  
3. You can also edit or delete all users  
4. You can edit your account  
    - You many not delete your account

Features Missing
---
The following features have not been implemented:  
1. Sending emails to customers  
2. Allowing users to log in using social media accounts

Authors:
---
- Ginger Balmat
- Bill Mwaniki
- Srikara Kanduri

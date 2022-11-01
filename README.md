# class_manager

A Flutter project to manage and track student information and progress using in app SQLite DB.

## Feature
- Manage student information
- Assign/ Remove session for each student
- Visualize student progress
- Track student fees payment history
- Create and restore from local backup

## Working
- ### Student List page: 
  It is the home page showing list of student and their sessions. For new users the home page will be initially empty.
  <p>
    <img src='/Images/HomePage.png' width = 200, height = 400>
  </p>
  Users can click on floating button to add new student info. Except <i>ParentPhoneNumber2</i> all other fields are required and validations are also applied for the same. Class and Board details are fetched from the list of data under <b>ClassDetails</b> page. Upon successful creation a <i>SnackBar</i> will be displayed the bottom. 
  By clicking on the search icon on the top right, users can search for student data using the following filter:
  - Class
  - Board
  - Subject
  - Student Name
  - Session start and end time
  <p>
  Student addition:<br>
  <img src='/Images/Screenshot_1667227281.png' width = 200, height = 400>
  <img src='/Images/Screenshot_1667227518.png' width = 200, height = 400>
  <img src='/Images/Screenshot_1667227532.png' width = 200, height = 400>
  <img src='/Images/Screenshot_1667227554.png' width = 200, height = 400>
  <br>
  </p>
  
  <p>
  After student addition:<br>
  <img src='/Images/Screenshot_1667227560.png' width = 200, height = 400>
  <img src='/Images/Screenshot_20221101-224103.png' width = 200, height = 400>
  </p>
  
  <p>
  Searching for student based on subject:<br>
  <img src='/Images/Screenshot_20221101-224108.png' width = 200, height = 400>
  <img src='/Images/Screenshot_20221101-224122.png' width = 200, height = 400>
  </p>
- ### Class details: 
  Contains list of Classes, Boards, and Subjects. Users can add/remove items which will then be reflected in student or session page. Press the Plus button on the appbar to add new items to the respective list and delete icon to remove item.
  <p>
    <img src='/Images/Screenshot_1667227245.png' width = 200, height = 400>
    <img src='/Images/Screenshot_1667227261.png' width = 200, height = 400>
    <img src='/Images/Screenshot_1667227265.png' width = 200, height = 400>
    <img src='/Images/Screenshot_1667227267.png' width = 200, height = 400>
  
    <p>
      Addition of items:<br>
      <img src='/Images/Screenshot_1667227868.png' width = 200, height = 400>
      <img src='/Images/Screenshot_1667227874.png' width = 200, height = 400>
      <img src='/Images/Screenshot_1667227878.png' width = 200, height = 400><br>
      Deletion of items:<br>
      <img src='/Images/Screenshot_1667227909.png' width = 200, height = 400>
    </p>
  </p>
- ### Statistics: 
  Will show total students and total fees at the top followed the in-depth grouped data on the basis of class, board, and subject.
  The tabular data will be empty unless a student with a session is created with atleast fees payment completed for atleast one month.
  <p>
    <img src='/Images/Screenshot_1667227248.png' width = 200, height = 400>  
    <img src='/Images/Screenshot_20221101-223950.png' width = 200, height = 400>  
  </p>
- ### Backup: 
  Enables to create a local backup and restore back from the same location
  <p>
    <img src='/Images/Screenshot_1667227251.png' width = 200, height = 400>  
  </p>

#### Session:
A session is created by selecting the subject, time slot and fees for a particular student. Once a session is created it will be shown under student list for the respective student. 
<p>
  Session creation:<br>
  <img src='/Images/Screenshot_1667227581.png' width = 200, height = 400>  
  <img src='/Images/Screenshot_1667227600.png' width = 200, height = 400>  
  <img src='/Images/Screenshot_1667227608.png' width = 200, height = 400>  
  <img src='/Images/Screenshot_1667227630.png' width = 200, height = 400>  
</p>
### Fees

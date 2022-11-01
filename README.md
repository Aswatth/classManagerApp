# class_manager

A Flutter project to manage and track student informatio and progress.

## Feature
- Manage student information
- Assign/ Remove session for each student
- Visualize student progress
- Track student fees payment history

## Working
- ### Student List page: 
  It is the home page showing list of student and their sessions. For new users the home page will be initially empty.
  <p>
    <img src='/Images/HomePage.png' width = 100, height = 200>
  </p>
  Users can click on floating button to add new student info. Except <i>ParentPhoneNumber2</i> all other fields are required and validations are also applied for the same. Class and Board details are fetched from the list of data under <b>ClassDetails</b> page. Upon successful creation a <i>SnackBar</i> will be displayed the bottom.
  <p>
  <img src='/Images/Screenshot_1667227281.png' width = 100, height = 200>
  <img src='/Images/Screenshot_1667227518.png' width = 100, height = 200>
  <img src='/Images/Screenshot_1667227532.png' width = 100, height = 200>
  <img src='/Images/Screenshot_1667227554.png' width = 100, height = 200>
  <img src='/Images/Screenshot_1667227560.png' width = 100, height = 200>
  </p>
  
- ### Class details: 
  Contains list of Classes, Boards, and Subjects. Users can add/remove items which will then be reflected in student or session page. Press the Plus button on the appbar to add new items to the respective list and delete icon to remove item.
  <p>
    <img src='/Images/Screenshot_1667227245.png' width = 100, height = 200>
    <img src='/Images/Screenshot_1667227261.png' width = 100, height = 200>
    <img src='/Images/Screenshot_1667227265.png' width = 100, height = 200>
    <img src='/Images/Screenshot_1667227267.png' width = 100, height = 200>
  
    <p>
      Addition:<br>
      <img src='/Images/Screenshot_1667227868.png' width = 100, height = 200>
      <img src='/Images/Screenshot_1667227874.png' width = 100, height = 200>
      <img src='/Images/Screenshot_1667227878.png' width = 100, height = 200><br>
      Deletion:<br>
      <img src='/Images/Screenshot_1667227909.png' width = 100, height = 200>
    </p>
  </p>
- Statistics: 
  <p>
    <img src='/Images/Screenshot_1667227248.png' width = 100, height = 200>  
  </p>
- Backup: 
  <p>
    <img src='/Images/Screenshot_1667227251.png' width = 100, height = 200>  
  </p>

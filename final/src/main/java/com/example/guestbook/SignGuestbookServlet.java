/**
 * Copyright 2014-2015 Google Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

//[START all]
package com.example.guestbook;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.util.List;



import com.googlecode.objectify.ObjectifyService;

/**
 * Form Handling Servlet
 * Most of the action for this sample is in webapp/guestbook.jsp, which displays the
 * {@link Group}'s. This servlet has one method
 * {@link #doPost(<#HttpServletRequest req#>, <#HttpServletResponse resp#>)} which takes the form
 * data and saves it.
 */
public class SignGuestbookServlet extends HttpServlet {
	
  // Process the http POST of the form
  @Override
  public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    Group group;
    Student student;
    
    //UserService userService = UserServiceFactory.getUserService();
    //User user = userService.getCurrentUser();  // Find out who the user is.

    String groupID = req.getParameter("groupid");
    String guestbookName = req.getParameter("guestbookName");
    String selectedGroup = req.getParameter("selectedGroup");
    String instructor = req.getParameter("instructor");
    String place = req.getParameter("place");
    String time = req.getParameter("time");
    if(!groupID.isEmpty()) {
	    if (!instructor.isEmpty() || !place.isEmpty() || time.isEmpty()) {
	      group = new Group(guestbookName, groupID, instructor, place, time);
		  ObjectifyService.ofy().save().entity(group).now();
	    } else {
	      group = new Group(guestbookName, groupID);
		  ObjectifyService.ofy().save().entity(group).now();
	    }
    }
    if (user != null) {
        if(selectedGroup != "") {
			student = new Student(guestbookName, user.getEmail(),  selectedGroup);
	        ObjectifyService.ofy().save().entity(student).now();
        }
    }

    // Use Objectify to save the  and now() is used to make the call synchronously as we
    // will immediately get a new page using redirect and we want the data to be present.
    
    resp.sendRedirect("/guestbook.jsp?guestbookName=" + guestbookName);
  }
  
  protected void doGet(HttpServletRequest request, HttpServletResponse response)  
          throws ServletException, IOException {  

    String guestbookName = request.getParameter("guestbookName");
    com.googlecode.objectify.Key<Guestbook> theBook = com.googlecode.objectify.Key.create(Guestbook.class, guestbookName);
    Student student;
    int found = 0;
    
	HttpSession session=request.getSession(false);  
	if(session!=null){  
		String name=(String)session.getAttribute("name");  
		 List<Student> curStudents = ObjectifyService.ofy()
		          .load()
		          .type(Student.class) // We want only Groups
		          .ancestor(theBook)   // Anyone in this book    // Most recent first - date is indexed.            // Only show 5 of them.
		          .list();
		 if (!curStudents.isEmpty()) {	 
			 for (Student curStudent : curStudents) {    
	                if(name.equals(curStudent.student_email)){ 
	                		found = 1;
	                		break;
	                }
			 }
		 }
		 if(found == 0) {
			student = new Student(guestbookName, name);
	        ObjectifyService.ofy().save().entity(student).now();
		 }	
	}  
	 response.sendRedirect("/guestbook.jsp?guestbookName=" + guestbookName);
}

}
//[END all]

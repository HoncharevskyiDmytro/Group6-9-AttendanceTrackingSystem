<%-- //[START all]--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>

<%-- //[START imports]--%>
<%@ page import="com.example.guestbook.Group" %>
<%@ page import="com.example.guestbook.Guestbook" %>
<%@ page import="com.example.guestbook.Student" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page  import="com.google.appengine.api.datastore.PreparedQuery" %>
<%@ page  import="com.google.appengine.api.datastore.Query" %>
<%@ page  import="com.google.appengine.api.datastore.Query.Filter" %>
<%@ page  import="com.google.appengine.api.datastore.Query.FilterOperator" %>
<%@ page  import="com.google.appengine.api.datastore.Query.FilterPredicate" %>
<%@ page  import="com.google.appengine.api.datastore.Query.SortDirection" %>

<%@ page import="com.googlecode.objectify.ObjectifyService" %>
<%-- //[END imports]--%>

<%@ page import="java.util.List" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
    <link type="text/css" rel="stylesheet" href="/stylesheets/main.css"/>
</head>

<body>

<%

    String guestbookName = request.getParameter("guestbookName");
    String selectedGroup = request.getParameter("selectedGroup");
    // Create the correct Ancestor key
    if (guestbookName == null) {
        guestbookName = "default";
    }
    if (selectedGroup == null) {
        selectedGroup = "default";
    }
    pageContext.setAttribute("guestbookName", guestbookName);

    com.googlecode.objectify.Key<Guestbook> theBook = com.googlecode.objectify.Key.create(Guestbook.class, guestbookName);

    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user != null) {
        pageContext.setAttribute("user", user);

%>
<p>Hello, ${fn:escapeXml(user.nickname)}! (You can
    <a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>
<%
		String e = user.getEmail();
		//Student curStudent = ObjectifyService.ofy().load().type(Student.class).id(user.getEmail()).now();
		//Student curStudent = ObjectifyService.ofy().load().type(Student.class).ancestor(theBook).filter("student_email", e).last().now();
		
com.googlecode.objectify.Key<Student> StuKey = com.googlecode.objectify.Key.create(Student.class, user.getEmail());  


     List<Student> curStudents = ObjectifyService.ofy()
          .load()
          .type(Student.class) // We want only Groups
          .ancestor(theBook)   // Anyone in this book    // Most recent first - date is indexed.            // Only show 5 of them.
          .list();

	    pageContext.setAttribute("email", user.getEmail());	    
    %>

<p> ${fn:escapeXml(email)}!!</p>
    <%
	   // if(curStudent != null){
    if (curStudents.isEmpty()) {	   
	           //pageContext.setAttribute("studentemail", curStudent.student_email);	    	
    %>
<p> query fail!!</p>

    <%   
     }else{
    %>
<p> find students!!</p>

    <% 
            for (Student curStudent : curStudents) {    
            	//if(curStudent.student_email == user.getEmail()){
                if(e.equals(curStudent.student_email)){
                //pageContext.setAttribute("emailaddress", curStudent.student_email);
                	//pageContext.setAttribute("cur_groupid", curStudent.groupid);
    %>
<p> find this student!!</p>

    <% 

			    	if(curStudent.groupid != null){
			          pageContext.setAttribute("cur_groupid", curStudent.groupid);
			    	
    %>
<p>You are in Group ${fn:escapeXml(cur_groupid)}!</p>

    <%
    	}
    	else{
    %>
<p>You are not in any group!</p>

    <%
    }
}
    }
	
      }

    } else {
%>
<p>Hello!
    <a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
    to include your name with greetings you post.</p>

<%
    }

      List<Group> greetings = ObjectifyService.ofy()
          .load()
          .type(Group.class) // We want only Groups
          .ancestor(theBook)    // Anyone in this book    // Most recent first - date is indexed.            // Only show 5 of them.
          .list();
    // Run an ancestor query to ensure we see the most up-to-date
    // view of the Groups belonging to the selected Guestbook.
    if (greetings.isEmpty()) {
%>
<p>Lecture '${fn:escapeXml(guestbookName)}' has no groups.</p>
<%
    }else{

            for (Group currentGroup : greetings) {    
                pageContext.setAttribute("group_id", currentGroup.groupid);
                pageContext.setAttribute("group_instructor", currentGroup.instructor);
                pageContext.setAttribute("group_time", currentGroup.exerciese_time);
                pageContext.setAttribute("group_place", currentGroup.exercise_place);
%>
<p>GroupID '${fn:escapeXml(group_id)}':</p>
<blockquote>Instructor '${fn:escapeXml(group_instructor)}'</blockquote>
<blockquote>Exercise Time '${fn:escapeXml(group_time)}'</blockquote>
<blockquote>Exercise Place '${fn:escapeXml(group_place)}'</blockquote>

<%
        }      
}

      List<Student> students = ObjectifyService.ofy()
          .load()
          .type(Student.class) // We want only Groups
          .ancestor(theBook)    // Anyone in this book    // Most recent first - date is indexed.            // Only show 5 of them.
          .list();
    // Run an ancestor query to ensure we see the most up-to-date
    // view of the Groups belonging to the selected Guestbook.
    if (students.isEmpty()) {
%>
<p>Lecture '${fn:escapeXml(guestbookName)}' has no students.</p>
<%
    }else{

            for (Student student : students) {    
                pageContext.setAttribute("emailaddress", student.student_email);
                pageContext.setAttribute("g", student.groupid);

%>
<p>emailaddress '${fn:escapeXml(emailaddress)}':</p>
<p>group '${fn:escapeXml(g)}':</p>
<%
        }      
}
%>
    

<form action="/sign" method="post">
    <div><p>GroupID</p><textarea name="groupid" rows="3" cols="60"></textarea></div>
    <div><p>instructor</p><textarea name="instructor" rows="3" cols="60"></textarea></div>
    <div><p>exercise time</p><textarea name="time" rows="3" cols="60"></textarea></div>
    <div><p>exercise place</p><textarea name="place" rows="3" cols="60"></textarea></div>
    <div><p>Select Group</p><input type="text" name="selectedGroup"/></div>
    <div><input type="submit" value="Post Group"/></div>
    <input type="hidden" name="guestbookName" value="${fn:escapeXml(guestbookName)}"/>

</form>
<%-- //[END datastore]--%>
<form action="/guestbook.jsp" method="get">
    <div><input type="text" name="guestbookName" value="${fn:escapeXml(guestbookName)}"/></div>
    <div><input type="submit" value="Switch Course"/></div>
</form>

</body>
</html>
<%-- //[END all]--%>

<%-- //[START all]--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>

<%-- //[START imports]--%>
<%@ page import="com.example.guestbook.Group" %>
<%@ page import="com.example.guestbook.Guestbook" %>
<%@ page import="com.example.guestbook.Student" %>
<%@ page import="com.example.guestbook.Model" %>
<%@ page import="com.example.guestbook.Controller" %>
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
    
    Model myModel   = new Model();
    Controller myController = new Controller();
    myController.addModel(myModel);
    //myController.addView(myView);


    String guestbookName = request.getParameter("guestbookName");
    String selectedGroup = request.getParameter("selectedGroup");
    int found = 0;
    Student student;
    // Create the correct Ancestor key
    if (guestbookName == null) {
        guestbookName = "default";
    }
    if (selectedGroup == null) {
        selectedGroup = "default";
    }
    pageContext.setAttribute("guestbookName", guestbookName);

    com.googlecode.objectify.Key<Guestbook> theBook = com.googlecode.objectify.Key.create(Guestbook.class, guestbookName);

<<<<<<< HEAD
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user != null) {
        myController.initModel(guestbookName, user);
=======
    HttpSession session=request.getSession(false);  
    if(session!=null){  
        String name=(String)session.getAttribute("name");  
>>>>>>> refs/remotes/origin/Exercise2
        pageContext.setAttribute("user", user);

%>
<p>Hello, ${fn:escapeXml(user.nickname)}! (You can
<<<<<<< HEAD
    <a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>
=======
    <a href="LogoutServlet">sign out</a>.)</p>
<%
     List<Student> curStudents = ObjectifyService.ofy()
          .load()
          .type(Student.class) // We want only Groups
          .ancestor(theBook)   // Anyone in this book    // Most recent first - date is indexed.            // Only show 5 of them.
          .list();

    pageContext.setAttribute("email", user.getEmail());	    
%>

<p> ${fn:escapeXml(email)}!!</p>
>>>>>>> refs/remotes/origin/Exercise2
    <%
        Student curStudent = myModel.getStudent();
        if(curStudent.groupid != null){
            pageContext.setAttribute("cur_groupid", curStudent.groupid);
            Group curGroup = myModel.getGroup();
            pageContext.setAttribute("group_id", curGroup.groupid);
            pageContext.setAttribute("group_instructor", curGroup.instructor);
            pageContext.setAttribute("group_time", curGroup.exerciese_time);
            pageContext.setAttribute("group_place", curGroup.exercise_place);
    %>
<p>You are in Group ${fn:escapeXml(cur_groupid)}!</p>
<p>GroupID '${fn:escapeXml(group_id)}':</p>
<blockquote>Instructor '${fn:escapeXml(group_instructor)}'</blockquote>
<blockquote>Exercise Time '${fn:escapeXml(group_time)}'</blockquote>
<blockquote>Exercise Place '${fn:escapeXml(group_place)}'</blockquote>
    <%
        }else{
    %>
    <p>You are not in any group, please register!</p>
        <%
            List<Group> groups = myModel.getGroups();
        // Run an ancestor query to ensure we see the most up-to-date
        // view of the Groups belonging to the selected Guestbook.
            if (groups.isEmpty()) {
        %>
        <p>Lecture '${fn:escapeXml(guestbookName)}' has no groups.</p>
        <%
            }else{

                    for (Group currentGroup : groups) {    
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
        }
    } else {
%>
<p>Hello!
<<<<<<< HEAD
    <a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
    to include your name with groups you post.</p>
=======
    <a href="login.html">Sign in</a>
    to include your name with greetings you post.</p>
>>>>>>> refs/remotes/origin/Exercise2
<%
    }
%>

      
<form action="/sign" method="post">
    <div><p>Select Group</p><input type="text" name="selectedGroup"/></div>
    <div><input type="submit" value="Register Group"/></div>
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

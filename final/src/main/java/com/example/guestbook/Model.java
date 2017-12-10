package com.example.guestbook;

import java.util.List;
import java.util.Observable;

import com.google.appengine.api.users.User;
import com.googlecode.objectify.Key;
import com.googlecode.objectify.ObjectifyService;

public class Model extends Observable {
    Student curStudent;
    Group curGroup;
    Key<Guestbook> theBook;
	public Model() {
		
	}
	//create student if not exists
	public void setStudent(String guestbookName, User user) {
	    this.theBook = com.googlecode.objectify.Key.create(Guestbook.class, guestbookName);
		if(!foundStudent(user)) {
			Student student = new Student(guestbookName, user.getEmail(), user.getUserId());
			ObjectifyService.ofy().save().entity(student).now();
			this.curStudent = student;
        }
	}
	public boolean foundStudent(User user) {
		boolean found = false;
		List<Student> curStudents = ObjectifyService.ofy()
		          .load()
		          .type(Student.class) // We want only Groups
		          .ancestor(theBook)   // Anyone in this book    // Most recent first - date is indexed.            // Only show 5 of them.
		          .list();
		if (!curStudents.isEmpty()) {
	        for (Student curStudent : curStudents) {    
	            if(user.getEmail().equals(curStudent.student_email)){ 
		            found = true;
	            		this.curStudent = curStudent;
		            break;
	            }
	        }
	    }
		return found;
	}
	public Student getStudent() {
		return curStudent;
	}
	public Group getGroup() {
		 List<Group> groups = ObjectifyService.ofy()
	              .load()
	              .type(Group.class) // We want only Groups
	              .ancestor(theBook)    // Anyone in this book    // Most recent first - date is indexed.            // Only show 5 of them.
	              .list();
	    if (!groups.isEmpty()) {
            for (Group currentGroup : groups)     
            		if(curStudent.groupid.equals(currentGroup.groupid))
            			this.curGroup = currentGroup;    
	    }else {
	    	 	this.curGroup = new Group("default", "default", "default", "default", "default");
	    } 
	   return curGroup;
	}
	public List<Group> getGroups() {
		 List<Group> groups = ObjectifyService.ofy()
	              .load()
	              .type(Group.class) // We want only Groups
	              .ancestor(theBook)    // Anyone in this book    // Most recent first - date is indexed.            // Only show 5 of them.
	              .list();
		 return groups;
	}
	public void registerGroup(String guestbookName, User user, String groupid) {
		Student student = new Student(guestbookName, user.getEmail(), groupid);
        ObjectifyService.ofy().save().entity(student).now();
        setChanged();
        notifyObservers(student);
	}
	public void createGroup(String lecture, String groupid, String instructor, String place, String time) {
      Group group = new Group(lecture, groupid, instructor, place, time);
	  ObjectifyService.ofy().save().entity(group).now();
	}
	public void createGroups(String lecture) {
		Group group1 = new Group(lecture, "1", "Ann", "MI1", "Mo");
		Group group2 = new Group(lecture, "2", "Lena", "MI2", "Do");
		Group group3 = new Group(lecture, "3", "Tom", "MI3", "Mi");
		Group group4 = new Group(lecture, "4", "Steffen", "MI4", "Di");
		Group group5 = new Group(lecture, "5", "Julian", "MI5", "Fr");
		ObjectifyService.ofy().save().entities(group1, group2, group3, group4, group5).now(); 
	}
}

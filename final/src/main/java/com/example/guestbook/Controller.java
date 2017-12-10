package com.example.guestbook;

import com.google.appengine.api.users.User;

public class Controller {	
	Model model;
	public Controller() {
		
	}
	
	public void initialize() {
		
	}
	
	public void addModel(Model m){
		System.out.println("Controller: adding model");
		this.model = m;
	} //addModel()
	
	public void initModel(String guestbookName, User user){
		model.setStudent(guestbookName, user);
		model.createGroups(guestbookName);
	} //initModel()
	
}

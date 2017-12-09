package com.example.guestbook;

import java.util.List;

import org.restlet.resource.Get;
import org.restlet.resource.ServerResource;

import com.googlecode.objectify.Key;
import com.googlecode.objectify.ObjectifyService;

public class GreetingResource extends ServerResource {
	
	@Get("xml")
	public String represent() {
	    Key<Guestbook> theBook = Key.create(Guestbook.class, "default");
	    
	    long id = Long.parseLong(getAttribute("id"));
	    System.err.println("Getting object with Id "+id);
	    Greeting greeting;

	    greeting = ObjectifyService.ofy()
	    		 .load()
	    		 .type(Greeting.class) // We want only Greetings
	    		 .parent(theBook) // Anyone in this book
	    		 .id(id)
	    		 .now();
	    if(greeting == null) {
	    		return "<error>No such greeting</error>";
	    }
	    
	    String ret = "";   
		ret += "<greeting>\n";
		ret += "<id>"+greeting.id+ "</id>";
		ret += "<author>"+greeting.author_id+"</author>\n";
		ret += "<email>"+greeting.author_email+"</email>\n";
		ret += "<content>"+greeting.content+"</content>\n";
		ret += "<date>"+greeting.date+"</date>\n";
		ret += "</greeting>";
		 
		return ret;
	}
}

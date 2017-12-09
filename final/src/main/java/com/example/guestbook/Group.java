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

import com.googlecode.objectify.Key;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;
import com.googlecode.objectify.annotation.Parent;

import java.lang.String;
import java.util.Date;
import java.util.List;

/**
 * The @Entity tells Objectify about our entity.  We also register it in {@link OfyHelper}
 * Our primary key @Id is set automatically by the Google Datastore for us.
 *
 * We add a @Parent to tell the object about its ancestor. We are doing this to support many
 * guestbooks.  Objectify, unlike the AppEngine library requires that you specify the fields you
 * want to index using @Index.  Only indexing the fields you need can lead to substantial gains in
 * performance -- though if not indexing your data from the start will require indexing it later.
 *
 * NOTE - all the properties are PUBLIC so that we can keep the code simple.
 **/
@Entity
public class Group {
  @Parent Key<Guestbook> theBook;
  @Id String id;
  public String groupid;
  public String exerciese_time;
  public String exercise_place;
  public String instructor; //instructor
  @Index public Date date;

  /**
   * Simple constructor just sets the date
   **/
  public Group() {
    date = new Date();
  }

  /**
   * A convenience constructor
   **/
  public Group(String book, String groupid) {
    this();
    if( book != null ) {
      this.theBook = Key.create(Guestbook.class, book);  // Creating the Ancestor key
    } else {
      this.theBook = Key.create(Guestbook.class, "default");
    }
    this.id = groupid;
    this.groupid = groupid;
  }

  /**
   * Takes all important fields
   **/
  public Group(String book, String groupid, String instructor, String place, String time) {
    this(book, groupid);
    this.instructor = instructor;
    exerciese_time = time;
    exercise_place = place;
  }

}
//[END all]
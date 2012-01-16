__OVERVIEW__


| Project         | pry-developer\_tools    
|:----------------|:--------------------------------------------------
| Homepage        | https://github.com/pry/pry-developer_tools
| Documentation   | http://github.com/pry/pry-developer_tools/
| Author          | Pry Team             


__DESCRIPTION__

  pry-developer\_tools is a collection of Pry commands that are useful for Pry  
  developers and Pry plugin developers. It provides commands that you can use   
  to edit, reload, or define commands while in a Pry session.  

__EXAMPLES__

* define-command
        
        # Define a command in-memory (for length of Pry session)
        (pry) > define-command "name", "desc" do
          p "Do something!"
        end

* edit-command

        # Perform a edit of show-method that will persist.
        (pry) > edit-command show-method

        # Perform a in-memory edit of show-method.
        (pry) > edit-command -p show-method

* reload-command

        # Reload a Pry command from disk.
        (pry) > reload-command edit-method

__PRY SUPPORT__

Versions >= 0.9.8 

__INSTALL__

  gem install pry-developer\_tools

__LICENSE__

  
  Same license as Pry (MIT).


 


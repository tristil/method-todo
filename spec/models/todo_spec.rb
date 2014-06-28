require 'spec_helper'

describe Todo do
  it "requires a description" do
    Todo.new.should have(1).error_on(:description)
  end

  it "sets each ranking to 0 and updates other todos' rankings, per user" do
    user = User.create!(username: "Example",
                       email: "example@example.com",
                       password: "Password1")
    user2 = User.create!(username: "Example2",
                         email: "example2@example.com",
                         password: "Password1")

    todo1 = Todo.new(description: 'Do something')
    todo1.user = user
    todo1.save!
    todo1.ranking.should == 0

    todo2 = Todo.new(description: 'Do something else')
    todo2.user = user
    todo2.save!
    todo2.ranking.should == 0
    todo1.reload.ranking.should == 1

    todo3 = Todo.new(description: 'Do yet another thing')
    todo3.user = user2
    todo3.save!
    todo3.ranking.should == 0
    todo2.reload.ranking.should == 0
    todo1.reload.ranking.should == 1
  end

  specify "#user return user" do
    user = User.create(:username => "Example", :email => "example@example.com", :password => "Password1")
    user.should have(0).errors
    todo = Todo.create(:description => "A New Todo")
    todo.user = user
    todo.save!
    todo = Todo.find_by_id todo.id
    todo.user.should == user
  end

  describe "#for_options" do
    let!(:context1) { TodoContext.create!(name: 'work')  }
    let!(:context2) { TodoContext.create!(name: 'home')  }
    let!(:tag) { Tag.create!(name: 'boring') }
    let!(:tag2) { Tag.create!(name: 'interesting') }
    let!(:project) { Project.create!(name: 'quiche') }
    let!(:project2) { Project.create!(name: 'pie') }
    let!(:todo1) { Todo.create!(description: 'Do something') }
    let!(:todo2) { Todo.create!(description: 'Do something else') }
    let!(:todo3) { Todo.create!(description: 'Do something nu') }

    it "returns active todos if completed is not passed in" do
      todo2.complete
      todo2.save!
      Todo.for_options.should == [todo1, todo3]
    end

    it "returns 'tickler' todos if tickler is passed in" do
      todo1.tickler = true
      todo1.save!
      todo3.tickler = true
      todo3.save!
      Todo.for_options(tickler: true).should == [todo1, todo3]
    end

    it "returns completed todos if completed is passed in" do
      todo1.complete
      todo1.save!
      todo3.complete
      todo3.save!
      Todo.for_options(completed: 1).should == [todo1, todo3]
    end

    it "returns todos for a context if context_id is passed in" do
      todo1.todo_contexts << context1
      todo2.todo_contexts << context2
      todo3.todo_contexts << context1
      Todo.for_options(context_id: context1.id).should == [todo1, todo3]
    end

    it "returns todos for a tag if tag_id is passed in" do
      todo1.tags << tag
      todo2.tags << tag2
      todo3.tags << tag
      Todo.for_options(tag_id: tag.id).should == [todo1, todo3]
    end

    it "returns todos for a project if project_id is passed in" do
      todo1.project = project
      todo1.save!
      todo2.project = project2
      todo2.save!
      todo3.project = project
      todo3.save!
      Todo.for_options(project_id: project.id).should == [todo1, todo3]
    end
  end

  specify "#complete marks record as completed and sets completed time" do
    todo = Todo.create(:description => "A New Todo")
    todo.complete
    todo.save!
    todo.reload
    todo.completed.should be_true
  end

  specify "#uncomplete marks record as not completed and clears completed time" do
    todo = Todo.create(:description => "A New Todo")
    todo.uncomplete
    todo.save!
    todo.reload
    todo.completed.should be_false
  end

  specify"#destroy uses Acts as Paranoid to virtually delete the todo" do
    todo = Todo.create(:description => "A New Todo")
    todo.destroy
    Todo.all.should == []
    Todo.only_deleted.should == [todo]
  end

  specify"#todo_contexts returns contexts of this todo" do
    todo = Todo.create(:description => "A New Todo")
    todo_context = TodoContext.create(:name => 'home')
    todo.todo_contexts << todo_context
    todo.save!
    todo.reload
    todo.todo_contexts.should == [todo_context]
  end

  specify "#todo_context returns the first context" do
    todo = Todo.create(:description => "A New Todo")
    todo_context = TodoContext.create(:name => 'home')
    todo.todo_contexts << todo_context
    todo.save!
    todo.reload
    todo.todo_context.should == todo_context
  end

  specify "#project returns the project" do
    todo = Todo.create(:description => "A New Todo")
    project = Project.create(:name => 'TP Report')
    todo.project = project
    todo.save!
    todo.reload
    todo.project.should == project
  end
end

describe Todo, "#parse" do
  it "adds or creates a new Project when it detects +" do
    user = User.create(:username => "Example", :email => "example@example.com", :password => "Password1")
    todo = Todo.create :description => 'Write first draft +report'
    todo.user = user
    todo.save!
    todo.parse
    todo.project.name.should == 'report'
    todo.project.should_not be_nil

    todo2 = Todo.create :description => 'Write second draft +report'
    todo2.user = user
    todo2.save!
    todo2.parse
    todo2.project.should == todo.project
    todo2.project.should_not be_nil
  end

  it "adds or creates a new Context when it detects @" do
    user = User.create(:username => "Example", :email => "example@example.com", :password => "Password1")
    todo = Todo.create :description => 'Write first draft @home @coffeeshop'
    todo.user = user
    todo.save!
    todo.parse
    todo.todo_contexts.first.name.should == 'home'

    todo2 = Todo.create :description => 'Write second draft @coffeeshop @home'
    todo2.user = user
    todo2.save!
    todo2.parse
    todo2.reload
    todo2.todo_contexts.should == todo.todo_contexts
  end

  it "adds or creates a new Tag when it detects #" do
    user = User.create(:username => "Example", :email => "example@example.com", :password => "Password1")
    todo = Todo.create :description => 'Write first draft #homework #Q1'
    todo.user = user
    todo.save!
    todo.parse
    todo.tags.first.name.should == 'homework'

    todo2 = Todo.create :description => 'Write second draft #Q1 #homework'
    todo2.user = user
    todo2.save!
    todo2.parse
    todo2.reload
    todo2.tags.should == todo.tags
  end

  it "re-parses line if data seems out of sync" do
    user = User.create(:username => "Example", :email => "example@example.com", :password => "Password1")
    todo = Todo.new :description => 'Write first draft #homework'
    todo.user = user
    todo.save!
    lambda { todo.parsed_description }.should_not raise_error
    todo.tags.should_not be_empty
    todo.tags.first.name.should == 'homework'
  end


  it "#parsed_description outputs correct line html" do
    user = User.create(:username => "Example", :email => "example@example.com", :password => "Password1")
    todo = Todo.create :description => 'Write report'
    todo.user = user
    todo.save!
    todo.parse
    todo.parsed_description.should == 'Write report'

    todo.description = "Write first draft +report"
    todo.save!
    todo.parse
    todo.parsed_description.should == "Write first draft <a href='#' class='project-badge-1 todo-badge'><span class='label label-default'>+report</span></a>"

    todo.description = "Write report @home"
    todo.save!
    todo.parse
    todo.parsed_description.should == "Write report <a href='#' class='context-badge-1 todo-badge'><span class='label label-default'>@home</span></a>"

    todo.description = "Write report #homework"
    todo.save!
    todo.parse
    todo.parsed_description.should == "Write report <a href='#' class='tag-badge-1 todo-badge'><span class='label label-default'>#homework</span></a>"

    todo.description = "Write first draft +report @home #homework"
    todo.save!
    todo.parse
    todo.parsed_description.should == "Write first draft <a href='#' class='project-badge-1 todo-badge'><span class='label label-default'>+report</span></a> <a href='#' class='context-badge-1 todo-badge'><span class='label label-default'>@home</span></a> <a href='#' class='tag-badge-1 todo-badge'><span class='label label-default'>#homework</span></a>"

    Timecop.freeze(Date.new(2012, 5, 1)) do
      todo.description = "Write first draft #homework"
      todo.complete
      todo.save!
      todo.parsed_description.should == "Write first draft <a href='#' class='tag-badge-1 todo-badge'><span class='label label-default'>#homework</span></a> <span class='completed-badge label label-default label-inverse'>5/01/2012</span>"
    end
  end

  it "#local_completed_time returns value for current_user's timezone" do
    user = User.create(:username => "Example", :email => "example@example.com", :password => "Password1")
    todo = Todo.create :description => 'Write first draft +report'
    todo.user = user
    todo.save!

    user.preferences[:timezone_offset] = -5
    user.save!

    Timecop.freeze(DateTime.new(2012, 5, 1, 23, 59, 59)) do
      todo.parse
      todo.complete
      todo.save!
    end
    todo.local_completed_time.to_formatted_s(:american).should == '5/01/2012'

    user.preferences[:timezone_offset] = 0
    user.save!

    todo.local_completed_time.to_formatted_s(:american).should == '5/02/2012'
  end
end

describe Todo, "#strip_text" do
  it "removes text from description" do
    user = User.create(:username => "Example", :email => "example@example.com", :password => "Password1")

    todo = Todo.create :description => 'Write first draft +report @home'
    todo.user = user
    todo.parse
    todo.save!

    todo2 = Todo.create :description => 'Write final draft +report @work'
    todo2.user = user
    todo2.parse
    todo2.save!

    todos = user.todos.strip_text! '+report'

    todo.reload.description.should == 'Write first draft @home'
    todo2.reload.description.should == 'Write final draft @work'
  end
end

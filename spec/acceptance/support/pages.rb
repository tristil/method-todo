module Acceptance
  module Pages
    def should_be_on_login_page
      page.should have_content 'Signup'
      page.should have_content 'Login'
    end

    def should_be_on_main_todo_page
      page.should have_content 'Logout'
      page.should have_css '.todo-list-table'
    end
  end
end

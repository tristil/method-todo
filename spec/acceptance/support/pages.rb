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

    def click_help_link
      click_link 'Show help'
    end

    def close_help_link
      click_link 'Dismiss this'
    end

    def should_see_help_text
      page.should have_css('#help-box', text: 'How do it work?')
    end

    def should_not_see_help_text
      page.should_not have_css('#help-box')
    end
  end
end

module Acceptance
  module Badges
    def click_badge(name)
      find('a.todo-badge span', text: name).click
    end
  end
end

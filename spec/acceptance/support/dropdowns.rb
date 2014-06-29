module Acceptance
  module Dropdowns
    def should_see_dropdown_items(**options)
      options.each do |type, items|
        open_dropdown(type)
        all("##{type}-dropdown-navitem ul li a").each do |item|
          next if ['Any', 'Manage...'].include?(item[:text])
          items.should include(item[:text])
        end
      end
    end

    def should_see_dropdown_selections(context: nil, project: nil, tag: nil)
      context ||= 'Context'
      project ||= 'Project'
      tag ||= 'Tag'
      should_see_dropdown_selection(type: :context, label: context)
      should_see_dropdown_selection(type: :project, label: project)
      should_see_dropdown_selection(type: :tag, label: tag)
    end

    def should_see_no_dropdown_selection
      should_see_dropdown_selections
    end

    def should_see_dropdown_selection(type:, label:)
      page.should have_css("li##{type}-dropdown-navitem a.dropdown-toggle",
                           text: label)
    end

    def open_dropdown(type)
      find("##{type.downcase}-dropdown-navitem a.dropdown-toggle").click
    end

    def should_see_dropdown_items(**options)
      options.each do |type, items|
        open_dropdown(type)
        all("##{type}-dropdown-navitem ul li a").each do |item|
          next if ['Any', 'Manage...'].include?(item[:text])
          items.should include(item[:text])
        end
      end
    end

    def should_see_dropdown_item(type:, label:)
      open_dropdown(type)
      page.should have_css("##{type.downcase}-dropdown-navitem ul li a",
                           text: label)
    end

    def should_not_see_dropdown_item(type:, label:)
      open_dropdown(type)
      page.should_not have_css("##{type.downcase}-dropdown-navitem ul li a",
                               text: label)
    end

    def click_all_todos_button
      find('#all-todos-button').click
    end

    def select_dropdown_item(type:, label:)
      open_dropdown(type)
      find("##{type.downcase}-dropdown-navitem ul li a", text: label).click
    end

    def should_see_filter_header(header)
      page.should have_css('#filter', text: header)
    end
  end
end

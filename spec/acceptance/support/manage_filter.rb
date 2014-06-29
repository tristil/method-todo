module Acceptance
  module ManageFilter
    def open_manage_filter_dialog(type)
      select_dropdown_item(type: type, label: 'Manage...')
    end

    def within_manage_filter_dialog(&block)
      within('#manage-filters-modal', &block)
    end

    def should_see_manage_filter_items(*items)
      all('td.remove-filter-name').each do |item|
        items.should include(item.text)
      end
    end

    def click_delete_filter(name)
      find("tr[data-filter_name='#{name}'] a.remove-filter-button").click
    end

    def click_delete_filter_accept_button
      find('#remove-filter-button-final').click
    end

    def click_delete_filter_cancel_button
      find('#cancel-filter-removal-confirmation-dialog').click
    end

    def delete_filter(name)
      click_delete_filter(name)
      click_delete_filter_accept_button
    end

    def close_manage_filter_dialog
      find('#close-manage-filters-modal').click
    end
  end
end

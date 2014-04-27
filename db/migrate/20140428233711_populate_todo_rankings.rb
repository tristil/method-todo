class PopulateTodoRankings < ActiveRecord::Migration
  def up
    User.all.each do |user|
      ranking = 1
      user.todos.order('created_at DESC').each do |todo|
        todo.update_column(:ranking, ranking)
        ranking += 1
      end
    end
  end

  def down
  end
end

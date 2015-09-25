class AddClassroomToUsers < ActiveRecord::Migration
  def up
    add_reference :users, :classroom, index: true
    links = Classroom.pluck(:id, :user_id)
    links.each{ |cr_id, u_id| User.find(u_id).update_column(:classroom_id, cr_id) if u_id }
    remove_reference :classrooms, :user, index: true
  end
  def down
    add_reference :classrooms, :user, index: true
    links = User.pluck(:id, :classroom_id)
    links.each{ |u_id, cr_id| Classroom.find(cr_id).update_column(:user_id, u_id) if cr_id }
    remove_reference :users, :classroom, index: true
  end
end

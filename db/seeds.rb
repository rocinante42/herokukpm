#/////////////////////Roles/////////////////////////
 "Creating Admin Role"
role_1 = Role.find_or_create_by({
  name: "Admin",
  description: "Can perform any CRUD operation on any resource"
 })

p "Creating Teacher  Role"
role_2 = Role.find_or_create_by({
  name: "Teacher",
  description: "Can look and choose classrooms,can CRUD operation with children, can create and read report  by to  each of children, can choose activities for classrooms and individuals"
  })
#/////////////////////Users//////////////////////////
p "Creating Admin User"
user_1 = User.create({
  first_name: "Sem ",
  last_name:"Sem" ,
  direct_phone:"123-123-1231" ,
  email: "admin@test.com",
  password: "password",
  password_confirmation: "password",
  role_id: role_1.id
  })

p "Creating Teacher User"
user_2 = User.create({
  first_name: "Sue ",
  last_name:"Sue" ,
  direct_phone:"123-123-1232" ,
  email: "teacher@test.com",
  password: "password",
  password_confirmation: "password",
  role_id: role_2.id
   })

p "Creating Teacher User 1"
user_3 = User.create({
  first_name: "Ogi",
  last_name:"Rock" ,
  direct_phone:"123-123-1233" ,
  email: "teacher1@test.com",
  password: "password",
  password_confirmation: "password",
  role_id: role_2.id
   })
#/////////////////////Class Type//////////////////////////
p "Creating Class Type Kindergarten"
type_1 = ClassroomType.find_or_create_by({
  type_name: "Kindergarten",
  type_description:"Children with age from 3  to 6 years old"
   })

p "Creating Class Type First grade"
type_2 = ClassroomType.find_or_create_by({
  type_name: "First grade",
  type_description:"Children with age from 6  to 8 years old"
  })

#////////////////////School///////////////////////////
p "Creating School"
school_1 = School.find_or_create_by({
  name: "BestTeam"
  })

#////////////////////Classrooms///////////////////////////
p "Creating Classroom_1"
classroom_1 = Classroom.find_or_create_by({
  name: "Clever",
  classroom_type_id: type_1.id,
  user_id: user_2.id,
  school_id:school_1.id
  })

p "Creating Classroom_2"
classroom_2 = Classroom.find_or_create_by({
    name: "Smart",
    classroom_type_id: type_2.id,
    user_id: user_3.id,
    school_id:school_1.id
    })

#/////////////////////GAME////////////////////
p"Creating Games"

game_1 = Game.find_or_create_by({
 name: "bird-monkey",
 description: "this is the usual name"
 })

game_2 = Game.find_or_create_by({
 name: "sheep",
 description: "addition and subtraction"
 })

game_3 = Game.find_or_create_by({
 name: "microscope",
 description: "count in base 10"
 })

game_4 = Game.find_or_create_by({
 name: "rolling balls",
 description: "Produce in base 10"
 })

game_5 = Game.find_or_create_by({
 name: "path_forest",
 description: "Place numbers in the line"
 })

#/////////////////////Kid////////////////////
p"Creating Kids"

kid_1 = Kid.find_or_create_by({
  login_id: 1,
  classroom_id: classroom_1.id,
  age: 5,
  first_name: "Rita",
  last_name: "Ora",
  gender: 2,
  primary_language: "ENG"
  })

kid_2 = Kid.find_or_create_by({
  login_id: 2,
  classroom_id: classroom_2.id,
  age: 7,
  first_name: "Juo",
  last_name: "Lu",
  gender: 1,
  primary_language: "ENG"
  })

kid_3 = Kid.find_or_create_by({
  login_id: 3,
  classroom_id: classroom_1.id,
  age: 5,
  first_name: "Hesus",
  last_name: "Carero",
  gender: 1,
  primary_language: "ESP"
  })

kid_4 = Kid.find_or_create_by({
  login_id: 4,
  classroom_id: classroom_2.id,
  age: 6,
  first_name: "Mimi",
  last_name: "Bregovich",
  gender: 2,
  primary_language: "ESP"
  })

kid_5 = Kid.find_or_create_by({
  login_id: 5,
  classroom_id: classroom_2.id,
  age: 5,
  first_name: "Joseph",
  last_name: "Grosshpilier",
  gender: 1,
  primary_language: "ENG"
  })

p"Creating Posets and Bubbles"
require 'csv'
require 'zip'
require 'tempfile'

Zip::File.open('./db/bubble_groups.zip') do |zip_file|
  # Handle entries one by one
  zip_file.each do |entry|
    next if entry.name =~ /__MACOSX/ or entry.name =~ /\.DS_Store/ or entry.file? or entry.name.eql? 'bubble_groups/'
    puts "Extracting directory #{entry.name}"
    bubble_group = BubbleGroup.find_or_create_by(name: entry.name.split('/').last)

    ##Create bubbles
    bubble_tmp_file = Tempfile.new("bubble_tmp_file")
    bubble_stream = zip_file.find_entry("#{entry.name}bubbles.csv").get_input_stream.read
    bubble_tmp_file.write bubble_stream
    bubble_tmp_file.rewind
    bubble_arr = Bubble.create_from_csv bubble_tmp_file, {bubble_group: bubble_group}
    bubbles = Bubble.where(id: bubble_arr.collect{ |b| b.id })
    bubble_tmp_file.close
    bubble_tmp_file.unlink

    ##Create posets
    %w(forward backward full).each do |poset_type|
      poset_file = Tempfile.new("#{poset_type}_file")
      poset_stream = zip_file.find_entry("#{entry.name}#{poset_type}_poset.csv").get_input_stream.read
      poset_file.write poset_stream
      poset_file.rewind
      poset_data = Poset.create_from_csv(poset_file, bubbles, {name: "#{bubble_group.name} -- #{poset_type.capitalize} Poset"})
      bubble_group.send("#{poset_type}_poset=", poset_data) if poset_data
      poset_file.close
      poset_file.unlink
    end

    ##Create bubble cateogries
    category_tmp_file = Tempfile.new("category_tmp_file")
    category_stream = zip_file.find_entry("#{entry.name}bubble_categories.csv").get_input_stream.read
    category_tmp_file.write category_stream
    category_tmp_file.rewind
    BubbleCategory.create_from_csv(category_tmp_file, bubble_group: bubble_group)
    category_tmp_file.close
    category_tmp_file.unlink

    ##Create bubble games
    game_tmp_file = Tempfile.new("game_tmp_file")
    game_tmp_stream = zip_file.find_entry("#{entry.name}bubble_games.csv").get_input_stream.read
    game_tmp_file.write game_tmp_stream
    game_tmp_file.rewind
    BubbleGame.create_from_csv(game_tmp_file, bubble_group, {})
    game_tmp_file.close
    game_tmp_file.unlink

    bubble_group.save
  end
end

##adding bubble groups to classroom types(Kindergarten, First Grade)
common_groups = BubbleGroup.where(name: ['Base 10 How Many', 'Base 10 Produce', 'Addition and Subtraction Count All', 'Counting and Cardinality to 20', 'Number Line Model'])
type_1.bubble_groups << common_groups
type_2.bubble_groups << common_groups + BubbleGroup.where(name: ['Addition and Subtraction Comparison', 'Addition and Subtraction Count On'])

##create triggers from csv file
Trigger.create_from_csv File.open("./db/triggers.csv")

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

p "Creating Class Type Subitize"
type_3 = ClassroomType.find_or_create_by({
  type_name: "Subitize",
  type_description:"This is a test"
  })


p"Creating Posets and Bubbles"
require 'csv'
require 'zip'
require 'tempfile'

Zip::File.open('./db/bubble_groups2.zip') do |zip_file|
  # Handle entries one by one
  ["Counting and Cardinality to 20", "Base 10 How Many", "Base 10 Produce",
   "Number Line Model", "Addition and Subtraction Count All", "Addition and Subtraction Count On",
   "Addition and Subtraction Compare", "AdditionSubtracionDiagrams", "base10Feb2016", "Mult-DivFeb2016", "Ordinal"
   ].each{ |bg_name| BubbleGroup.find_or_create_by(name: bg_name) }
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
common_groups = BubbleGroup.where(name: ['Counting and Cardinality to 20', 'Base 10 How Many', 'Base 10 Produce', 'Number Line Model', 'Addition and Subtraction Count All'])
type_1.bubble_groups << common_groups
type_2.bubble_groups << common_groups + BubbleGroup.where(name: ['Addition and Subtraction Count On', 'Addition and Subtraction Compare'])

##adding custom bubble categories to classroom types (Kindergarten, First Grade)
custom_categories = {
  # Kindergarten:
  type_1 => {
    'Addition and Subtraction Count All' => ['1-5', '6-10'],
    'Base 10 How Many' => ['1-10', '11-20'],
    'Base 10 Produce' => ['1-10', '11-20']
  },
  # First Grade
  type_2 => {
    'Addition and Subtraction Count On' => ['1-5', '6-10', '11-15', '16-20']
  }
}

[type_1, type_2].each do |ct|
  ct.bubble_categories = []
  ct.bubble_groups.each do |bg|
    cats = bg.bubble_categories.to_a
    cats = cats.select{|bc| bc.name.in? custom_categories[ct][bg.name] } if custom_categories[ct].has_key? bg.name
    ct.bubble_categories += cats
  end
end
#/////////////////////Roles/////////////////////////
p "Creating Admin Role"
super_role = Role.find_or_create_by({
  name: "Admin",
  description: "Can perform any CRUD operation on any resource"
 })

p "Creating Teacher Admin Role"
teacher_admin_role = Role.find_or_create_by({
  name: "Teacher Admin",
  description: "Can create, edit, delete teachers, kids, and parents, and has access to all classrooms in the school"
  })

p "Creating Teacher  Role"
teacher_role = Role.find_or_create_by({
  name: "Teacher",
  description: "Can look and choose classrooms,can CRUD operation with children, can create and read report  by to  each of children, can choose activities for classrooms and individuals"
  })
p "Creating Parent  Role"
parent_role = Role.find_or_create_by({
  name: "Parent",
  description: "Has access to the kid’s reports only"
  })
#////////////////////School///////////////////////////
p "Creating School"
school_1 = School.find_or_create_by({
  name: "Pilot"
  })

p "Creating Teacher Administrator for School"

User.new({
  first_name: "Mark",
  last_name:"Strong" ,
  direct_phone:"123-123-1233" ,
  email: "teacher_admin@test.com",
  password: "password",
  password_confirmation: "password",
  role: teacher_admin_role,
  school: school_1
   }).save(validate:false)

#////////////////////Classrooms///////////////////////////
p "Creating Classroom_1"
classroom_1 = Classroom.find_or_create_by({
  name: "A",
  classroom_type_id: type_1.id,
  school_id:school_1.id
  })

p "Creating Classroom_2"
classroom_2 = Classroom.find_or_create_by({
  name: "B",
  classroom_type_id: type_2.id,
  school_id:school_1.id
  })

#/////////////////////Users//////////////////////////
p "Creating Admin User"
user_1 = User.new({
  first_name: "Admin",
  last_name:"Admin" ,
  direct_phone:"123-123-1231",
  email: "admin@test.com",
  password: "password",
  password_confirmation: "password",
  role: super_role
  })
user_1.save(validate:false)
p "Creating Teacher User"
user_2 = User.new({
  first_name: "Sue",
  last_name:"Sue" ,
  direct_phone:"123-123-1232" ,
  email: "teacher@test.com",
  password: "password",
  password_confirmation: "password",
  role: teacher_role,
  school: school_1,
  classroom: classroom_1
   })
user_2.save(validate:false)
p "Creating Teacher User 1"
user_3 = User.new({
  first_name: "Ogi",
  last_name:"Rock" ,
  direct_phone:"123-123-1233" ,
  email: "teacher1@test.com",
  password: "password",
  password_confirmation: "password",
  role: teacher_role,
  school: school_1,
  classroom: classroom_2
   })
user_3.save(validate:false)
p "Creating Parent User"
parent_carero = User.new({
  first_name: "Victor",
  last_name:"Carero" ,
  direct_phone:"123-123-1233" ,
  email: "carero@test.com",
  password: "password",
  password_confirmation: "password",
  role: parent_role
   })
p "Creating Admin User"
user_4 = User.new({
  first_name: "Admin2",
  last_name:"Admin2" ,
  direct_phone:"123-123-1231",
  email: "admin2@test.com",
  password: "password",
  password_confirmation: "password",
  role: super_role
  })
user_4.save(validate:false)
parent_carero.save(validate:false)
parent_ora = User.new({
  first_name: "Mike",
  last_name:"Ora" ,
  direct_phone:"123-123-1233" ,
  email: "ora@test.com",
  password: "password",
  password_confirmation: "password",
  role: parent_role
   })
parent_ora.save(validate:false)
parent_lu = User.new({
  first_name: "Jecky",
  last_name:"Lu" ,
  direct_phone:"123-123-1233" ,
  email: "lu@test.com",
  password: "password",
  password_confirmation: "password",
  role: parent_role
   })
parent_lu.save(validate:false)
parent_bregovich = User.new({
  first_name: "Phillip",
  last_name:"Bregovich" ,
  direct_phone:"123-123-1233" ,
  email: "bregovich@test.com",
  password: "password",
  password_confirmation: "password",
  role: parent_role
   })
parent_bregovich.save(validate:false)
parent_gross = User.new({
  first_name: "Steven",
  last_name:"Grosshpilier" ,
  direct_phone:"123-123-1233" ,
  email: "gross@test.com",
  password: "password",
  password_confirmation: "password",
  role: parent_role
   })
parent_gross.save(validate:false)
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

kid_ora = Kid.find_or_create_by({
  login_id: 1,
  classroom_id: classroom_1.id,
  age: 5,
  first_name: "Rita",
  last_name: "Ora",
  gender: 2,
  primary_language: "ENG"
  })

kid_lu = Kid.find_or_create_by({
  login_id: 2,
  classroom_id: classroom_2.id,
  age: 7,
  first_name: "Juo",
  last_name: "Lu",
  gender: 1,
  primary_language: "ENG"
  })

kid_carero = Kid.find_or_create_by({
  login_id: 3,
  classroom_id: classroom_1.id,
  age: 5,
  first_name: "Hesus",
  last_name: "Carero",
  gender: 1,
  primary_language: "ESP"
  })

kid_bregovich = Kid.find_or_create_by({
  login_id: 4,
  classroom_id: classroom_2.id,
  age: 6,
  first_name: "Mimi",
  last_name: "Bregovich",
  gender: 2,
  primary_language: "ESP"
  })

kid_gross = Kid.find_or_create_by({
  login_id: 5,
  classroom_id: classroom_2.id,
  age: 5,
  first_name: "Joseph",
  last_name: "Grosshpilier",
  gender: 1,
  primary_language: "ENG"
  })

p "Creating family relationships between kids and parents"

FamilyRelationship.create!(kid: kid_ora, parent: parent_ora)
FamilyRelationship.create!(kid: kid_lu, parent: parent_lu)
FamilyRelationship.create!(kid: kid_carero, parent: parent_carero)
FamilyRelationship.create!(kid: kid_bregovich, parent: parent_bregovich)
FamilyRelationship.create!(kid: kid_gross, parent: parent_gross)

##create triggers from csv file
Trigger.create_from_csv File.open("./db/triggers.csv")

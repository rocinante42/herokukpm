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

#/////////////////Bubble Categories///////////////
p "Creating Categories Cardinality"
categorie_1 = BubbleCategory.find_or_create_by({name: "Cardinality5"})
categorie_2 = BubbleCategory.find_or_create_by({name: "Cardinality10"})
categorie_3 = BubbleCategory.find_or_create_by({name: "Cardinality15"})
categorie_4 = BubbleCategory.find_or_create_by({name: "Cardinality20"})
p "Creating Categories Base10-Produce"
categorie_5 = BubbleCategory.find_or_create_by({name: "Base10-Produce_10"})
categorie_6 = BubbleCategory.find_or_create_by({name: "Base10-Produce_20"})
categorie_7 = BubbleCategory.find_or_create_by({name: "Base10-Produce_30"})
categorie_8 = BubbleCategory.find_or_create_by({name: "Base10-Produce_40"})
p "Creating Categories Base10-count"
categorie_9 = BubbleCategory.find_or_create_by({name: "Base10-count_10"})
categorie_10 = BubbleCategory.find_or_create_by({name: "Base10-count_20"})
categorie_11 = BubbleCategory.find_or_create_by({name: "Base10-count_30"})
categorie_12 = BubbleCategory.find_or_create_by({name: "Base10-count_40"})
p "Creating Categories NumberLine"
categorie_13 = BubbleCategory.find_or_create_by({name: "NumberLine_10"})
categorie_14 = BubbleCategory.find_or_create_by({name: "NumberLine_20"})
categorie_15 = BubbleCategory.find_or_create_by({name: "NumberLine_70"})
categorie_16 = BubbleCategory.find_or_create_by({name: "NumberLine_120"})
p "Creating Categories CountAll"
categorie_17 = BubbleCategory.find_or_create_by({name: "CountAll_5"})
categorie_18 = BubbleCategory.find_or_create_by({name: "CountAll_10"})
categorie_19 = BubbleCategory.find_or_create_by({name: "CountAll_15"})
categorie_20 = BubbleCategory.find_or_create_by({name: "CountAll_20"})
p "Creating Categories CountOn"
categorie_21 = BubbleCategory.find_or_create_by({name: "CountOn_5"})
categorie_22 = BubbleCategory.find_or_create_by({name: "CountOn_10"})
categorie_23 = BubbleCategory.find_or_create_by({name: "CountOn_15"})
categorie_24 = BubbleCategory.find_or_create_by({name: "CountOn_20"})
p "Creating Categories Comparison"
categorie_25 = BubbleCategory.find_or_create_by({name: "Comparison_5"})
categorie_26 = BubbleCategory.find_or_create_by({name: "Comparison_10"})
categorie_27 = BubbleCategory.find_or_create_by({name: "Comparison_15"})
categorie_28 = BubbleCategory.find_or_create_by({name: "Comparison_20"})

#/////////////////Bubble Groups///////////////
p "Creating Bubble Groups"
@bubble_group = BubbleGroup.find_or_create_by({
  name: "New Count to 20",
  description: "Counting and Cardinality"
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
group_name = @bubble_group.name
bubble_file = File.open("./db/bubbles.csv")
full_poset_file = File.open("./db/full_poset.csv")
forward_poset_file = File.open("./db/forward_poset.csv")
backward_poset_file = File.open("./db/backward_poset.csv")
bubble_arr = Bubble.create_from_csv bubble_file, {bubble_group: @bubble_group}
bubbles = Bubble.where(id: bubble_arr.collect{ |b| b.id })

full_poset = Poset.create_from_csv(full_poset_file, bubbles, {name: "#{group_name} -- Full Poset"})
forward_poset = Poset.create_from_csv(forward_poset_file, bubbles, {name: "#{group_name} -- Forward Poset"})
backward_poset = Poset.create_from_csv(backward_poset_file, bubbles, {name: "#{group_name} -- Backward Poset"})

@bubble_group.full_poset = full_poset if full_poset
@bubble_group.forward_poset = forward_poset if forward_poset
@bubble_group.backward_poset = backward_poset if backward_poset

@bubble_group.save

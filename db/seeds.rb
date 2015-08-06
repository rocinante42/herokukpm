p "Creating Admin Role"
role_1 = Role.find_or_create_by({
  name: "Admin",
  description: "Can perform any CRUD operation on any resource"
 })

p "Creating Teacher  Role"
role_2 = Role.find_or_create_by({
  name: "Teacher",
  description: "Can look and choose classrooms,can CRUD operation with children, can create and read report  by to  each of children, can choose activities for classrooms and individuals"
  })

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


p "Creating School"
school_1 = School.find_or_create_by({
  name: "BestTeam"
  })

p "Creating Classroom_1"
classroom_1 = Classroom.find_or_create_by({
  name: "Clever",
  classroom_type_id: type_1.id,
  user_id: user_2.id,
  school_id:school_1.id
  })

p "Creating Classroom_2"
classroom_1 = Classroom.find_or_create_by({
    name: "Smart",
    classroom_type_id: type_2.id,
    user_id: user_3.id,
    school_id:school_1.id
    })

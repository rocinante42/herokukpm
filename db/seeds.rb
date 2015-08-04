p "Creating Admin Role"
role_1 = Role.create({
  name: "Admin",
  description: "Can perform any CRUD operation on any resource"
 })

p "Creating Teacher  Role"
role_2 = Role.create({
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

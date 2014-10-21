# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#students = Student.create({first_name: '', last_name: '', age: , location: '', primary_language: 'EN', game_language: 'EN', first_time:true, classroom_id:1}
#)
Classroom.create({ name: 'Chemistry' })
Classroom.create({ name: 'Economics'})

Student.create({first_name: 'Pam', last_name: 'Dyson', age: 18 , location: 'Newark, New Jersey', primary_language: 'EN', game_language: 'EN', first_time: true, classroom_id: 1})
Student.create({first_name: 'Raymon', last_name: 'Haugen', age:18, location: 'Chicago, Illinois', primary_language: 'EN', game_language: 'EN', first_time: true, classroom_id: 1})
Student.create({first_name: 'Travis', last_name: 'Everson', age: 21, location: 'St. Petersburg, Florida', primary_language: 'EN', game_language: 'EN', first_time: true, classroom_id: 2})
Student.create({first_name: 'Bernita', last_name: 'Hosack', age: 22, location: 'El Paso, Texas', primary_language: 'EN', game_language: 'EN', first_time: true, classroom_id: 2})
Student.create({first_name: 'Vita', last_name: 'Mcarthur', age: 17, location: 'Buffalo, New York', primary_language: 'EN', game_language: 'EN', first_time: true, classroom_id: 2})
Student.create({first_name: 'Naomi', last_name: 'Schueler', age: 22, location: 'Memphis, Tennessee', primary_language: 'EN', game_language: 'EN', first_time: true, classroom_id: 2})
Student.create({first_name: 'Laurette', last_name: 'Renick', age: 21, location: 'Fresno, California', primary_language: 'EN', game_language: 'EN', first_time: true, classroom_id:1})
Student.create({first_name: 'Elmira', last_name: 'Joshua', age: 24, location: 'North Hempstead, New York', primary_language: 'EN', game_language: 'EN', first_time: true, classroom_id:1})
Student.create({first_name: 'Eden', last_name: 'Beaudet', age: 23, location: 'Seattle, Washington', primary_language: 'EN', game_language: 'EN', first_time: true, classroom_id:2})
Student.create({first_name: 'Lourie', last_name: 'Felker', age: 24, location: 'Anaheim, California', primary_language: 'EN', game_language: 'EN', first_time: true, classroom_id:2})
Student.create({first_name: 'Earline', last_name: 'Wardle', age: 20, location: 'Minneapolis, Minnesota', primary_language: 'EN', game_language: 'EN', first_time: true, classroom_id:1})
Student.create({first_name: 'Spencer', last_name: 'Buff', age: 19, location: 'Akron, Ohio', primary_language: 'EN', game_language: 'EN', first_time: true, classroom_id:1})
Student.create({first_name: 'Luke', last_name: 'Nielsen', age: 18, location: 'Portland, Oregon', primary_language: 'EN', game_language: 'EN', first_time: true, classroom_id:2})
Student.create({first_name: 'Ossie', last_name: 'Teel', age: 20, location: 'Omaha, Nebraska', primary_language: 'EN', game_language: 'EN', first_time: true, classroom_id:1})
Student.create({first_name: 'Iraida', last_name: 'Stuckey', age: 22, location: 'Columbus, Ohio', primary_language: 'EN', game_language: 'EN', first_time: true, classroom_id:2})
Student.create({first_name: 'Bradley', last_name: 'Bowerman', age: 21, location: 'Montgomery, Alabama', primary_language: 'EN', game_language: 'EN', first_time: true, classroom_id:1})
Student.create({first_name: 'Jerlene', last_name: 'Rappaport', age: 23, location: 'Charlotte, North Carolina', primary_language: 'EN', game_language: 'EN', first_time: true, classroom_id:1})
Student.create({first_name: 'Emerald', last_name: 'Mosby', age: 24, location: 'Anaheim, California', primary_language: 'EN', game_language: 'EN', first_time: true, classroom_id:2})
Student.create({first_name: 'Lonny', last_name: 'Borgman', age: 25, location: 'Cincinnati, Ohio', primary_language: 'EN', game_language: 'EN', first_time: true, classroom_id:2})
Student.create({first_name: 'Kathryne', last_name: 'Zumwalt', age: 26, location: 'Akron, Ohio', primary_language: 'EN', game_language: 'EN', first_time: true, classroom_id:1})

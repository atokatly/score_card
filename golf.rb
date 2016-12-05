# require gems #
require 'sqlite3'

# Create database #
db = SQLite3::Database.new("score_card.db")
db.results_as_hash = true


# Create tables #
create_table_cmd = <<-SQL
  CREATE TABLE IF NOT EXISTS player (
    id INTEGER PRIMARY KEY,
    name VARCHAR(255),
    age INT
  )
SQL

create_table2_cmd = <<-SQL
  CREATE TABLE IF NOT EXISTS score (
    id INTEGER PRIMARY KEY,
    course VARCHAR(255),
    score INT,
    player_id INT,
    FOREIGN KEY (player_id) REFERENCES player(id)
  )
SQL

# Methods to add, manipulate, and view data #
def create_player(db, name, age)
	db.execute("Insert into player (name, age) Values ('#{name}', #{age})")
end

def add_score(db, course, score, player_id)
	db.execute("Insert into score (course, score, player_id) Values ('#{course}', #{score}, #{player_id});")
end

# All player scores #
def display_score(db)
	output = db.execute("select player.name, score.course, score.score from player, score where score.player_id = player.id order by score.score, player.name")
	output.each do |user|
		puts "#{user['name']} | #{user['course']} | #{user['score']}"
	end
end 

# individuals scores #
def my_score(db, name)
	output = db.execute("select player.name, score.course, score.score from player, score where score.player_id = player.id order by score.score")
		output.each do |user|
			if user['name'] == name
				puts "#{user['name']} | #{user['course']} | #{user['score']}"
			end
		end
end

def delete_score(db, course, score)
	db.execute("Delete from score Where score=#{score} And course='#{course}'")
end 

def update_score(db, course, new_score, score)
	db.execute("Update score SET score = #{new_score} Where score=#{score} And course='#{course}'")
end

# create table #
db.execute(create_table_cmd)
db.execute(create_table2_cmd)

# Variables for driver code #
user = ''
name = ''
age = ''
course = ''
scores = ''
player_id = ''

# Find out if user exits already #
puts "Have you ever used our score card system before? (y/n)"
user = gets.chomp
	if user == 'y'
		puts "Please enter your name."
		name = gets.chomp
		# If doesn't exist, create user #
	else puts "Thanks for trying our score card for the first time!"
	 	puts "What's your full name? (Ex: 'Anthony Tokatly')"
	 	name = gets.chomp
	 	puts "What's your age?"
	 	age = gets.chomp
	 	age = age.to_i
	 	create_player(db, name, age)
	end

player = db.execute("Select * from player")
score = db.execute("Select * from score")
puts "We recommend you check out all our scores before you continue with the 'display all scores' command."
word = ''
until word == "exit"
	player = db.execute("Select * from player")
	score = db.execute("Select * from score")
	puts "What would you like to do? (Ex: 'add score', 'display my scores', 'display all scores', 'update score', 'delete score' or type 'exit')"

	word = gets.chomp
		if word == "exit"
			break
		elsif word == 'add score'
			puts "What's the name of your course?"
			course = gets.chomp
			puts "What was your score?"
			score = gets.chomp
			score = score.to_i
			player.each do |user| 
				if user['name'] == name 
					player_id = user['id']
				else 
				end
		end
		add_score(db, course, score, player_id)

		elsif word == 'display all scores'
			puts "-------------------"
			display_score(db)
			puts "-------------------"
		#end
			

		elsif word == 'update score'
			new_score = ''
			puts "What's your new score? (ex: 72)"
			new_score = gets.chomp
			new_score = new_score.to_i
			puts "What's your old score?"
			scores = gets.chomp
			scores = scores.to_i
			puts "What's the name of the course you played at?"
			course = gets.chomp
			score.each do |user|
				if user['score'] == scores 
					player_id = user['id']
				#p player_id
				else 
				end
			end 
		update_score(db, course, new_score, scores)

		elsif word == 'delete score'
			puts "What's your old score you'd like delete? (ex: 72)"
			scores = gets.chomp
			scores = scores.to_i
			puts "What was the course name?"
			course = gets.chomp
			score.each do |user|
				if user['score'] == scores 
					player_id = user['id']
				#p player_id
				else 
				end
			end 
		delete_score(db, course, scores)
		
		else word == 'display my scores'
			puts "------------------"
			my_score(db, name)
			puts "------------------"
		end
end
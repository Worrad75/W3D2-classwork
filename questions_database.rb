require 'sqlite3'
require 'singleton'
require 'byebug'

class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db') # creates SQL syntax in ruby wrapper
    self.type_translation = true
    self.results_as_hash = true
  end

end


class Question
  attr_accessor :id, :title, :body, :author_id

  def self.find_by_id(id)
    # --should it be self.id if its calling itself?
    questions = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      questions
    WHERE
      id = ?
  SQL
  return nil unless questions.length > 0
  Question.new(questions.first) #question is stored i.n an array
  end


  def self.find_by_author_id(author_id)
    author = QuestionsDatabase.instance.execute(<<-SQL, author_id)
    SELECT
      *
    FROM
      questions
    WHERE
      author_id = ?
  SQL
  return nil unless author.length > 0
  author.map { |datum| Question.new(datum)}
  end


  
  def initialize(options) ##method should take an options hash of attributes and construct an object
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end

  def author
    self.author
  end

  def replies
    Reply.find_by_question_id(question_id)
  end
    
end


class User
  attr_accessor :id, :fname, :lname

  def self.find_by_id(id)
    users = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      users
    WHERE
      id = ?
  SQL
  return nil unless users.length > 0
  User.new(users.first) #question is stored in an array
  end
  

  def self.find_by_name(fname, lname)
    users = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
    SELECT
      *
    FROM
      users 
    WHERE
      fname = ? AND lname = ?
  SQL
  return nil unless users.length > 0
  User.new(users.first)
  end

  def initialize(options) ##method should take an options hash of attributes and construct an object
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def authored_questions
  Question.find_by_author_id(id)
  end

  def authored_replies
  Reply.find_by_user_id(id)
  end
end


class Reply
  attr_accessor :id, :body, :question_id, :parent_reply_id, :author_id, :user_id
  
  def self.find_by_id(id)
    reply = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      replies
    WHERE
      id = ?  
  SQL
  return nil unless reply.length > 0
  Question.new(reply.first) #question is stored i.n an array
  end



  def self.find_by_user_id(user_id)
    person = QuestionsDatabase.instance.execute(<<-SQL, user_id)
    SELECT
      *
    FROM
      replies
    WHERE
      author_id = ?
  SQL
  return nil unless person.length > 0
  person.map { |datum| Reply.new(datum)}
  end

  def self.find_by_question_id(question_id)
     question = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      *
    FROM
      replies
    WHERE
      question_id = ?
  SQL
  return nil unless question.length > 0
  Reply.new(question.first)
  end

  def initialize(options) ##method should take an options hash of attributes and construct an object
    @id = options['id']
    @body = options['body']
    @question_id = options['question_id']
    @parent_reply_id = options['parent_reply_id']
    @author_id = options['author_id']
  end

  def author
    self.author
  end

end


class Question_follow
  attr_accessor :id, :user_id, :question_id
  def self.find_by_id(id)
    question = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      users
    WHERE
      id = ?
  SQL
  end

  def initialize(options) ##method should take an options hash of attributes and construct an object
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end

end


class Question_like
  attr_accessor :id, :user_id, :question_id
  def self.find_by_id(id)
    question_likes = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      users
    WHERE
      id = ?
  SQL
  end

  def initialize(options) ##method should take an options hash of attributes and construct an object
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end

end


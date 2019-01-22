require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
  
end

class Question
  attr_accessor :id, :title, :body, :author_id


  def self.find_by_id(id)
    data_table = QuestionsDatabase.instance.execute(<<~SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL

    Question.new(data_table.first)
  end

  def self.find_by_author_id(author_id)
    data_table = QuestionsDatabase.instance.execute(<<~SQL, author_id)
      SELECT
        *
      FROM
        questions
      WHERE
        author_id = ?
    SQL

    result = []
    data_table.each do |el|
      result << Question.new(el)
    end
    result
  end


  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end

end

class User
  attr_accessor :id, :fname, :lname


  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end
  
  def self.find_by_id(id)
    data_table = QuestionsDatabase.instance.execute(<<~SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL
    User.new(data_table.first)
  end

  def self.find_by_name(fname = nil, lname = nil)
    raise' You are not doing this right' if fname.nil? && lname.nil?
    if fname.nil?
      data_table = QuestionsDatabase.instance.execute(<<~SQL, lname)
      SELECT
        *
      FROM
        users
      WHERE
        lname = ?
      SQL
      User.new(data_table.first)
    elsif lname.nil?
      data_table = QuestionsDatabase.instance.execute(<<~SQL, fname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ? 
      SQL
      User.new(data_table.first)
    else
      data_table = QuestionsDatabase.instance.execute(<<~SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ? AND
        lname = ?
      SQL
      User.new(data_table.first)
    end
  end

  def authored_questions
    Question.find_by_author_id(id)
  end
 
end

class QuestionFollows
  attr_accessor :id, :question_id, :user_id

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end
  
  def self.find_by_question_id(question_id)
    data_table = QuestionsDatabase.instance.execute(<<~SQL, question_id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        question_id = ?
    SQL
    QuestionFollows.new(data_table.first)
  end

  def self.find_by_user_id(user_id)
    data_table = QuestionsDatabase.instance.execute(<<~SQL, user_id)
    SELECT
      *
    FROM
      question_follows
    WHERE
      user_id = ?
    SQL
    QuestionFollows.new(data_table.first)
  end
 
end

class QuestionLikes
  attr_accessor :id, :user_id, :question_id

  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end
  
  def self.find_by_question_id(question_id)
    data_table = QuestionsDatabase.instance.execute(<<~SQL, question_id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        question_id = ?
    SQL
    QuestionLikes.new(data_table.first)
  end

  def self.find_by_user_id(user_id)
    data_table = QuestionsDatabase.instance.execute(<<~SQL, user_id)
    SELECT
      *
    FROM
      question_likes
    WHERE
      user_id = ?
    SQL
    QuestionLikes.new(data_table.first)
  end
end

class Replies
  attr_accessor :id, :question_id, :reply_id, :user_id, :reply

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @reply_id = options['reply_id']
    @user_id = options['user_id']
    @reply = options['reply']
  end
  
  def self.find_by_question_id(question_id)
    data_table = QuestionsDatabase.instance.execute(<<~SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?
    SQL
    Replies.new(data_table.first)
  end

  def self.find_by_reply_id(id)
    data_table = QuestionsDatabase.instance.execute(<<~SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
      SQL
    Replies.new(data_table.first)
  end

  def self.find_by_child_replies(reply_id)
    data_table = QuestionsDatabase.instance.execute(<<~SQL, reply_id)
      SELECT
        *
      FROM
        replies
      WHERE
        reply_id = ?
      SQL
    Replies.new(data_table.first)
  end

  def self.find_by_user_id(user_id)
    data_table = QuestionsDatabase.instance.execute(<<~SQL, user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = ?
      SQL
    Replies.new(data_table.first)
  end
end